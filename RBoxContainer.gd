extends BoxContainer
var view: Viewport;
var _viewSize: Vector2;

#var _lastWasVertical: bool;


# Called when the node enters the scene tree for the first time.
func _ready():
	view = get_viewport();
	#	switch_orientation();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _draw():
	#viewsize variable is kept in memory between loops
	_viewSize = view.get_visible_rect().size;
	#	switch_orientation();
	if _viewSize.y>_viewSize.x:
		vertical = true;
		return;
	vertical = false;
