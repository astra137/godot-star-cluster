class_name Blackbody

# WARNING: completely unknown function happening here, use at your own risk
static func temp_to_rgb(t: float) -> Color:
	# t to xyY
	var x := 0.0
	var y := 0.0
	if t >= 1667.0 and t <= 4000.0:
		x = ((-0.2661239e9) / t**3) + ((-0.2343580e6) / t**2) + ((0.8776956e3) / t) + 0.179910
	else:
		x = ((-3.0258469e9) / t**3) + ((2.1070379e6) / t**2) + ((0.2226347e3) / t) + 0.240390
	if t >= 1667.0 && t <= 2222.0:
		y = -1.1063814 * x**3 - 1.34811020 * x**2 + 2.18555832 * x - 0.20219683
	elif t > 2222.0 && t <= 4000.0:
		y = -0.9549476 * x**3 - 1.37418593 * x**2 + 2.09137015 * x - 0.16748867
	else:
		y = 3.0817580 * x**3 - 5.87338670 * x**2 + 3.75112997 * x - 0.37001483
	# xyY to XYZ, Y = 1
	var x2 := 0.0
	var y2 := 1.0
	var z2 := 0.0
	if not is_zero_approx(y):
		x2 = x / y
		z2 = (1.0 - x - y) / y
	# XYZ to rgb
	var r := 3.2406 * x2 - 1.5372 * y2 - 0.4986 * z2
	var g := -0.9689 * x2 + 1.8758 * y2 + 0.0415 * z2
	var b := 0.0557 * x2 - 0.2040 * y2 + 1.0570 * z2
	return Color(r, g, b)
