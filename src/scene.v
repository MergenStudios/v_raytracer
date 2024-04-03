module main

import os
import math

struct Camera {
	mut:
		pos Vec								// usually 0|0|0
		facing Vec

		focal_length f64 = 1.0				// usually 1.0
		viewport_height f64	= 2.0			// usually 2.0 (idk why but its from rt in one weekend)
		viewport_width f64					// calculated from height based on img w and h

		up Vec = Vec{0, 1, 0} // this points up. changing this tilts the camera

		pixel_delta_v Vec					// calculated from viewport height //! change this to a vector
		pixel_delta_h Vec					// calculated from viewport width //! change this to a vector
		top_left_pixel Vec					// calculated from all the above
}

fn (mut c Camera) setup(w int, h int) {	
	// calculate Viewport width
	// ratio between w and h
	aspect_ratio := f64(w) / f64(h)
	c.viewport_width = c.viewport_height * aspect_ratio

	println("viewport_width: ${c.viewport_width}")
	println("viewport_height: ${c.viewport_height}")


	// ********* assuming pos 0, 0, 0
	// viewport_width is viewport_height multiplied by aspect_ratio

	pixel_delta_v_value := c.viewport_height / f64(h) // pixel_delta_v (vertical) is viewport_height scaled by 1/h
	pixel_delta_h_value := c.viewport_width / f64(w) // pixel_delta_h (horizontal) is viewport_width scaled by 1/w

	// pixel_delta_v := Vec{0, -pixel_delta_v_value, 0}
	// pixel_delta_h := Vec{pixel_delta_h_value, 0, 0}

	// on_z := c.pos + Vec{0, 0, c.focal_length}
	// top_left_corner := on_z - Vec{c.viewport_width, 0, 0}.scale(.5) + Vec{0, c.viewport_height, 0}.scale(.5)
	// top_left_pixel := top_left_corner + Vec{pixel_delta_h_value, 0, 0}.scale(.5) + Vec{0, -pixel_delta_v_value, 0}.scale(.5)

	// ********* custom pos

	// relative coordinate frame for the camera
	relative_z := c.facing.unit()
	relative_x := c.up.cross(relative_z).unit()
	relative_y := relative_z.cross(relative_x).unit()

	println("relative_z: ${relative_z}, len: ${relative_z.length()}")
	println("relative_x: ${relative_x}, len: ${relative_x.length()}")
	println("relative_y: ${relative_y}, len: ${relative_y.length()}")
	println("\n\n")

	// calculate the pixel_delta_v and pixel_delta_h
	pixel_delta_v_ := relative_y.scale(-pixel_delta_v_value) // negative because we want the vector to go down
	pixel_delta_h_ := relative_x.scale(pixel_delta_h_value)

	println("pixel_delta_v_: ${pixel_delta_v_}, len: ${pixel_delta_v_.length()}")
	println("pixel_delta_h_: ${pixel_delta_h_}, len: ${pixel_delta_h_.length()}")
	println("\n\n")


	// calculate the viewport center
	viewport_center_ := c.pos + relative_z.scale(c.focal_length)
	top_left_corner_ := viewport_center_ - relative_x.scale(c.viewport_width / 2) + relative_y.scale(c.viewport_height / 2)
	top_left_pixel_ := top_left_corner_ + pixel_delta_v_.scale(.5) + pixel_delta_h_.scale(.5)

	println("viewport_center_: ${viewport_center_}")
	println("top_left_corner_: ${top_left_corner_}")
	println("top_left_pixel_: ${top_left_pixel_}")
	println("\n\n")


	use_custom_pos := true

	if use_custom_pos {
		c = Camera{
			pos: c.pos,
			focal_length: c.focal_length,
			viewport_height: c.viewport_height,
			viewport_width: c.viewport_width,
			pixel_delta_v: pixel_delta_v_,
			pixel_delta_h: pixel_delta_h_,
			top_left_pixel: top_left_pixel_
		}
	} else {
		// c = Camera{
		// 	pos: c.pos,
		// 	focal_length: c.focal_length,
		// 	viewport_height: c.viewport_height,
		// 	viewport_width: c.viewport_width,
		// 	pixel_delta_v: pixel_delta_v,
		// 	pixel_delta_h: pixel_delta_h,
		// 	top_left_pixel: top_left_pixel
		// }
	}


	/*

	pos := Vec{0, 0, 0}
	
	// calculate Viewport width
	// ratio between w and h
	aspect_ratio := f64(w) / f64(h)
	focal_length := 2.7 // todo: make this a parameter later
	// viewport_width is viewport_height multiplied by aspect_ratio
	viewport_height := 2.0
	viewport_width := viewport_height * aspect_ratio

	pixel_delta_v_value := viewport_height / f64(h) // pixel_delta_v (vertical) is viewport_height scaled by 1/h
	pixel_delta_h_value := viewport_width / f64(w) // pixel_delta_h (horizontal) is viewport_width scaled by 1/w

	pixel_delta_v := Vec{0, -pixel_delta_v_value, 0}
	pixel_delta_h := Vec{pixel_delta_h_value, 0, 0}

	println("pixel_delta_v: ${pixel_delta_v}, len: ${pixel_delta_v.length()}")
	println("pixel_delta_h: ${pixel_delta_h}, len: ${pixel_delta_h.length()}")


	on_z := pos + Vec{0, 0, focal_length}
	top_left_corner := on_z - Vec{viewport_width, 0, 0}.scale(.5) + Vec{0, viewport_height, 0}.scale(.5)
	top_left_pixel := top_left_corner + pixel_delta_h.scale(.5) + pixel_delta_v.scale(.5)

	println("on_z: ${on_z}")
	println("top_left_corner: ${top_left_corner}")
	println("top_left_pixel: ${top_left_pixel}")


	// calculate the relative basis vectors for the camera
	// todo: make sure that the coordinate system doesnt get flipped somehow
	relative_z := direction.unit()
	relative_x := up.cross(relative_z).unit()
	relative_y := relative_z.cross(relative_x).unit()

	println("relative_z: ${relative_z}, len: ${relative_z.length()}")
	println("relative_x: ${relative_x}, len: ${relative_x.length()}")
	println("relative_y: ${relative_y}, len: ${relative_y.length()}")

	// calculate the pixel_delta_v and pixel_delta_h
	pixel_delta_v_ := relative_y.scale(-pixel_delta_v_value) // negative because we want the vector to go down
	pixel_delta_h_ := relative_x.scale(pixel_delta_h_value)
	
	println("pixel_delta_v_: ${pixel_delta_v_}, len: ${pixel_delta_v_.length()}")
	println("pixel_delta_h_: ${pixel_delta_h_}, len: ${pixel_delta_h_.length()}")

	// calculate the viewport center
	viewport_center_ := pos_ + relative_z.scale(focal_length)
	top_left_corner_ := viewport_center_ - relative_x.scale(viewport_height / 2) + relative_y.scale(viewport_width / 2)
	top_left_pixel_ := top_left_corner_ + pixel_delta_v.scale(.5) + pixel_delta_h_.scale(.5)

	println("viewport_center_: ${viewport_center_}")
	println("top_left_corner_: ${top_left_corner_}")
	println("top_left_pixel_: ${top_left_pixel_}")

	return Camera{
		pos: pos,
		focal_length: focal_length,
		viewport_height: viewport_height,
		viewport_width: viewport_width,
		pixel_delta_v: pixel_delta_v_,
		pixel_delta_h: pixel_delta_h_,
		top_left_pixel: top_left_pixel_
	}
	*/
}


