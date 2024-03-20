module main

import os
import math

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
	mut:
		cam Camera
		hittable_objects []HittableObject
		light_sources []LightSource
} 


fn init_scene(bg_color ColorFloat) Scene {
	// sane defaults
	cam := Camera{
		pos: Vec{0, 0, 0},
		focal_length: 1.0,
		viewport_height: 2.0
	}
	
	return Scene {
		bg_color: bg_color
		depth: 10
		cam: cam
		hittable_objects: []HittableObject{}
	}
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
			pixel_center := s.cam.top_left_pixel + Vec{s.cam.pixel_delta_h, 0, 0}.scale(x) + Vec{0, -s.cam.pixel_delta_v, 0}.scale(y)
			r := Ray{s.cam.pos, pixel_center.unit()} 

			// trace the ray through the scene 
			pixel := s.trace_ray(r, s.depth).to_int()


			f.write_string("${pixel.r} ${pixel.g} ${pixel.b}\n")!
		}
	}

	f.close()
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


fn (s Scene) trace_ray(r Ray, depth int) ColorFloat {
	intersection := r.nearest_intersection(s.hittable_objects) or {
		// we got no intersection, so we can make the ray have the bg color
		// return s.bg_color

		// return lerped color (still no Idea how that works)
		a := .5 * (r.direction.unit().x + 1)
		return ColorFloat{1, 1, 1}.scale(1 - a) + ColorFloat{0.5, 0.7, 1.0}.scale(a)
	}
	
	// calculate color using true lambertian reflection ()

	// if intersection, get color of whatever was intersected 
	obj_color := intersection.solid.optics.matte_color

	// construct a new reflected ray
	direction := intersection.normal + rand_on_hemisphere(intersection.normal)
	child_ray := Ray{intersection.intersection_point, direction}

	// recursively calculate trace_ray to get the color
	calculated_color := s.trace_ray(child_ray, depth - 1).scale(0.5)

	return calculated_color
	// println(calculated_color)



	// shade green/red wether or not light can hit a point on the sphere
/*
	mut has := false

	if has {
		return ColorInt{0, 255, 0}
	} else {
		return ColorInt{255, 0, 0}
	}
	*/
	
	// return ColorFloat{255, 0, 0}
}

// ray color 

fn (s Scene) calculate_matte(i Intersection) ColorFloat {
	source := s.light_sources[0]

	if s.has_line_of_sight(i.intersection_point, source.pos) {
		obj_optics := i.solid.optics

		direction_to_source := (source.pos - i.intersection_point)
		incidence := i.normal.dot(direction_to_source.unit())

		scaled_color := obj_optics.matte_color.scale(incidence)

		// return scaled_color
		return scaled_color
	}

	return ColorFloat{0, 0, 0}
}

fn (mut s Scene) add_object(obj HittableObject) {
	s.hittable_objects << obj
}

fn (mut s Scene) add_light_source(source LightSource) {
	s.light_sources << source
}