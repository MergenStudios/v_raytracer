module main


struct Triangle {
	a Vec	
	b Vec	
	c Vec	

	normal Vec // normal vector
	d f64	// constant d of the parametric ray equation

	optics Optics
}

fn make_triangle(a Vec, b Vec, c Vec, optics Optics) Triangle {
	ab := (b - a)
	ac := (c - a)
	
	normal := ac.cross(ab).unit()

	println("normal: ${normal}")

	// compute d
	d := normal.x * a.x + normal.y * a.y + normal.z * a.z

	return Triangle{
		a: a
		b: b
		c: c

		normal: normal
		d: d

		optics: optics
	}
}

fn (tr Triangle) check_hit(r Ray) ?Intersection {
	// check if the ray intersects the plane the quad lies in
	denominator := tr.normal.dot(r.direction)

	// check if the denominator is 0 (we cant divide by 0)
	if (-1e-07 < denominator) && (denominator < 1e-07) {
		return none
	}
	
	// we are intersecting the plane, now calculate t
	t := (tr.d - tr.normal.dot(r.origin)) / denominator

	// toleranzbereich
	if t < 1e-07 {
		// println("negative t, not intersecting the plane, t: ${t}")
		return none
	}

	point := r.at(t)

	// this code works correctly
	ab := tr.b - tr.a
	ac := tr.c - tr.a
	
	// calculate w1
	numerator_w1 := ((tr.a.x*ac.y) + (point.y - tr.a.y)*(ac.x) - (point.x*ac.y))
	denominator_w1 := (ab.y*ac.x) - (ab.x*ac.y)
	w1 := numerator_w1 / denominator_w1

	// calculate w2
	numerator_w2 := point.y - tr.a.y - (w1*ab.y)
	denominator_w2 := ac.y
	w2 := numerator_w2 / denominator_w2

	// substitute into the 3rd equation (with upper and lower bound this time)
	eq_3 := tr.a.z + w1*ab.z + w2*ac.z
	upper, lower := eq_3 + 1e-07, eq_3 - 1e-07
	eq_3_check := (lower <= eq_3) && (eq_3 < upper)

	
	if (w1 >= 0) && (w2 >= 0) && ((w1 + w2) <= 1) && eq_3_check {
		normal := tr.get_correct_normal(r.direction)

		return Intersection {
			t: t
			intersection_point: point
			normal: normal
			solid: tr
		}
	} else {
		return none
	}

	return none
}

// this functions ensures that the normal of the triangle is always pointing towards the camera
fn (tr Triangle) get_correct_normal(ray_direction Vec) Vec {
	if tr.normal.dot(ray_direction) < 0 {
		return tr.normal
	} else {
		return tr.normal.scale(-1)
	}
}