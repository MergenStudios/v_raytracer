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

// Implement for ColorFloat:
// +, *, scale