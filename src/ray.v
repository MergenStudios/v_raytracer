module main

// intersection struct
struct Intersection {
	t f64
	intersection_point Vec
	surface_normal Vec
	solid HittableObject

	// point of intersection
	// solid (the solid thats being intersected)
	// the surface normal of the intersection
	// 

}


struct Ray {
	origin Vec
	direction Vec
}

fn (r Ray) at(t f64) Vec {
	return r.origin + r.direction.scale(t)
}

fn (r Ray) nearest_intersection(hittable_objects []HittableObject) (bool, Intersection) {
	mut nearest_intersection := Intersection{
		t: 1000000.0
	}
	mut intersected := false
	
	for obj in hittable_objects {
		check, intersection := obj.check_hit(r)

		if check {
			if intersection.t < nearest_intersection.t {
				nearest_intersection = intersection
				intersected = true
			}
		}
	}

	if intersected {
		return true, nearest_intersection
	} else {
		return false, Intersection{}
	}
}

// nearest_intersect
// fn (r Ray) nearest_intersect(hittable_objects []HittableObjects) Vec {
//		go thought all hittable objects
//		check if the ray intersects with the object
//		update the closest intersection as needed
//		return the intersection point
// }