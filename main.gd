extends Node

const STAR := preload('res://world/star/star.tscn')

var db := CosmicDatabase.new()
var id := db.insert(473000000000000000, 0, 0)
var dst := 0


func _input(event):
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_0: dst = 0
		if event.keycode == KEY_1: dst = 1
		if event.keycode == KEY_2: dst = 2
		if event.keycode == KEY_3: dst = 3
		if event.keycode == KEY_4: dst = 4
		if event.keycode == KEY_5: dst = 5


func _process(delta: float) -> void:
	var r := db.absolute(id)
	%sky.update_camera(%POV.quaternion, r[0], r[1], r[2])


func _physics_process(delta: float) -> void:
	if dst == 0:
		db.schooch(id, delta * Vector3(-1e15, 0, 0))
	else:
		var r := db.absolute(id)
		var v := StarServer.star_index.absolute(dst)
		var d := Vector3(v[0] - r[0], v[1] - r[1], v[2] - r[2])
		if d.length() > 7e9 * StarServer.star_buffer.radius(dst):
			db.schooch(id, delta * d)
		%POV.quaternion = %POV.quaternion.slerp(Quaternion(Basis.looking_at(d)), delta)
	
	var r := db.absolute(id)
	var started := Time.get_ticks_usec()
	var nearby_stars := StarServer.star_index.nearby(r[0], r[1], r[2])
	var elapsed := Time.get_ticks_usec() - started
	
	for i in nearby_stars:
		if not %stars.has_node(str(i)):
			var node := STAR.instantiate()
			node.name = str(i)
			node.mass = StarServer.star_buffer.mass(i)
			%stars.add_child(node)
			print('add star %d (%.1f M)' % [i, node.mass])
	for n in %stars.get_children():
		var k := n.name.to_int()
		if nearby_stars.has(k):
			var v := StarServer.star_index.absolute(k)
			n.update_faux_position(Vector3(v[0] - r[0], v[1] - r[1], v[2] - r[2]))
		else:
			n.queue_free()
