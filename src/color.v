import math

// 0 - 255
struct ColorInt {
	mut:
		r u8
		g u8
		b u8
}

// 0 - 1
struct ColorFloat {
	mut:
		r f64
		g f64
		b f64
}

// todo: implement bounds (0 - 1)
fn (c ColorFloat) scale(t f64) ColorFloat {
	return ColorFloat{
		r: c.r * t
		g: c.g * t
		b: c.b * t
	}
}

fn (a ColorFloat) + (b ColorFloat) ColorFloat {
	return ColorFloat {
		r: a.r + b.r
		g: a.g + b.g
		b: a.b + b.b
	}
}

// functions for converting between the two structs
fn (c ColorInt) to_float() ColorFloat {
	return ColorFloat{
		r: f64(c.r) / 255.0
		g: f64(c.g) / 255.0
		b: f64(c.b) / 255.0
	}
}

fn (c ColorFloat) to_int() ColorInt {
	return ColorInt{
		r: u8(c.r * 255.999)
		g: u8(c.g * 255.999)
		b: u8(c.b * 255.999)
	}
}