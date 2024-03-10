module main

/*
fn scene_test() !{
	w, h := 100, 100
	bg_color := Color{0, 0, 0}

	// initialise scene
	mut s := init_scene(w, h, bg_color)

	for x in 20 .. 30 {
		for y in 30 .. 40 {
			s.data[x][y] = Color{0, 255, 0}
		}
	}

	// plan
	// make it have a list of objects
	// Object is an interface with a check_intersection function
	// Make it have light and stuff

	println(s.data[30][50])

	s.render("./out.ppm", 100, 100)!

}
*/


// render the main scene
fn main() {
	// test the vector stuff
	w, h := 1600, 900
	bg_color := Color{0, 0, 0}

	// initialise scene
	mut s := init_scene(bg_color)

	my_sphere := Sphere{
		center: Vec{0, 0, 3},
		radius: 1.0
	}

	s.add_object(my_sphere)

	my_second_sphere := Sphere {
		center: Vec{0, 1, 3},
		radius: .2
	}

	// s.add_object(my_second_sphere)


	s.render("./out.ppm", w, h)!
}

// TODO
// Make the ray have a nearrest_intersect function

// add light sources
// add CalculateLighting