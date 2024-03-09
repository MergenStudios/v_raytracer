module main

struct Ray {
	origin Vec
	direction Vec
}

fn (r Ray) at(t f64) Vec {
	return r.origin + r.direction.scale(t)
}