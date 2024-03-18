module main

import os

fn main() {
	// parse w and h from command line
	w_parsed := os.args[1].int()
	h_parsed := os.args[2].int()

	w, h := w_parsed, h_parsed
	bg_color := ColorInt{0, 0, 0}

	mut s := init_scene(bg_color)

	// objects
	my_sphere := Sphere{
		center: Vec{0, 0, 1},
		radius: .5,
		optics: Optics{
			matte_color: ColorFloat{0.56, 0.0, 1.0}
		}
	}
	s.add_object(my_sphere)

	my_second_sphere := Sphere{
		center: Vec{0, -200.5, -1},
		radius: 200,
		optics: Optics{
			matte_color: ColorFloat{1.0, 1.0, 1.0}
		}
	}
	s.add_object(my_second_sphere)

	
	// light source
	my_light_source := LightSource{
		pos: Vec{2, 0, 0}
	}
	s.add_light_source(my_light_source)
	

	s.render("./out.ppm", w, h)!
}