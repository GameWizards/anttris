extends Spatial

var puzzle
var puzzleMan

var gridMan
var prevBlock = [] # keeps track of prevous color for pairs by layer
var blockColors = preload("res://scripts/PuzzleManager.gd").blockColors
var id

var fd
var gui = [
	["status", Label.new()], # plz keep me as first element, referenced as gui[0] later
	["save_pzl", Button.new()],
	["load_pzl", Button.new()],
	["remove_layer", Button.new()],
	["random_layer", Button.new()],
	# THESE SHOULD BE Options instead of left, label, right
	["class_toggle", {
		optionButt=OptionButton.new(),
		values=["LZR", "WILD", "PAIR", "GOAL"],
		value="PAIR"
	}],
	["color_toggle", {
		optionButt=OptionButton.new(),
		values=blockColors,
		value="Blue"
	}],
	["action_toggle", {
		optionButt=OptionButton.new(),
		values=["Add", "Remove", "Replace"],
		value="Add"
	}],
	["test_pzl", Button.new()],
]
var action_ix = gui.size() - 1 - 1
var color_ix = gui.size() - 1 - 2
var class_ix = gui.size() - 1 - 3

# gross style, cannot , but clean enough
func shouldAddNeighbor():
	return gui[action_ix][1].value == "Add"

func shouldReplaceSelf():
	return gui[action_ix][1].value == "Replace"

func shouldRemoveSelf():
	return gui[action_ix][1].value == "Remove"

# called in AbstractBlock to add a new block
func addBlock(pos):
	var curColor = gui[color_ix][1].value
	var b = puzzleMan.PickledBlock.new() \
		.setName(id) \
		.setTextureName(curColor) \
		.setBlockPos(pos)
	var layer = puzzleMan.calcBlockLayerVec(pos)
	id += 1

	# expand prevblocks index
	while prevBlock.size() <= layer:
		var d = {}
		for k in blockColors:
			d[k] = null
		prevBlock.append(d)

	var pb = prevBlock[layer][curColor]

	if pb != null:
		b.setPairName(pb.name)
		gridMan.get_node(pb.toNode().name).setPairName(b.name)
		prevBlock[layer][curColor] = null
	else:
		# TODO SUPPORT GLYPHS HERE, SET PAIRWISE GLYPH
		prevBlock[layer][curColor] = b

	gui[0][1].set_text(getPrevBlockErrors())
	var block = gridMan.addPickledBlock(b)
	var v = 0.01
	block.set_scale(Vector3(v,v,v))
	block.scaleTweenNode(1, 0.25, Tween.TRANS_QUART).start()
	return b

func getPrevBlockErrors():
	# hahaha, so bad
	var missing = "STATUS: "
	# check every layer
	for l in range(prevBlock.size()):
		# check every color
		for k in prevBlock[l].keys():
			var missed = false
			if prevBlock[l][k] != null:
				# one message about the current layer
				if not missed:
					missing += " L" + str(l) + " "
					missed = true
				missing += k.to_upper() + " " # bad way of constructing strings
	if missing == "":
		missing += "NOMINAL"
	return missing

func changeValue(ix, togg):
	togg.value = togg.values[ix]

func _ready():
	# lights!
	get_tree().get_root().add_child(preload( "res://puzzleView.scn" ).instance())
	puzzle = preload( "res://puzzle.scn" ).instance()
	puzzle.mainPuzzle = false

	# hide and disable timer
	puzzle.time.on = false;
	puzzle.time.val = ''
	print(puzzle.time)

	puzzle.set_as_toplevel(true)
	get_tree().get_root().add_child(puzzle)

	gridMan = puzzle.get_node("GridView/GridMan")
	id = gridMan.shape.size()

	puzzleMan = puzzle.puzzleMan

	set_process_input(true)

	var theme = preload("res://themes/MainTheme.thm")
	initLoadSaveDialog(self)

	var y = 0
	for control in gui:
		y += 45
		if control[0].rfind('_toggle') > 0:
			var togg = control[1]
			var e = togg.optionButt
			e.set_pos(Vector2(10, y))
			e.set_theme(theme)
			add_child(e)

			# index of items needed
			e.connect("item_selected", self, "changeValue", [togg])
			for i in range(togg.values.size()):
				e.add_item(togg.values[i], i)
				# e.add_icon_item(togg.values[i], i)

		else:
			var e = control[1]
			e.set_pos(Vector2(10, y))
			e.set_theme(theme)
			if e extends Button:
				e.set_text(control[0])
			if control[0] == 'save_pzl' :
				e.connect('pressed', self, 'showSaveDialog')
			if control[0] == 'load_pzl' :
				e.connect('pressed', self, 'showLoadDialog')
			if control[0] == 'status':
				control[1].set_text('STATUS: NOMINAL')
			add_child(e)


func puzzleSave():
	print("SAVING TO ", fd.get_current_file() )

func puzzleLoad():
	print("LOADING FROM ", fd.get_current_file() )

func showLoadDialog():
	showSaveDialog(true)

func showSaveDialog(loadInstead=false):
	if loadInstead:
		if fd.is_connected("confirmed", self, "puzzleSave"):
			fd.disconnect("confirmed", self, "puzzleSave")
		fd.connect("confirmed", self, "puzzleLoad")
		fd.set_mode(FileDialog.MODE_OPEN_FILE)
	else:
		if fd.is_connected("confirmed", self, "puzzleLoad"):
			fd.disconnect("confirmed", self, "puzzleLoad")
		fd.connect("confirmed", self, "puzzleSave")
		fd.set_mode(FileDialog.MODE_SAVE_FILE)

	fd.popup_centered()

func initLoadSaveDialog(parent):
	# setup text in the file dialog
	parent.fd = load("res://fileDialog.scn").instance()
	parent.fd.set_title("Select Puzzle Filename")
	parent.fd.set_access(FileDialog.ACCESS_USERDATA)
	parent.fd.set_current_dir("PuzzleSaves")
	parent.fd.add_filter("*.pzl ; Anttris Puzzle")

	# MainTheme leaks on bottom
	var dialogTheme = Theme.new()
	dialogTheme.copy_default_theme()
	parent.fd.set_theme(dialogTheme)

	# work even if game is paused
	parent.fd.set_pause_mode(PAUSE_MODE_PROCESS)

	# unpause if user cancels
	parent.fd.connect("popup_hide", get_tree(), "set_pause", [false])
	parent.fd.connect("hide", get_tree(), "set_pause", [false])
	parent.fd.connect("about_to_show", get_tree(), "set_pause", [true])
	parent.fd.hide()

	parent.add_child(fd)
	fd.set_owner(parent)
