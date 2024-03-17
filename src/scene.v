module main

import os

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
	bg_color ColorInt
	mut:
		cam Camera
		hittable_objects []HittableObject
		light_sources []LightSource
} 


fn init_scene(bg_color ColorInt) Scene {
	// sane defaults
	cam := Camera{
		pos: Vec{0, 0, 0},
		focal_length: 1.0,
		viewport_height: 2.0
	}
	
	return Scene {
		bg_color: bg_color
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
			pixel := s.trace_ray(r)

			f.write_string("${pixel.r} ${pixel.g} ${pixel.b}\n")!
		}
	}

	f.close()
}

fn (s Scene) has_line_of_sight(a Vec, b Vec) (bool) {
	r := Ray{a, (b - a).unit()}
	check, intersection := r.nearest_intersection(s.hittable_objects) // this could be more efficient if I dont calculate the intersection

	if check && intersection.t >= (b - a).length() {
		return true
	} else if !check {
		return true
	}
	
	// todo: clean this up later
	if (0 < intersection.t) && (intersection.t < 1e-14) {
		prinln("yes we got this case")
	} else {
		return false
	}
	return false

}


fn (s Scene) trace_ray(r Ray) ColorInt {
	check, intersection := r.nearest_intersection(s.hittable_objects)

	if check {
		
		// call calculate_lighting
		// println(intersection)
		

		if s.has_line_of_sight(intersection.intersection_point, s.light_sources[0].pos) {
			// line of sight - green
			return ColorInt{0, 255, 0}
		} else {
			// no line of sight - red
			return ColorInt{255, 0, 0}
		}
		
	} else { // nothing was hit, ray is background color
		return s.bg_color
	}
}

fn (mut s Scene) add_object(obj HittableObject) {
	s.hittable_objects << obj
}

fn (mut s Scene) add_light_source(source LightSource) {
	s.light_sources << source
}