extends Control


func update_camera(q: Quaternion, x: int, y: int, z: int):
	$SubViewportContainer/SubViewport/starfield.update_camera(q, x, y, z)
