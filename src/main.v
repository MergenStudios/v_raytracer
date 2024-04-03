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
	bg_color := ColorFloat{1.0, 1.0, 1.0} // this is ambient light

	mut s := init_scene(bg_color, samples_parsed)

	// translate := Vec{-1, 0, .5}
	// t2 := make_triangle(
	// 	Vec{-.5, -.5, 1} + translate,	// a
	// 	Vec{.5, -.5, 1} + translate,	// b
	// 	Vec{0, .16, 1} + translate,		// c
	// 	Optics{
	// 		matte_color: ColorInt{102, 0, 153}.to_float()
	// 	}
	// )
	// s.add_object(t2)

	ground := make_plane(
		Vec{0, -.5, 0}, // a (Stützvektor)
		Vec{1, 0, 0}, // u (Spannvektor)
		Vec{0, 0, 1}, // v (Spannvektor)
		Optics{
			matte_color: ColorFloat{.5, .5, .5}
		}
	)
	s.add_object(ground)

	sphere := Sphere{
		center: Vec{-2, 0, 17},
		radius: .5,
		optics: Optics{
			matte_color: ColorFloat{0.0, 1.0, 1.0}
		}
	}
	s.add_object(sphere)

	// triangle := make_triangle(
	// 	Vec{-2, -.5, 21},
	// 	Vec{1, -.5, 17},
	// 	Vec{-.5, .16,19},
	// 	Optics{
	// 		matte_color: ColorFloat{1.0, 1.0, 0.0}
	// 	}
	// )
	// s.add_object(triangle)
	
	// light source
	my_light_source := LightSource{
		pos: Vec{-1, 0, 17}
	}
	s.add_light_source(my_light_source)
	

	s.render("./out.ppm", w, h)!
	
}