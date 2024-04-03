Raytracer written in V for my Facharbeit

# Todo
- [ ] Fix ambient lighting bug?
- [ ] Fix FOV issue and camera placement

# Shapes and Bodies to Add
- Donut
- Planes
    - SPHERICAL!!!! plane
    - Quads (basically viereck)
    - I guess I can go on with other 2d Shapes


Strategy:
    Do as much work as possible now.
    Present it to Herr Bachmann.
    Figure out what makes the most sense to put in the Facharbeit.

# Implementing a movable camera
*cam struct*
    - Pos (where the camera is in space)
    - look at (the point the camera is looking at, NOT the vector representing the direction the camera is looking at)

*setup function for cam*
    - Generate basis vectors for the camera
    - Use those to calculate top left corner etc.

*get_pixel functions*
    - Use the basis vectors

## vorgehen
- understand fov stuff
- understand focal length