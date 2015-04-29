extends Spatial

const NO_ERRORS = "STATUS NOMINAL"

var puzzle
var puzzleMan
var DataMan = preload("res://scripts/DataManager.gd")

var gridMan
var prevBlocks = [] # keeps track of prevous color for pairs by layer
var blockColors = preload("res://scripts/PuzzleManager.gd").blockColors
var id

var saveDir = OS.get_data_dir() + "/PuzzleSaves"

var glyphIx = 0

var fd
var gui = [
	["status", Label.new()], # plz keep me as first element, referenced as gui[0] later
	["save_pzl", Button.new()],
	["load_pzl", Button.new()],
	["remove_layer", Button.new()],
	["random_layer", Button.new()],
	["class_toggle", {
		optionButt=OptionButton.new(),
		values=["WILD", "PAIR"],
		# const BLOCK_LASER	= 0
		# const BLOCK_WILD	= 1
		# const BLOCK_PAIR	= 2
		# const BLOCK_GOAL	= 3
		# const BLOCK_BLOCK   = 4
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
	var selected = gui[class_ix][1].value
	var b = puzzleMan.PickledBlock.new() \
		.setName(id) \
		.setBlockPos(pos) \
		.setBlockClass(gui[class_ix][1].optionButt.get_selected() + 1)
		# VERY FRAGILE INDEX STUFF
	var layer = puzzleMan.calcBlockLayerVec(pos)
	if layer == 0 and not selected == "GOAL":
		return

	if selected == "LZR" or selected == "GOAL":
		print("CANNOT MK ", str(selected))
		return

	if selected == "WILD":
		b.setTextureName(curColor)
	# must be a paired block

	else:
		id += 1

		# expand prevblocks index
		while prevBlocks.size() <= layer:
			var d = {}
			for k in blockColors:
				d[k] = null
			prevBlocks.append(d)

		var pb = prevBlocks[layer][curColor]

		if pb != null:
			var prevName = pb.toNode().name
			var pbNode = gridMan.get_node(prevName)

			b.setPairName(pb.name)
			pb.setPairName(b.name)

			b.setTextureName(pb.textureName)

			gridMan.remove_block(pb)
			gridMan.addPickledBlock(pb)
			prevBlocks[layer][curColor] = null
		else:
			prevBlocks[layer][curColor] = b
			glyphIx += 1
			glyphIx %= 3
			b.setTextureName(curColor + str(glyphIx + 1))

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
	for l in range(prevBlocks.size()):
		# check every color
		for k in prevBlocks[l].keys():
			var missed = false
			if prevBlocks[l][k] != null:
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

	puzzle.set_as_toplevel(true)
	get_tree().get_root().add_child(puzzle)

	gridMan = puzzle.get_node("GridView/GridMan")
	id = gridMan.puzzle.shape.size()

	puzzleMan = puzzle.puzzleMan

	set_process_input(true)

	var theme = preload("res://themes/MainTheme.thm")
	fd = initLoadSaveDialog(self, get_tree(), saveDir)

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
				if togg.value == togg.values[i]:
					e.select(i)
				# e.add_icon_item(togg.values[i], i)

		else:
			var e = control[1]
			e.set_pos(Vector2(10, y))
			e.set_theme(theme)
			if e extends Button:
				e.set_text(control[0])
			if control[0] == 'save_pzl' :
				e.connect('pressed', self, 'showSaveDialog', [fd, self])
			if control[0] == 'load_pzl' :
				e.connect('pressed', self, 'showLoadDialog', [fd, self])
			if control[0] == 'status':
				control[1].set_text('STATUS: NOMINAL')
			add_child(e)


func puzzleSave():
	var f = fd.get_current_path()
	if f == null or f == "":
		return
	if getPrevBlockErrors() != NO_ERRORS:
		gui[0][1].set_text(getPrevBlockErrors() + " SAVING DISABLED! BANG HEAD ON KEYBOARD ")
		return
	print("SAVING TO ", f)
	DataMan.savePuzzle( f, gridMan.puzzle )

func puzzleLoad():
	var f = fd.get_current_path()
	if f == null or f == "":
		return
	print("LOADING FROM ", f)
	prevBlocks = []
	gridMan.set_puzzle(DataMan.loadPuzzle( f ))

static func showLoadDialog(fileD, parent):
	if fileD.is_connected("confirmed", parent, "puzzleSave"):
		fileD.disconnect("confirmed", parent, "puzzleSave")
	fileD.connect("confirmed", parent, "puzzleLoad")
	fileD.set_mode(FileDialog.MODE_OPEN_FILE)

	fileD.popup_centered()

static func showSaveDialog(fileD, parent):
	if fileD.is_connected("confirmed", parent, "puzzleLoad"):
		fileD.disconnect("confirmed", parent, "puzzleLoad")
	fileD.connect("confirmed", parent, "puzzleSave")
	fileD.set_mode(FileDialog.MODE_SAVE_FILE)

	fileD.popup_centered()

static func initLoadSaveDialog(parent, tree, saveDir):
	# setup text in the file dialog
	var fileDialog = load("res://fileDialog.scn").instance()
	fileDialog.set_title("Select Puzzle Filename")
	fileDialog.set_access(FileDialog.ACCESS_FILESYSTEM)
	fileDialog.add_filter("*.pzl ; Anttris Puzzle")

	Directory.new().make_dir_recursive(saveDir)
	fileDialog.set_current_dir(saveDir)
	print("Saves in ", saveDir)

	# MainTheme leaks on bottom
	var dialogTheme = Theme.new()
	dialogTheme.copy_default_theme()
	fileDialog.set_theme(dialogTheme)

	# work even if game is paused
	fileDialog.set_pause_mode(PAUSE_MODE_PROCESS)

	# unpause if user cancels
	fileDialog.connect("popup_hide", tree, "set_pause", [false])
	fileDialog.connect("hide", tree, "set_pause", [false])
	fileDialog.connect("about_to_show", tree, "set_pause", [true])
	fileDialog.hide()

	parent.add_child(fileDialog)
	fileDialog.set_owner(parent)
	return fileDialog
