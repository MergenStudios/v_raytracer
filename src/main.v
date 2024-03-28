module main

import os

fn main() {
	// parse w and h from command line
	w_parsed := os.args[1].int()
	h_parsed := os.args[2].int()

	w, h := w_parsed, h_parsed
	// bg_color := ColorInt{156, 196, 255}.to_float() // stole that blue from "raytracing in one weekend"
	bg_color := ColorFloat{0, 0, 0}

	mut s := init_scene(bg_color)

	// objects
	s1 := Sphere{
		center: Vec{0, 0, 1.5},
		radius: .5,
		optics: Optics{
			matte_color: ColorFloat{0.0, 1.0, 1.0}
		}
	}
	s.add_object(s1)

	//use only for lambhertian rendering as a ground
	s2 := Sphere{
		center: Vec{0, -200.5, 1.5},
		radius: 200,
		optics: Optics{
			matte_color: ColorFloat{.5, .5, .5}
		}
	}
	s.add_object(s2)

	/*
	t1 := make_triangle(
		Vec{-1, 0, 2}, 	// a
		Vec{-1, 0, 3},	// b
		Vec{-1, 2, 1.5},	// c
		Optics{
			matte_color: ColorFloat{1, 1, 1}
		}
	)
	// s.add_object(t1)
	*/

	t2 := make_triangle(
		Vec{-1, -.5, 1.5},	// a
		Vec{1, -.5, 1.5},		// b
		Vec{0, .2, .5},		// c
		Optics{
			matte_color: ColorFloat{1, 1, 1}
			// matte_color: ColorInt{102, 0, 153}.to_float()
		}
	)
	// s.add_object(t2)

	
	// light source
	my_light_source := LightSource{
		pos: Vec{2, 0, 0}
	}
	s.add_light_source(my_light_source)
	

	s.render("./out.ppm", w, h)!
}