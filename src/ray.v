module main

struct Intersection {
	t f64
	intersection_point Vec
	surface_normal Vec
	solid HittableObject
}

struct Ray {
	origin Vec
	direction Vec
}

fn (r Ray) at(t f64) Vec {
	return r.origin + r.direction.scale(t)
}

fn (r Ray) nearest_intersection(hittable_objects []HittableObject) ?Intersection { // * change here
	mut nearest_intersection := Intersection{}
	mut intersected := false
	
	for obj in hittable_objects {
		// check, intersection := obj.check_hit(r)
		intersection := obj.check_hit(r) or {
			continue // this just skips ahead, beacuse we did not find an intersection with this object
		}

		// continue the normal code
		if !intersected {
			intersected = true
			nearest_intersection = intersection
			continue
		}

		if intersection.t < nearest_intersection.t {
			intersected = true
			nearest_intersection = intersection
		}
		
	}

	if intersected {
		return nearest_intersection // * change here
	} else {
		return none // * change here
	}
}

