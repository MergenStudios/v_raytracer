module main

import os

struct Color {
	mut:
		r u8
		g u8
		b u8
}

struct Camera {
	mut:
		pos Vec
		focal_lenght f64 = 1.0
		viewport_height f64 = 2.0 // todo: figure out what effect this has later
}

//todo: make it more clear what v1 and v2 are
struct Viewport {
	horizontal_vec Vec
	vertical_vec Vec
}

struct Scene {
	bg_color Color
	cam Camera
	port Viewport
}

// make this do more of the work for me
fn init_scene(bg_color Color) Scene {
	cam := Camera{pos: Vec{0, 0, 0}}
	port := Viewport{Vec{1, 0, 0}, Vec{0, -cam.viewport_height, 0}}

	
	
	
	
	
	return Scene {
		bg_color: bg_color
		cam: cam
		port: port
	}
}

fn (s Scene) render(path string, w int, h int) !{
	// setup the data
	mut data := [][]Color{len: h, init: []Color{len: w}}

	// setup pixel_delta_horizontal and pixel_delta_vertical
	pixel_delta_horizontal := s.port.horizontal_vec.scale(1.0/f64(w))
	pixel_delta_vertical := s.port.vertical_vec.scale(1.0/f64(h))

	// viewport upper left
	port_first_pixel := s.cam.pos - Vec{0, 0, s.cam.focal_lenght} - s.port.horizontal_vec.scale(.5) - s.port.vertical_vec.scale(.5) + pixel_delta_horizontal.scale(.5) + pixel_delta_vertical.scale(.5)
	
	mut f := os.open_file(path, "w")!
	
	f.write_string("P3\n${w} ${h}\n${255}\n")!

	// write the ppm file
	// iterate over all pixels ()
	for x in 0 .. w {
		// print the progress
		print("\r")
		print("${x+1}/${w} lines")
		for y in 0 .. h {
			r := Ray{s.cam.pos, port_first_pixel + pixel_delta_horizontal.scale(x) + pixel_delta_vertical.scale(y)}

		
			// write ppm file 
			pixel := s.bg_color
			f.write_string("${pixel.r} ${pixel.g} ${pixel.b}\n")!
		}
	}
	

	// f.write_string("./out.ppm")!

	f.close()
}
