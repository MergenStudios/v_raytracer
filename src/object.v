module main

struct Optics {
	gloss_factor f64 = 0.0 // DO NOT CHANGE THIS
	opacity f64 = 1.0 // DO NOT CHANGE THIS
	matte_color ColorFloat
}

interface HittableObject {
	optics Optics

	check_hit(r Ray) ?Intersection
}