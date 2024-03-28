module main

import math
import arrays

struct Sphere {
	center Vec
	radius f64
	optics Optics
}

fn (s Sphere) check_hit(r Ray) ?Intersection {
	// https://viclw17.github.io/2018/07/16/raytracing-ray-sphere-intersection
	a := r.direction.dot(r.direction)
	b := r.direction.dot(r.origin - s.center) * 2
	c := (r.origin - s.center).dot((r.origin - s.center)) - s.radius*s.radius

	discriminant := b*b - 4*a*c

	// below 0 - no intersections
	if discriminant < 0 {
		return none 
	}

	// exactly 0 - one intersection
	if discriminant == 0 {
		t := (-b / (2*a))

		if t < 0 {
			return none 
		} else {
			intersection_point := r.at(t)

			return Intersection{ 
				t: t
				intersection_point: intersection_point,
				normal: s.normal(intersection_point) // todo: calculate this in this function directly
				solid: s
			}
		}
	}

	// over 0 - two intersections
	if discriminant > 0 { 
		mut t_vals := [(-b + math.sqrt(discriminant)) / (2*a), (-b - math.sqrt(discriminant)) / (2*a)]

		// edgecase when all t are below 0
		if t_vals.all(it < 0) {
			return none 
		}

		
		t_vals = t_vals.filter(it >= 0) // 1. filter out all negative numbers
		t_vals = t_vals.filter(it != 0) // 2. filter out all 0s
		t_vals = t_vals.filter(!((it < 1e-07) && (it > -1e-07))) // 3. filter out all Toleranzgrenze


		if t_vals == [] {
			return none 
		}


		lowest_t := arrays.min(t_vals) or {
			panic("huge panic")
		}

		intersection_point := r.at(lowest_t)

		return Intersection { 
			t: lowest_t
			intersection_point: intersection_point,
			normal: s.normal(intersection_point) // todo: calculate this in this function directly
			solid: s
		}
		
	}
	// something went terribly wrong
	println("What the actuall fuck. discriminant is neither over 0, 0, or below 0. idk either")
	return none 
}

// todo: remove this 
fn (s Sphere) normal(v Vec) Vec {
	normal_vec := (v - s.center).unit()
	return normal_vec
}