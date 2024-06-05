@tool
extends Node3D


@export var max_distance := 4e3


@export_range(0.1, 150.0, 0.1) var mass := 1.0:
	set(value):
		mass = value
		update_stellar_properties()


func get_luminosity() -> float:
	return mass ** 3.5


func get_temperature() -> float:
	return 5740.0 * mass ** 0.54


func get_radius() -> float:
	return mass ** 0.8


func update_faux_position(value: Vector3) -> void:
	value /= 6.957e8
	transform = Transform3D(Basis.from_scale(Vector3.ONE * max_distance / value.length()), value.normalized() * max_distance)


func update_stellar_properties() -> void:
	var data := Color(mass, get_luminosity(), get_temperature(), get_radius())
	var color := Blackbody.temp_to_rgb(get_temperature())
	var color_max : float = max(color.r, color.g, color.b, 1.0)
	color /= color_max
	if not is_node_ready(): await ready
	$star.scale = Vector3.ONE * get_radius()
	$star/Sphere.set_instance_shader_parameter('data', data)
	$star/Sphere.set_instance_shader_parameter('color', color)
