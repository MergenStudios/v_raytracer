A raytracer written in [V](https://github.com/vlang/v) for a school project.
It was largely written by following the excellent [Raytracing in one Weekend](https://raytracing.github.io/books/RayTracingInOneWeekend.html). It supports different ligh sources, and the sphere, plane and triangle primitives.

![image|500](https://raw.githubusercontent.com/MergenStudios/v_raytracer/refs/heads/main/media/out.png)

## Usage
Make sure you have V and make installed. 
Run `make comp` to compile. The resuting `rt.exe` accepts 3 cli arguments: width, height and the number of samples. The image in this readme was generated using `.\rt.exe 1920 1200 100`. The image is written to a [ppm file](https://netpbm.sourceforge.net/doc/ppm.html) (`out.ppm`), which is a very simple file format supported by many image viewers.
The scene itself is configured in the `main.v` file.
