extends GridContainer

const _neighborOffsets:= [
				Vector2i(0,-1),
				
	Vector2i(-1,0),			Vector2i(1,0),
	
				Vector2i(0,1)
]

#(1,1) vector to int: 1+3*1=4
var emptyIndex:= 4;
#cashing between setBoards
var tableSize:= 9;

func vector_to_index(positionVector: Vector2i) -> int:
	return positionVector.x + positionVector.y*int(sqrt(tableSize))
	#see the conversion of 2d to 1d through x+y*3
		#[	0,	1,	2,
		#	3,	4,	5,
		#	6,	7,	8	]

func _sharing_row_xor_col(index1: int, index2: int, arraySize: int) -> bool:
	arraySize = sqrt(arraySize);
	var sharedRow:= index1/arraySize==index2/arraySize;
	var sharedColumn:= index1%arraySize==index2%arraySize;
	#equivalent to xor(A,B) but xor is not implemented on GDScript bools
	return (sharedRow or sharedColumn) and (!sharedRow or !sharedColumn) 

func set_board(table: Array):
	for child in get_children():
		remove_child(child);
		child.queue_free();
	tableSize=table.size();
	for i in range(tableSize):
		if typeof(table[i]) == TYPE_STRING:
			add_child(Control.new());
			emptyIndex = i;
			#print("empty " + str(empty))
		else:
			var button:= Button.new();
			button.text = str(table[i]);
			button.size_flags_horizontal = SIZE_EXPAND_FILL;
			button.size_flags_vertical = SIZE_EXPAND_FILL;
			add_child(button);

func find_board_neighbors(table: Array) -> Array:
	var neighbor: int;
	var buttonsInRange := [];
	for offset in _neighborOffsets:
		neighbor = emptyIndex+vector_to_index(offset);
		if (neighbor > -1				and
			neighbor < tableSize		and
			_sharing_row_xor_col(emptyIndex, neighbor, tableSize)):
				print("index: "+ str(neighbor));
				buttonsInRange.append(get_child(neighbor) as Button);
	return buttonsInRange;

func slide_on_board(table: Array, clickedIndex: int):
	var control=get_child(emptyIndex);
	var button=get_child(clickedIndex);
	move_child(button, emptyIndex)
	if(abs(emptyIndex-clickedIndex)>1):
		move_child(control, clickedIndex)
	emptyIndex = clickedIndex;
