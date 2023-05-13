extends Control

@export var resetButton: Button;
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

# Called when the node enters the scene tree for the first time.
func _ready():
	reset();
	resetButton.pressed.connect(reset);
	#check_win();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func reset():
	winnerLabel.lines_skipped = 1;
	history= [SOLUTION];
	boardGrid.set_board(currentHistory);
	print(currentHistory);
	_connect_neighbors();
	#for button in boardGrid.find_board_neighbors(currentHistory):
	#	print(int(button.text));
		
	
func handle_history(nextSquares:Array):
	nextSquares.append(history);

func _match_arrays(arr1: Array, arr2: Array) -> bool:
	for i in range(arr1.size()):
		if arr1[i] != arr2[i]:
			return false;
	return true;

func check_win():
	if(!_match_arrays(SOLUTION,currentHistory)):
		return;
	winnerLabel.lines_skipped = 0;
	print("winner!")
	
func _connect_neighbors():
	for button in boardGrid.find_board_neighbors(currentHistory):
		(button as Button).pressed.connect(exchange_clicked.bind(button));

func _exchange_template(index: int) -> Array:
	var newSquares = SOLUTION.duplicate()
	var emptyIndex = boardGrid.emptyIndex;
	newSquares[index]=SOLUTION[emptyIndex];
	newSquares[emptyIndex]=SOLUTION[index];
	return newSquares;

func exchange_clicked(button: Button):
	var index = button.get_index();
	button.pressed.disconnect(exchange_clicked);
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
