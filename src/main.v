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
	w, h := 900, 900
	bg_color := Color{0, 0, 0}

	// initialise scene
	mut s := init_scene(bg_color)

	// plan
	// make it have a list of objects
	// Object is an interface with a check_intersection function
	// Make it have light and stuff
	my_sphere := Sphere{
		center: Vec{0, 0, 5},
		radius: 1.0
	}

	s.add_object(my_sphere)


	s.render("./out.ppm", w, h)!
}

// scene
// scene has fn that creates image
