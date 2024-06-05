extends Node
class_name StarServerAutoload

@onready var star_index := CosmicDatabase.new()
@onready var star_buffer := preload('res://world/sky/starbuffer.tres')

func _ready() -> void:
	for i in star_buffer.count:
		star_index.insert(star_buffer.get_x(i), star_buffer.get_y(i), star_buffer.get_z(i))
	var nearest := star_index.nearest(0, 0, 0)
	print('nearest is %d at %.1f' % [nearest, star_index.relative(nearest, 0, 0, 0).length() / 9.461e15])
	print('starserver ready')
