module main

import os

struct Color {
	mut:
		r u8
		g u8
		b u8
}

// Camera + Viewport in one struct
// pos, vocal length, height (width is claculated from img dimensions)
// 

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

// must have 
// bg color, list of objects
// camera
struct Scene {
	bg_color Color
	mut:
		cam Camera
		hittable_objects []HittableObject
}



// make this do more of the work for me
fn init_scene(bg_color Color) Scene {
	// setup scene with default values
	cam := Camera{
		pos: Vec{0, 0, 0},
		focal_length: 1.0,
		viewport_height: 2.0
	} // sane defaults
	
	return Scene {
		bg_color: bg_color
		cam: cam
		hittable_objects: []HittableObject{}
	}
}

// sets up a cam using w and h
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
	
	
	println("aspect ratio ${aspect_ratio}")
	println("viewport width ${viewport_width}")

	println("pixel delta v ${pixel_delta_v}")
	println("pixel delta h ${pixel_delta_h}")

	println("on_z ${on_z}")
	println("top_left_corner ${top_left_corner}")
	println("top_left_pixel ${top_left_pixel}")
	

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

	println(s)
	

	// setup pixel_delta_horizontal and pixel_delta_vertical
	mut f := os.open_file(path, "w")!
	
	f.write_string("P3\n${w} ${h}\n${255}\n")!

	// write the ppm file
	// iterate over all pixels ()
	for y in 0 .. h {
		// print the progress
		print("\r")
		print("${y+1}/${h} lines")
		for x in 0 .. w {

			// construct ray from cam through pixel
			pixel_center := s.cam.top_left_pixel + Vec{s.cam.pixel_delta_h, 0, 0}.scale(x) + Vec{0, -s.cam.pixel_delta_v, 0}.scale(y)
			r := Ray{s.cam.pos, pixel_center} 

			// the following code runs for all rays in my scene


			// call s.trace_ray with the 
			pixel := s.trace_ray(r)

			// write ppm file 
			f.write_string("${pixel.r} ${pixel.g} ${pixel.b}\n")!
		}
	}
	
	// println(data)
	// f.write_string("./out.ppm")!

	f.close()
}

fn (s Scene) trace_ray(r Ray) Color {
	check, intersection := r.nearest_intersection(s.hittable_objects)

	// something was hit
	if check {
		// call calculate_lighting
		println(intersection)


		return Color{255, 0, 0}
	} else { // nothing was hit, ray is background color
		return s.bg_color
	}
}

fn (mut s Scene) add_object(obj HittableObject) {
	s.hittable_objects << obj
}