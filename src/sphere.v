module main

import math
import arrays

struct Sphere {
	center Vec
	radius f64
	optics Optics
}


// get_intersection
/*
fn get_intersection(bool, Intersection) {
	// tolerance if -1e-14 < num < 1e-14
	// 
}
*/



 
// todo: fix negative t
fn (s Sphere) check_hit(r Ray) (bool, Intersection) {
	
	// check if the sphere has been hit
	// println("Hit function called with r ${r}")

	// A: r.origin
	// B: r.direction
	// C: sphere center

	// a = B dot B
	// b = 2 * (B dot A-C)
	// c = A-C dot A-C - r*r

	a := r.direction.dot(r.direction)
	b := r.direction.dot(r.origin - s.center) * 2
	c := (r.origin - s.center).dot((r.origin - s.center)) - s.radius*s.radius

	discriminant := b*b - 4*a*c

	// println("ray: ${r}, a: ${a}, b: ${b}, c: ${c}, discriminant: ${discriminant}")


	if discriminant < 0 {
		return false, Intersection{}
	}


	// the 0 code should work+

	if discriminant == 0 {
		t := (-b / (2*a))

		if t < 0 {
			return false, Intersection{}
		} else {
			intersection_point := r.at(t)

			return true, Intersection {
				t: t
				intersection_point: intersection_point,
				surface_normal: s.surface_normal(intersection_point) // todo: calculate this in this function directly
				solid: s
			}
		}
	}

	// get the closest positive t
	// okay and now 
	
	if discriminant > 0 { // 2 intersections TODO: fix behaviour when both intersects are negative

		
		// calculate t
		mut t_vals := [(-b + math.sqrt(discriminant)) / (2*a), (-b - math.sqrt(discriminant)) / (2*a)]

		// println("before: ${t_vals}")

		// edgecase when all t are below 0
		if t_vals.all(it < 0) {
			return false, Intersection{}
		}

		

		// 1. filter out all negative numbers
		t_vals = t_vals.filter(it >= 0)

		// println("after filtering out negative numbers: ${t_vals}")


		// 2. filter out all 0s
		t_vals = t_vals.filter(it != 0)

		// println("after filtering out 0s: ${t_vals}")


		// 3. filter out all Toleranzgrenze
		t_vals = t_vals.filter(!((it < 1e-07) && (it > -1e-07)))

		// println("after filtering out toleranzgrenze: ${t_vals}")	
		
		// println("after: ${t_vals}")

		if t_vals == [] {
			return false, Intersection{}
		}



		lowest_t := arrays.min(t_vals) or {
			panic("huge panic")
		}


		// check if the lowest t is basically 0 (within floating point error range)


		intersection_point := r.at(lowest_t)

		return true, Intersection {
			t: lowest_t
			intersection_point: intersection_point,
			surface_normal: s.surface_normal(intersection_point) // todo: calculate this in this function directly
			solid: s
		}
		
	}

	// chechk if r.origin is in the sphere
	// yes - we got intersection
	// no - we can run the other one

	// something went terribly wrong
	println("What the actuall fuck. discriminant is neither over 0, 0, or below 0. idk either")
	return false, Intersection{}
}

// todo: remove this 
fn (s Sphere) surface_normal(v Vec) Vec {
	normal_vec := (v - s.center).unit()
	return normal_vec
}

fn (s Sphere) contains(a Vec) bool {
	result := (a.x - s.center.x)*(a.x - s.center.x) + (a.y - s.center.y)*(a.y - s.center.y) + (a.z - s.center.z)*(a.z - s.center.z)


	if result <= s.radius*s.radius {
		return true
	}
	return false
}