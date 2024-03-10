module main

struct Sphere {
	center Vec
	radius f64
}

fn (s Sphere) check_hit(r Ray) (bool, Intersection) {
	// check if the sphere has been hit
	// println("Hit function called with r ${r}")

	a := r.direction.dot(r.direction)
	b := r.direction.scale(2).dot(s.center.scale(-1))
	c := s.center.scale(-1).dot(s.center.scale(-1)) - s.radius*s.radius

	discriminant := b*b - 4*a*c
	
	if discriminant > 0 { // 2 intersections
		// calculate t
		t_pos := (-b + discriminant) / 2*a
		t_neg := (-b - discriminant) / 2*a

		mut lowest_t := 0.0

		if t_pos < t_neg {
			lowest_t = t_pos
		} else {
			lowest_t = t_neg
		}

		intersection_point := r.at(lowest_t)

		return true, Intersection {
			t: lowest_t
			intersection_point: intersection_point,
			surface_normal: s.surface_normal(intersection_point) // todo: calculate this in this function directly
			solid: s
		}

	} else if discriminant == 0 { // 1 intersections
		intersection_point := r.at((-b / 2*a))

		return true, Intersection {
			t: (-b / 2*a)
			intersection_point: intersection_point,
			surface_normal: s.surface_normal(intersection_point) // todo: calculate this in this function directly
			solid: s
		}

	} else { // no intersection
		return false, Intersection{}
	}
}

// todo: remove this 
fn (s Sphere) surface_normal(v Vec) Vec {
	normal_vec := (s.center - v).unit()
	return normal_vec
}