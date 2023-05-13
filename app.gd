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
	boardGrid.slide_on_board(currentHistory, 3);
	#check_win();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func reset():
	history= [SOLUTION];
	boardGrid.set_board(currentHistory);
	for button in boardGrid.find_board_neighbors(currentHistory):
		print(int(button.text));
	
func handle_history(nextSquares:Array):
	nextSquares.append(history);

func check_win():
	var currentHistory = self.currentHistory;
	for i in range(SOLUTION.size()):
			if currentHistory[i] != SOLUTION[i]:
				return;
	winnerLabel.lines_skipped = 0;
	
