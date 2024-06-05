@tool
extends Resource
class_name StarBuffer

const STRIDE := 32

@export var rng_hash := 0

@export var count := 0:
	set(value):
		count = value
		buffer.resize(count * STRIDE)

@export var buffer := PackedByteArray()


func set_star(i: int, m: float, x: int, y: int, z: int):
	var offset := i * STRIDE
	buffer.encode_s64(offset + 0, x)
	buffer.encode_s64(offset + 8, y)
	buffer.encode_s64(offset + 16, z)
	buffer.encode_double(offset + 24, m)

func get_x(i: int) -> int:
	return buffer.decode_s64(i * STRIDE + 0)

func get_y(i: int) -> int:
	return buffer.decode_s64(i * STRIDE + 8)

func get_z(i: int) -> int:
	return buffer.decode_s64(i * STRIDE + 16)

func mass(i: int) -> float:
	return buffer.decode_double(i * STRIDE + 24)

func temperature(i:int) -> float:
	return 5740.0 * mass(i) ** 0.54

func luminosity(i:int) -> float:
	return mass(i) ** 3.5

func radius(i:int) -> float:
	return mass(i) ** 0.8

func color(i:int) -> Color:
	return Color(Blackbody.temp_to_rgb(temperature(i)), luminosity(i))

func regenerate():
	var imf := KroupaIMF.new()
	var rng := RandomNumberGenerator.new()
	rng.seed = 137
	for i in count:
		var m := imf.get_mass(rng.randf())
		var x := int(rng.randfn(0, 3.784e17))
		var y := int(rng.randfn(0, 3.784e17))
		var z := int(rng.randfn(0, 3.784e17))
		set_star(i, m, x, y, z)
	set_star(0, 1.0, 800_000_000_000_000_000, 0, 0)
	set_star(1, 0.1, 0, 800_000_000_000_000_000, 0)
	set_star(2, 150, 0, 0, 800_000_000_000_000_000)
	rng_hash = hash('%s:%s:3' % [rng.seed, rng.state])
