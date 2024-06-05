@tool
extends Node3D

@onready var camera := $Camera3D as Camera3D
@onready var instance := $MultiMeshInstance3D as MultiMeshInstance3D

@export var star_count := 1000
@export var star_buffer := StarBuffer.new()
@export var imported_hash := 0


func _ready() -> void:
	if star_buffer.count != star_count:
		star_buffer.count = star_count
		star_buffer.regenerate()
	if imported_hash != star_buffer.rng_hash:
		imported_hash = star_buffer.rng_hash
		load_stars()

func update_camera(q: Quaternion, x: int, y: int, z: int) -> void:
	var f32x6 := to_scaled_f32x6(x, y, z)
	camera.quaternion = q
	instance.set_instance_shader_parameter('camera_position_course', f32x6[0])
	instance.set_instance_shader_parameter('camera_position_fine', f32x6[1])

func to_scaled_f32x6(x: int, y: int, z: int) -> Array[Vector3]:
	var v0 := Vector3(x, y, z)
	var v1 := Vector3(x - int(v0.x), y - int(v0.y), z - int(v0.z))
	return [v0 / 1e15, v1 / 1e15]

func load_stars():
	print('load_stars started with %s stars' % star_buffer.count)
	#var height := ceili(count / 1000)
	#var schooch := PackedVector3Array()
	#schooch.resize(1000 * height)
	instance.multimesh.instance_count = star_buffer.count
	for i in instance.multimesh.instance_count:
		var f32x6 := to_scaled_f32x6(star_buffer.get_x(i), star_buffer.get_y(i), star_buffer.get_z(i))
		instance.multimesh.set_instance_transform(i, Transform3D(Basis.IDENTITY, f32x6[0]))
		instance.multimesh.set_instance_custom_data(i, Color(f32x6[1].x, f32x6[1].y, f32x6[1].z, 0))
		instance.multimesh.set_instance_color(i, star_buffer.color(i))
	#var mat := instance.multimesh.mesh.surface_get_material(0)
	#var img := Image.create_from_data(1000, height, false, Image.FORMAT_RGBF, schooch.to_byte_array())
	#mat.set_shader_parameter('star_schooch', ImageTexture.create_from_image(img))
	print('load_stars completed')
