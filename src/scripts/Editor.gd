extends Spatial



var puzzleScn = preload("res://puzzle.scn")
var cursorScn = preload("res://cursor.scn")

var cursorPos = Vector3(1,6,0)
var cursor
var puzzle = puzzleScn.instance()
var puzzleMan = puzzle.puzzleMan
var gridMan
var selectedBlock = null

var gui = {
	add=Button.new(),
	rm=Button.new(),
	save_pzl=Button.new(),
	load_pzl=Button.new()
}
var gui_text = {
	add="Add Block",
	rm="Remove Block",
	save_pzl="Save",
	load_pzl="Load"
}


func cursor_move(dir):
	var tween = Tween.new()
	var N = 2
	add_child(tween)
	tween.interpolate_method( cursor, "set_global_transform", \
		cursor.get_global_transform(), cursor.get_global_transform().translated(dir * N), \
		0.25, Tween.TRANS_EXPO, Tween.EASE_OUT )
	tween.start()
	cursorPos += dir
	selectedBlock = gridMan.get_block(cursorPos / 2)

func _input(ev):
	if ev.type == InputEvent.KEY:
		if ev.is_pressed():
			if Input.is_action_pressed("ui_up"):
				cursor_move(Vector3(0,1,0))
			if Input.is_action_pressed("ui_down"):
				cursor_move(Vector3(0,-1,0))
			if Input.is_action_pressed("ui_left"):
				cursor_move(Vector3(1,0,0))
			if Input.is_action_pressed("ui_right"):
				cursor_move(Vector3(-1,0,0))
			if Input.is_action_pressed("ui_page_up"):
				cursor_move(Vector3(0,0,1))
			if Input.is_action_pressed("ui_page_down"):
				cursor_move(Vector3(0,0,-1))
			if Input.is_action_pressed("ui_accept"):
				delete_block()

func delete_block():
	if not selectedBlock == null:
		gridMan.remove_block(selectedBlock)
	selectedBlock = null

func cursor_action():
	if not selectedBlock == null:
		print("CHILDREN:",gridMan.get_child_count())
		print("CHILDREN:",gridMan.get_child_count())
		delete_block()
		selectedBlock = null

func add_block():
	if gridMan.get_block(cursorPos) != null:
		return

	var pickled = preload("PuzzleManager.gd").PickledBlock.new()
	pickled.blockPos = cursorPos * 2
	pickled.name = 300
	
	pickled.setBlockClass( preload("PuzzleManager.gd").BLOCK_PAIR) \
					.setTextureName("Red")
				
	var n = pickled.toNode()

	gridMan.add_block(n)
	print(n.name, gridMan.get_node(n.name))
	gridMan.print_tree()
	gridMan.get_node(n.name) \
			.set_translation(pickled.blockPos)


func _ready():
	gridMan = puzzle.get_node("GridView/GridMan")
	cursor = cursorScn.instance()
	puzzle.mainPuzzle = false
	puzzle.time.on = false
	puzzle.set_as_toplevel(true)

	var pos = Vector2(10, 10)
	for k in gui.keys():
		pos.y += 45
		gui[k].set_theme(preload("res://themes/MainTheme.thm"))
		gui[k].set_text(gui_text[k])
		gui[k].set_pos(pos)
		add_child(gui[k]);
	gui.add.connect("pressed", self, "add_block")
	gui.rm.connect("pressed", self, "delete_block")
	
	gridMan.add_child(cursor)
	
	add_child(puzzle)
	cursor.set_owner(puzzle)

	set_process_input(true)


