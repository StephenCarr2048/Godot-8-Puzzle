extends Control

@export var resetButton: Button;
@export var undoButton: Button;
@export var winnerLabel: Label;
@export var boardGrid: GridContainer;

var inputX:=0;
var inputY:=0;

const SOLUTION := [	1, 2,3,
					8, 0,4,
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
	
	#exchange_scrambled()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	inputX= int(event.is_action_pressed("ui_left"))-int(event.is_action_pressed("ui_right"));
	inputY= int(event.is_action_pressed("ui_up"))-int(event.is_action_pressed("ui_down"));
	if((inputX==0 or inputY==0) and (inputX!=0 or inputY!=0)): #xor to prevent diagonals
		var child: Control;
		print("x: "+str(inputX));
		print("y: "+str(inputY));
		var neighbors = boardGrid.find_board_neighbors(currentHistory) as Array;
		child = boardGrid.get_child(boardGrid.vector_to_index(Vector2i(inputX,0))+boardGrid.emptyIndex);
		if child in neighbors:
			exchange_clicked(child);
			return;
		child = boardGrid.get_child(boardGrid.vector_to_index(Vector2i(0,inputY))+boardGrid.emptyIndex);
		if child in neighbors:
			exchange_clicked(child);
func reset():
	winnerLabel.text=" ";
	#winnerLabel.lines_skipped = 1;
	history= [SOLUTION];
	boardGrid.set_board(currentHistory);
	#	TODO remove if you can find a way to remove callable inside itself
	_bind_buttons();
		
func handle_history(nextSquares:Array):
	history.append(nextSquares);
	print(history);
	
func undo():
	print(history.size())
	if history.size()>1:
		print("inside undo")
		history.pop_back();
		#var newHistory:=[];
		#history = newHistory;
		boardGrid.set_board(currentHistory);
		print(history);
		_bind_buttons();

func _bind_buttons():
	for button in boardGrid.get_children():
		if(button is Button):
			(button as Button).pressed.connect(exchange_clicked.bind(button));
	_connect_neighbors();

func _match_arrays(arr1: Array, arr2: Array) -> bool:
	for i in range(arr1.size()):
		if arr1[i] != arr2[i]:
			return false;
	return true;

func check_win():
	if(!_match_arrays(SOLUTION,currentHistory)):
		return;
	#winnerLabel.lines_skipped = 0;
	print("winner!")
	#print(winnerLabel.lines_skipped)
	winnerLabel.text="Winner ♔";
	
func _connect_neighbors():
	_neighbor_mask=0;
	for button in boardGrid.find_board_neighbors(currentHistory):
	#	TODO remove if you can find a way to remove callable inside itself
		_neighbor_mask+=1<<(button as Node).get_index();
		#(button as Button).pressed.connect(exchange_clicked.bind(button));		TODO add back if needed

func _exchange_template(index: int) -> Array:
	var newSquares = currentHistory.duplicate(true);
	var emptyIndex = boardGrid.emptyIndex;
	newSquares[index]=currentHistory[emptyIndex];
	newSquares[emptyIndex]=currentHistory[index];
	return newSquares;

func exchange_clicked(button: Button):
	#	TODO remove if you can find a way to remove callable inside itself
	if((1<<button.get_index()&_neighbor_mask)):
		var index = button.get_index();
		#print(button.pressed.get_connections()[0]["callable"])
		#button.pressed.disconnect(button.pressed.get_connections()[0]["callable"]);
		handle_history(_exchange_template(index));
		boardGrid.slide_on_board(currentHistory, index);
		check_win();
		_connect_neighbors();

func exchange_scrambled():
	var neighbors: Array;
	var index: int;
	var repeatedMove: bool;
	#for n in neighbors:
	#	(n as Button).pressed.disconnect(exchange_clicked);
	for loop in range(6): #	TODO scramble counter as upper range
		neighbors = boardGrid.find_board_neighbors(currentHistory);
		index = randi()%neighbors.size();
		exchange_clicked(neighbors[index]);		#TODO replace with code that doesn't update history or redraw
		#boardGrid.slide_on_board
		#handle_history
		if history.size()>2:
			if (_match_arrays(currentHistory,history[-3])):
				loop-=2;
				history= history.slice(0, -2);
		_connect_neighbors();
	history = [currentHistory];
