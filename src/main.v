module main

fn main() {
	w, h := 400, 250
	bg_color := ColorInt{0, 0, 0}

	mut s := init_scene(bg_color)

	// objects
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

	
	// light source
	my_light_source := LightSource{
		pos: Vec{-5, 2, 3}
	}
	s.add_light_source(my_light_source)
	

	s.render("./out.ppm", w, h)!
}