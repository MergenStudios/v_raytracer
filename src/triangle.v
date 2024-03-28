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

	if ((-1e-07 < denominator) && (denominator < 1e-07)) {
		println("the denominator is 0, and therefore the ray does not intersect the plane (denom: ${denominator})")
		return none
	} 
	
	// we are intersecting the plane, now calculate t
	t := (tr.d - tr.normal.dot(r.origin)) / denominator

	// toleranzbereich
	if (t < 1e-07) {
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
		// println("w1: ${w1}, w2: ${w2}, Pz: ${point.z}, math: ${}")
		
		return Intersection {
			t: t
			intersection_point: point
			normal: tr.normal
			solid: tr
		}
	} else {
		return none
	}




	/*
	// https://www.youtube.com/watch?v=HYAgJN3x4GA
	// calculate if the point is acctually inside the triangle
	// P (point) - the point on the plane
	// A, B, C (tr.a, tr.b, tr.c) - the points defining the plane

	// calculate w1 and w2 from the first two equations (this is a mess, but it makes sense trust me)
	// w1 := (() + () - ()) / 
	w1 := 
		((tr.a.x*(tr.c.y - tr.a.y)) + ((point.y - tr.a.y)*(tr.c.x - tr.a.x)) - (point.x*(tr.c.y - tr.a.y))) / 
		((tr.b.y - tr.a.y)*(tr.c.y - tr.a.x) - (tr.b.x - tr.a.x)*(tr.c.x - tr.a.y))

	println("up: ${((tr.a.x*(tr.c.y - tr.a.y)) + ((point.y - tr.a.y)*(tr.c.x - tr.a.x)) - (point.x*(tr.c.y - tr.a.y)))}")
	println("bottom: ${((tr.b.y - tr.a.y)*(tr.c.y - tr.a.x) - (tr.b.x - tr.a.x)*(tr.c.x - tr.a.y))}")

	if (-1e-07 < w1) && (w1 < 1e-07) {
		// println("hit for TOLERANZBEREICH!!!")
	} else {
		println("weeeee, w1: ${w1}")
	}*/



	/*
	// calculate t
	t := (q.d - q.normal.dot(r.origin)) / (denominator)
	// println("we got t: ${t}")

	// toleranzbereich of t
	if  {
		// println("hit for toleranzbereich")
		return none
	}

	return none

	
	intersect := r.at(t)
	planar_hitpoint_vec := intersect - q.q

	alpha := q.w.dot(planar_hitpoint_vec.cross(q.v))
	beta := q.w.dot(q.u.cross(planar_hitpoint_vec))

	alpha_in_range := ((0.0 < alpha) && (alpha < 1.0))
	beta_in_range := ((0.0 < beta) && (beta < 1.0))

	if (alpha_in_range && beta_in_range) {
		// println("yes we got it")

		return Intersection {
			t: t
			intersection_point: r.at(t)
			normal: q.normal
			solid: q
		}


	} else {
		return none
	}*/





	// println("apha: ${alpha}, beta: ${beta}")


	/*
	// check toleranzberreich
	if ((denominator < 1e-07) && (denominator > -1e-07)) {
		println("denominator is basically 0")	
		return none
	}

	// calculate t
	t := q.d - (q.normal.dot(r.origin))
	// println("we got here, t: ${t}")
	// check toleranzberreich
	if (t < 1e-07) {
		return none
	}

	println("we got here now: ${t}")
	*/
	return none
}