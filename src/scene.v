module main

import os
import math
import rand

struct Camera {
	mut:
		pos Vec					// usually 0|0|0
		focal_length f64		// usually 1.0
		viewport_height f64		// usually 2.0
		viewport_width f64		// calculated from height based on img w and h
		pixel_delta_v f64		// calculated from viewport height
		pixel_delta_h f64		// calculated from viewport width
		top_left_pixel Vec		// calculated from all the above
}

struct Scene {
	bg_color ColorFloat
	depth int
	samples int
	mut:
		cam Camera
		hittable_objects []HittableObject
		light_sources []LightSource
}


fn init_scene(bg_color ColorFloat, samples int) Scene {
	// sane defaults
	cam := Camera{
		pos: Vec{0, 0, 0},
		focal_length: 1.0,
		viewport_height: 2.0
	}
	
	return Scene {
		bg_color: bg_color
		depth: 10
		samples: 10
		cam: cam
		hittable_objects: []HittableObject{}
	}
}

fn (mut s Scene) add_object(obj HittableObject) {
	s.hittable_objects << obj
}

fn (mut s Scene) add_light_source(source LightSource) {
	s.light_sources << source
}

fn setup_cam(w int, h int) Camera {
	pos := Vec{0, 0, 0}
	
	// calculate Viewport width
	// ratio between w and h
	aspect_ratio := f64(w) / f64(h)

	focal_length := 1.0

	// viewport_width is viewport_height multiplied by aspect_ratio
	viewport_height := 2.0
	viewport_width := viewport_height * aspect_ratio

	pixel_delta_v := viewport_height / f64(h) // pixel_delta_v (vertical) is viewport_height scaled by 1/h
	pixel_delta_h := viewport_width / f64(w) // pixel_delta_h (horizontal) is viewport_width scaled by 1/w

	on_z := pos + Vec{0, 0, focal_length}
	top_left_corner := on_z - Vec{viewport_width, 0, 0}.scale(.5) + Vec{0, viewport_height, 0}.scale(.5)
	top_left_pixel := top_left_corner + Vec{pixel_delta_h, 0, 0}.scale(.5) + Vec{0, -pixel_delta_v, 0}.scale(.5)
	

	return Camera{
		pos: pos,
		focal_length: focal_length,
		viewport_height: viewport_height,
		viewport_width: viewport_width,
		pixel_delta_v: pixel_delta_v,
		pixel_delta_h: pixel_delta_h,
		top_left_pixel: top_left_pixel
	}
}


fn (s Scene) get_ray(x, y int) Ray {
	pixel_center := s.cam.top_left_pixel + Vec{s.cam.pixel_delta_h, 0, 0}.scale(x) + Vec{0, -s.cam.pixel_delta_v, 0}.scale(y)

	py := -.5 + rand_f64(0, 1)
	px := -.5 + rand_f64(0, 1)

	pixel_sample := pixel_center + Vec{s.cam.pixel_delta_h, 0, 0}.scale(px) + Vec{0, -s.cam.pixel_delta_v, 0}.scale(py)

	r := Ray{s.cam.pos, pixel_sample.unit()} // todo: does this HAVE to be a unit vector?

	return r
}


fn (s Scene) has_line_of_sight(a Vec, b Vec) (bool) {
	r := Ray{a, (b - a).unit()}
	// check, intersection := r.nearest_intersection(s.hittable_objects) // * change here
	intersection := r.nearest_intersection(s.hittable_objects) or {
		return true // we got no intersection, we have a line of sight
	}

	// rare edgecase with intersection but not between a and b
	if intersection.t >= (b - a).length() { // * change here
		return true
	}
	
	// we got a valid intersection, so we do not have a line of sight
	return false
}


// this traces a ray and returns its color. It takes ambient and direct lighting into account
fn (s Scene) trace_ray(r Ray, depth int) ColorFloat {
	// if the ray doesnt intersect anything, its color is the background color
	intersection := r.nearest_intersection(s.hittable_objects) or {
		// return s.bg_color
		a := .5 * (r.direction.unit().y + 1)
		return ColorFloat{0.5, 0.7, 1.0}.scale(1 - a) + ColorFloat{1.0, 1.0, 1.0}.scale(a)

	}
	 
	// we have exceeded the recursion depth, no more light is gathered
	if depth <= 0 {
		return ColorFloat{0, 0, 0}
	}

	// the ray hit something, we now have to determine its color

	// calculate the contributeion of direct lighting
	direct := s.calculate_direct(intersection)

	// calculate the contribution of ambient lighting
	ambient := s.calculate_ambient(intersection, depth)

	// add them up, bring between 0 and 1
	
	return ColorFloat{
		r: math.min(1.0, (direct.r + ambient.r))
		g: math.min(1.0, (direct.g + ambient.g))
		b: math.min(1.0, (direct.b + ambient.b))
	}
}

fn (mut s Scene) render(path string, w int, h int) !{
	s.cam = setup_cam(w, h)
	
	mut f := os.open_file(path, "w")!
	
	f.write_string("P3\n${w} ${h}\n${255}\n")!

	// write the ppm file
	for y in 0 .. h {
		// progress bar
		print("\r")
		print("${y+1}/${h} lines")

		for x in 0 .. w {
			mut color_sampled := ColorFloat{0, 0, 0}

			for _ in 0..s.samples {
				r := s.get_ray(x, y)

				pixel := s.trace_ray(r, s.depth)

				color_sampled += pixel
			}

			// take the average
			scale := 1.0 / f64(s.samples)
			color_sampled = color_sampled.scale(scale)
			color_sampled_int := color_sampled.to_int()
			// println("${scale}, ${color_sampled}")
			
			f.write_string("${color_sampled_int.r} ${color_sampled_int.g} ${color_sampled_int.b}\n")!
		}
	}

	f.close()
}