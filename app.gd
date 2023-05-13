extends Control

@export var resetButton: Button;
@export var undoButton: Button;
@export var winnerLabel: Label;
@export var boardGrid: GridContainer;

const SOLUTION := [	1, 2,3,
					8,"",4,
					7, 6,5];
var history: Array;
var currentHistory: Array:
	get:
		return history[-1];
	set(value):
		return;

#TODO remove if you can find a way to remove callable inside itself
var _neighbor_mask: int;

# Called when the node enters the scene tree for the first time.
func _ready():
	reset();
	resetButton.pressed.connect(reset);
	undoButton.pressed.connect(undo);
	#check_win();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func reset():
	winnerLabel.lines_skipped = 1;
	history= [SOLUTION];
	boardGrid.set_board(currentHistory);
	print(currentHistory);
	#	TODO remove if you can find a way to remove callable inside itself
	for button in boardGrid.get_children():
		if(button is Button):
			(button as Button).pressed.connect(exchange_clicked.bind(button));
	_connect_neighbors();
	#for button in boardGrid.find_board_neighbors(currentHistory):
	#	print(int(button.text));
		
func handle_history(nextSquares:Array):
	history.append(nextSquares);

func undo():
	print(history.size())
	if history.size()>1:
		print("inside undo")
		history.pop_back();
		boardGrid.set_board(currentHistory);
		print(currentHistory);
		_connect_neighbors();

func _match_arrays(arr1: Array, arr2: Array) -> bool:
	for i in range(arr1.size()):
		if int(arr1[i]) != int(arr2[i]):
			return false;
	return true;

func check_win():
	if(!_match_arrays(SOLUTION,currentHistory)):
		return;
	winnerLabel.lines_skipped = 0;
	print("winner!")
	
func _connect_neighbors():
	_neighbor_mask=0;
	for button in boardGrid.find_board_neighbors(currentHistory):
	#	TODO remove if you can find a way to remove callable inside itself
		_neighbor_mask+=1<<(button as Node).get_index();
	#	(button as Button).pressed.connect(exchange_clicked.bind(button));

func _exchange_template(index: int) -> Array:
	var newSquares = SOLUTION.duplicate()
	var emptyIndex = boardGrid.emptyIndex;
	newSquares[index]=SOLUTION[emptyIndex];
	newSquares[emptyIndex]=SOLUTION[index];
	return newSquares;

func exchange_clicked(button: Button):
	#	TODO remove if you can find a way to remove callable inside itself
	if((1<<button.get_index()&_neighbor_mask)):
		var index = button.get_index();
		#print(button.pressed.get_connections()[0]["callable"])
		#button.pressed.disconnect(button.pressed.get_connections()[0]["callable"]);
		boardGrid.slide_on_board(currentHistory, index);
		handle_history(_exchange_template(index));
		check_win();
		_connect_neighbors();

func exchange_scrambled():
	var neighbors:= boardGrid.find_board_neighbors(currentHistory) as Array;
	var neighborsSize = neighbors.size();
	var index: int;
	var repeatedMove: bool;
	for n in neighbors:
		(n as Button).pressed.disconnect(exchange_clicked);
	for loop in range(0, 3): #	TODO scramble counter as upper range
		index = randi()%neighborsSize;
		neighbors[index]
		#boardGrid.slide_on_board
		#handle_history
		if history.size()>2:
			if (!_match_arrays(currentHistory,history[-3])):
				loop-=2;
	_connect_neighbors();
