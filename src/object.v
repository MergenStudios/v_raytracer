module main

interface HittableObject {
	check_hit(r Ray) bool
}