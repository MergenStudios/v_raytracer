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