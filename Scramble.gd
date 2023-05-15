extends Button
@export var scrambleCounter: LineEdit

func get_scramble_loops() -> int:
	var scrambleLoops:= int(scrambleCounter.text)
	print(scrambleLoops);
	scrambleLoops = clampi(scrambleLoops, 0, 30);
	scrambleCounter.text = str(scrambleLoops);
	return scrambleLoops;
