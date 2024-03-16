module main

struct Optics {
	gloss_factor f64 = 0.0 // DO NOT CHANGE THIS
	opacity f64 = 1.0 // DO NOT CHANGE THIS
	matte_color ColorFloat
}

interface HittableObject {
	optics Optics

// 	get_intersection(r Ray) (bool, Intersection)

	check_hit(r Ray) (bool, Intersection)
	surface_normal(v Vec) Vec // todo: remove this
}


// get_intersection
	// this returns the intersections between a ray and an object
	//
// check_intersection
	// this checks if there are intersections between a ray and an object