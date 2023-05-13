extends Button
@export var scrambleCounter: LineEdit

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _pressed():
	var scrambleLoops:= int(scrambleCounter.text)
	print(scrambleLoops);
	scrambleLoops = clampi(scrambleLoops, 0, 30);
	scrambleCounter.text = str(scrambleLoops);
