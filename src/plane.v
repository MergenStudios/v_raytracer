module main


struct Plane {
	a Vec // Stützvektor
	u Vec // spannvektor 1
	v Vec // spannvektor 2

	normal Vec // normal vector
	d f64	// constant d of the parametric plane equation

	optics Optics
}

fn make_plane(a Vec, u Vec, v Vec, optics Optics) Plane {
	normal := u.cross(v).unit()

	// compute d
	d := normal.x * a.x + normal.y * a.y + normal.z * a.z

	return Plane{
		a: a
		u: u
		v: v

		normal: normal
		d: d

		optics: optics
	}
}

fn (p Plane) check_hit(r Ray) ?Intersection {
	// check if the ray intersects the plane 
	denominator := p.normal.dot(r.direction)

	// check if the denominator is 0 (we cant divide by 0)
	if (-1e-07 < denominator) && (denominator < 1e-07) {
		return none
	}
	
	// we are intersecting the plane, now calculate t
	t := (p.d - p.normal.dot(r.origin)) / denominator

	// toleranzbereich
	if t < 1e-07 {
		// println("negative t, not intersecting the plane, t: ${t}")
		return none
	}

	point := r.at(t)
	normal := p.get_correct_normal(r.direction)

	return Intersection {
		t: t
		intersection_point: point,
		normal: normal,
		solid: p
	}
}

// this functions ensures that the normal of the Plane is always pointing towards the camera, for, reasons(?)
fn (p Plane) get_correct_normal(ray_direction Vec) Vec {
	if p.normal.dot(ray_direction) < 0 {
		return p.normal
	} else {
		return p.normal.scale(-1)
	}
}