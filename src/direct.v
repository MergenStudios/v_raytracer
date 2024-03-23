// calculate the direct lighting of an intersection
// todo: make this use multiple light sources
fn (s Scene) calculate_direct(i Intersection) ColorFloat {
	source := s.light_sources[0]

	if s.has_line_of_sight(i.intersection_point, source.pos) {
		obj_optics := i.solid.optics

		direction_to_source := (source.pos - i.intersection_point)
		incidence := i.normal.dot(direction_to_source.unit())

		// fall off calculation for the light intensity
		intensity := incidence * .5 // this value is the brightness of the light source

		// println(intensity)

		scaled_color := obj_optics.matte_color.scale(intensity)

		return scaled_color
	}

	return ColorFloat{0, 0, 0}
}
