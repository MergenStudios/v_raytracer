module main

interface HittableObject {
	check_hit(r Ray) (bool, Intersection)
	surface_normal(v Vec) Vec // todo: remove this
}