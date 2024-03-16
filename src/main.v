module main

import rand
import math

// render the main scene
fn main() {
	// test the vector stuff
	w, h := 8000, 5000
	bg_color := ColorInt{0, 0, 0}

	// initialise scene
	mut s := init_scene(bg_color)

	my_sphere := Sphere{
		center: Vec{0, 0, 3},
		radius: .5,
		optics: Optics{
			matte_color: ColorFloat{1.0, 1.0, 1.0}
		}
	}
	s.add_object(my_sphere)

	my_second_sphere := Sphere{
		center: Vec{2, 0, 3},
		radius: .5,
		optics: Optics{
			matte_color: ColorFloat{1.0, 1.0, 1.0}
		}
	}

	s.add_object(my_second_sphere)



	// bigger sphere (radius = 5)
	// gen theta and phi
	/*
	for _ in 0..10000 {
		theta := rand.int_in_range(1, 359)!
		phi := rand.int_in_range(1, 179)!
		

		// convert to spherical coordinates
		x_big := 5 * math.sin(phi) * math.cos(theta)
		y_big := 5 * math.sin(phi) * math.sin(theta)
		z_big := 5 * math.cos(phi)

		x_small := math.sin(phi) * math.cos(theta)
		y_small := math.sin(phi) * math.sin(theta)
		z_small := math.cos(phi)

		// richtungsvekt :=  - Vec{x_small, y_small, z_small}
		// constructed_ray := Ray{Vec{x_small, y_small, z_small}, richtungsvekt}

		// my_sphere.check_hit(constructed_ray)
		// check := s.has_line_of_sight(Vec{x_small, y_small, z_small}, Vec{x_big, y_big, z_big})
		
		println("${my_sphere.contains(Vec{x_small, y_small, z_small})}")
		// panic("nerd")
	}
	*/



	// println("${x}, ${y}, ${z}")


	// 
	//my_sphere.check_hit()

	
	my_light_source := LightSource{
		pos: Vec{-5, 2, 3}
	}
	s.add_light_source(my_light_source)
	

	

	s.render("./out.ppm", w, h)!
}

// TODO
// test intersection function DONE
// test line of sight function DONE

// make light sources a thing
// make optics a thing