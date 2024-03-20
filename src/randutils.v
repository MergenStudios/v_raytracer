import rand


fn rand_f64(min f64, max f64) f64 {
	return rand.f64_in_range(min, max) or {
		panic("problem generating random f64. what the hell?!")
	}
}