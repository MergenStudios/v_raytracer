module main

struct Sphere {
	center Vec
	radius f64
}

fn (s Sphere) check_hit(r Ray) bool {
	// check if the sphere has been hit
	// println("Hit function called with r ${r}")

	a := r.direction.dot(r.direction)
	b := r.direction.scale(2).dot(s.center.scale(-1))
	c := s.center.scale(-1).dot(s.center.scale(-1)) - s.radius*s.radius

	discriminant := b*b - 4*a*c
	
	if discriminant > 0 {
		return true
	} else {
		return false
	}
}