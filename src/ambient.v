// This file handles ambient lighting

fn (s Scene) calculate_ambient(i Intersection, depth int) ColorFloat {
	// get the color of the bounced of ray
	// make .5 intensity
	// multiply that by the color of whatever I hit

	// object optics
	obj_optics := i.solid.optics

	// construct a new reflected ray
	direction := i.normal + rand_on_hemisphere(i.normal)
	child_ray := Ray{i.intersection_point, direction}

	child_ray_color := s.trace_ray(child_ray, depth-1).scale(.5)

	color_corrected := child_ray_color * obj_optics.matte_color

    return color_corrected
}

fn (s Scene) calculate_ambient_intensity(i Intersection, depth int) f64 {
	// check how much ambient light this intersection should be getting
	// obj_optics := i.solid.optics

	// construct a new "reflected" ray
	direction := i.normal + rand_on_hemisphere(i.normal)
	child_ray := Ray{i.intersection_point, direction}

	// get the intersectin of that
	intersection := child_ray.nearest_intersection(s.hittable_objects) or {
		return 1.0 * .5
	}

	// calculate the ambient intensity of that and return it plus the 
	return s.calculate_ambient_intensity(intersection, depth-1) * .5 // this factor should be how much light the thing absorbs
}