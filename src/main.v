module main

import os
import math

fn main() {
	// parse w and h from command line
	
	w_parsed := os.args[1].int()
	h_parsed := os.args[2].int()
	samples_parsed := os.args[3].int()

	w, h := w_parsed, h_parsed
	// bg_color := ColorInt{156, 196, 255}.to_float() // stole that blue from "raytracing in one weekend"
	bg_color := ColorFloat{0, 0, 0}

	mut s := init_scene(bg_color, samples_parsed)


	//use only for lambhertian rendering as a ground
	s2 := Sphere{
		center: Vec{0, -200.5, 1.5},
		radius: 200,
		optics: Optics{
			matte_color: ColorFloat{.5, .5, .5}
		}
	}
	s.add_object(s2)

	t2 := make_triangle(
		Vec{-.5, -.5, 1},	// a
		Vec{.5, -.5, 1},	// b
		Vec{0, .16, 1},		// c
		Optics{
			matte_color: ColorInt{102, 0, 153}.to_float()
		}
	)
	s.add_object(t2)
	
	// light source
	my_light_source := LightSource{
		pos: Vec{0, 0, 0}
	}
	s.add_light_source(my_light_source)
	

	s.render("./out.ppm", w, h)!
	
}