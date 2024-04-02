module main

import math

struct Vec {
	x f64
	y f64
	z f64
}

// implement operators:
// + - * dot cross

fn (a Vec) + (b Vec) Vec {
	return Vec{a.x + b.x, a.y + b.y, a.z + b.z}
}

fn (a Vec) - (b Vec) Vec {
	return Vec{a.x - b.x, a.y - b.y, a.z - b.z}
}

fn (v Vec) length() f64 {
	return math.sqrt(v.x*v.x + v.y*v.y + v.z*v.z)
}

fn (v Vec) length_squared() f64 {
	return v.x*v.x + v.y*v.y + v.z*v.z
}

fn (v Vec) scale(t f64) Vec {
	return Vec{v.x * t, v.y * t, v.z * t}
}

fn (v Vec) dot(u Vec) f64 {
	// a1*b1 + a2*b2 + a3*b3
	return v.x*u.x + v.y*u.y + v.z*u.z
}

fn (v Vec) cross(u Vec) Vec {
	return Vec{
		x: (v.y*u.z) - (v.z*u.y)
		y: (v.z*u.x) - (v.x*u.z)
		z: (v.x*u.y) - (v.y*u.x)
	}
}

fn (v Vec) unit() Vec {
	return v.scale(1/v.length())
}

// generate a random unit vector (usefull for lambertian reflection)
// plot twist: this is not acctually a unit vector. I only noticed that now. I am an idiot sometimes...
fn rand_unit() Vec {
	return Vec{
		x: rand_f64(-1, 1)
		y: rand_f64(-1, 1)
		z: rand_f64(-1, 1)
	}
}

fn rand_on_hemisphere(n Vec) Vec {
	on_sphere := rand_unit()	

	if (on_sphere.dot(n)) > 0.0 {
		return on_sphere
	} else {
		return on_sphere.scale(-1)
	}
}