struct Scene {
	bg_color ColorFloat
	depth int
	samples int
	mut:
		cam Camera
		hittable_objects []HittableObject
		light_sources []LightSource
}

fn (mut s Scene) add_object(obj HittableObject) {
	s.hittable_objects << obj
}

fn (mut s Scene) add_light_source(source LightSource) {
	s.light_sources << source
}


fn (s Scene) get_ray(x int, y int) Ray {
	pixel_center := s.cam.top_left_pixel + s.cam.pixel_delta_h.scale(x) + s.cam.pixel_delta_v.scale(y)

	py := -.5 + rand_f64(0, 1)
	px := -.5 + rand_f64(0, 1)

	pixel_sample := pixel_center + s.cam.pixel_delta_h.scale(px) + s.cam.pixel_delta_v.scale(py)

	r := Ray{s.cam.pos, pixel_sample.unit()} // todo: does this HAVE to be a unit vector?

	return r
}


fn (s Scene) has_line_of_sight(a Vec, b Vec) (bool) {
	r := Ray{a, (b - a).unit()}
	// check, intersection := r.nearest_intersection(s.hittable_objects) // * change here
	intersection := r.nearest_intersection(s.hittable_objects) or {
		return true // we got no intersection, we have a line of sight
	}

	// rare edgecase with intersection but not between a and b
	if intersection.t >= (b - a).length() { // * change here
		return true
	}
	
	// we got a valid intersection, so we do not have a line of sight
	return false
}


