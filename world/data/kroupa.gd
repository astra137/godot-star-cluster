### Stellar initial mass function loosely based on Kroupa's IMF
class_name KroupaIMF

var precomputed := []

func a(m: float) -> float:
	if m < 0.08: return 0.3
	if m < 0.5: return 1.3
	return 2.35

func print_mappings():
	push_warning('imf is ready with %d divisions' % precomputed.size())
	print('here are some example mappings:')
	for i in 11:
		var x := i / 10.0
		var m := get_mass(x)
		var l := pow(m, 3.5)
		print('%.1f -> %.2f [%.2f] (%.2f)' % [x, m, l, log(l)])

func _init() -> void:
	const power = 1.2
	var total = 0.0
	var m = 0.08
	while m < 250:
		var dm = (m * power) - m
		var count = (m ** -a(m)) * dm
		precomputed.push_back([m, dm, count])
		total += count
		m *= power
	for row in precomputed:
		row[2] /= total

func get_mass(percentile: float) -> float:
	var base = 0
	for row in precomputed:
		var m = row[0]
		var dm = row[1]
		var ratio = row[2]
		if percentile <= base + ratio:
			return m + (dm * percentile)
		base += ratio
	return NAN

