extends Spatial

var puzzleScn = preload("res://puzzle.scn")
var puzzle
var puzzleMan

var gridMan
var prevBlock = null

var fileDialog = load("res://fileDialog.scn").instance()
var gui = [
	["status", Label.new()], # plz keep me as first element, referenced as gui[0] later
	["save_pzl", Button.new()],
	["load_pzl", Button.new()],
	["remove_layer", Button.new()],
	["random_layer", Button.new()],
	# THESE SHOULD BE Options instead of left, label, right
	["class_toggle", {
		left=Button.new(),
		right=Button.new(),
		label=Label.new(),
		values=["LZR", "WILD", "PAIR", "GOAL"],
		value="PAIR"
	}],
	["color_toggle", {
		left=Button.new(),
		right=Button.new(),
		label=Label.new(),
		values=preload("res://scripts/PuzzleManager.gd").blockColors,
		value="Red"
	}],
	["action_toggle", {
		left=Button.new(),
		right=Button.new(),
		label=Label.new(),
		values=["Add", "Remove", "Replace"],
		value="Add"
	}],
	["test_pzl", Button.new()],
]

func shouldAddNeighbor():
	return true

func shouldReplaceSelf():
	return false

func shouldRemoveSelf():
	return false

func newPickledBlock():
	var b = puzzleMan.PickledBlock.new()\
		.setName(gridMan.shape.keys().size())\
	if prevBlock != null:
		b.setPairName(prevBlock.name)
		gridMan.get_node(prevBlock.toNode().name).setPairName(b.name)
		prevBlock = null
		gui[0][1].set_text("STATUS: ERROR, ADD PAIR")
	else:
		prevBlock = b
		gui[0][1].set_text("STATUS: NOMINAL")
	return b

func updateToggle(togg, increase):
	if increase:
		var next_ix = togg.values.find(togg.value) + 1
		if (next_ix >= togg.values.size()):
			next_ix = 0
		togg.value = togg.values[next_ix]
	else:
		var next_ix = togg.values.find(togg.value) - 1
		if (next_ix < 0):
			next_ix = togg.values.size() - 1
		togg.value =  togg.values[next_ix]
	togg.label.set_text(togg.value)

func puzzleSave(loadInstead=false):
	fileDialog.popup_centered()



func _ready():
	puzzle = puzzleScn.instance()
	gridMan = puzzle.get_node("GridView/GridMan")
	puzzle.mainPuzzle = false
	puzzle.time.on = false;
	puzzle.time.val = ''
	puzzle.set_as_toplevel(true)

	add_child(puzzle)
	puzzleMan = puzzle.puzzleMan

	set_process_input(true)

	var theme = preload("res://themes/MainTheme.thm")
	var dialogTheme = Theme.new()
	dialogTheme.copy_default_theme()

	fileDialog.set_title("Select Puzzle Filename")
	fileDialog.set_access(FileDialog.ACCESS_USERDATA)
	fileDialog.set_theme(dialogTheme)
	fileDialog.hide()
	add_child(fileDialog)
	
	var y = 0
	for control in gui:
		y += 45
		if control[0].rfind('_toggle') > 0:
			var togg = control[1]
			for cont in togg.keys():
				if not cont.begins_with('value'):
					var e = togg[cont]
					e.set_pos(Vector2(10, y))
					e.set_theme(theme)
					add_child(e)

			togg.left.set_text("<")
			togg.left.connect('pressed', self, 'updateToggle', [togg, false])

			togg.label.set_pos(Vector2(90, y + 4))
			togg.label.set_text(togg.value)

			togg.right.set_pos(Vector2(55, y))
			togg.right.set_text(">")
			togg.right.connect('pressed', self, 'updateToggle', [togg, true])

		else:
			var e = control[1]
			e.set_pos(Vector2(10, y))
			e.set_theme(theme)
			if e extends Button:
				e.set_text(control[0])
			if control[0] == 'save_pzl' :
				e.connect('pressed', self, 'puzzleSave')
			if control[0] == 'load_pzl' :
				e.connect('pressed', self, 'puzzleSave', [true])
			if control[0] == 'status':
				control[1].set_text('STATUS: NOMINAL')
			add_child(e)