// this traces a ray and returns its color. It takes ambient and direct lighting into account
fn (s Scene) trace_ray(r Ray, depth int) ColorFloat {
	// if the ray doesnt intersect anything, its color is the background color
	intersection := r.nearest_intersection(s.hittable_objects) or {
		// return s.bg_color
		a := .5 * (r.direction.unit().y + 1)
		return ColorFloat{0.5, 0.7, 1.0}.scale(1 - a) + ColorFloat{1.0, 1.0, 1.0}.scale(a)
		// return ColorFloat{0.0, 0.7, 0.0}
	}
	 
	// we have exceeded the recursion depth, no more light is gathered
	if depth <= 0 {
		return ColorFloat{0.0, 0.0, 0.0}
	}

	// the ray hit something, we now have to determine its color

	// calculate the contributeion of direct lighting
	// direct := s.calculate_direct(intersection)
 	direct := ColorFloat{0.0, 0.0, 0.0}

	// if direct_calc != ColorFloat{0, 0, 0} {
	// 	println("direct: ${s.calculate_direct(intersection)}, intersection: ${intersection}")
	// }
	

	// calculate the contribution of ambient lighting
	// ambient := s.calculate_ambient(intersection, depth)

	// calculate ambient intensity (how much ambient light is reaching this point)
	ambient_intensity := s.calculate_ambient_intensity(intersection, depth)
	ambient := s.bg_color.scale(ambient_intensity) * intersection.solid.optics.matte_color



	// add them up, bring between 0 and 1
	
	return ColorFloat{
		r: math.min(1.0, (direct.r + ambient.r))
		g: math.min(1.0, (direct.g + ambient.g))
		b: math.min(1.0, (direct.b + ambient.b))
	}
}


fn (mut s Scene) render(path string, w int, h int) !{
	s.cam.setup(w, h)
	
	mut f := os.open_file(path, "w")!
	
	f.write_string("P3\n${w} ${h}\n${255}\n")!

	// write the ppm file
	for y in 0 .. h {
		// progress bar
		print("\r")
		print("${y+1}/${h} lines")

		for x in 0 .. w {
			mut color_sampled := ColorFloat{0, 0, 0}

			for _ in 0..s.samples {
				r := s.get_ray(x, y)

				pixel := s.trace_ray(r, s.depth)

				color_sampled += pixel
			}

			// take the average
			scale := 1.0 / f64(s.samples)
			color_sampled = color_sampled.scale(scale)
			color_sampled_int := color_sampled.to_int()
			// println("${scale}, ${color_sampled}")
			
			f.write_string("${color_sampled_int.r} ${color_sampled_int.g} ${color_sampled_int.b}\n")!
		}
	}

	f.close()
}