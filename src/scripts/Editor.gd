extends Spatial

var cursorPos = Vector3(1,0,0)
var cursor
var puzzleMan
var puzzle
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


var puzzleScn = preload("res://puzzle.scn")
var cursorScn = preload("res://cursor.scn")

func cursor_move(dir):
	var tween = Tween.new()
	var N = 2
	add_child(tween)
	tween.interpolate_method( cursor, "set_global_transform", \
		cursor.get_global_transform(), cursor.get_global_transform().translated(dir * N), \
		0.25, Tween.TRANS_EXPO, Tween.EASE_OUT )
	tween.start()
	cursorPos += dir
	selectedBlock = gridMan.get_block(cursorPos)

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
				cursor_action()

func cursor_action():
	if not selectedBlock == null:
		print("CHILDREN:",gridMan.get_child_count())
		gridMan.remove_block(selectedBlock)
		print("CHILDREN:",gridMan.get_child_count())

		selectedBlock = null

func _ready():
	var pMan = puzzleScn.instance()
	gridMan = pMan.get_node("GridView/GridMan")
	cursor = cursorScn.instance()
	pMan.mainPuzzle = false
	pMan.time.on = false
	puzzleMan = pMan.puzzleMan
	pMan.set_as_toplevel(true)

	var pos = Vector2(10, 10)
	for k in gui.keys():
		pos.y += 45
		gui[k].set_theme(preload("res://themes/MainTheme.thm"))
		gui[k].set_text(gui_text[k])
		gui[k].set_pos(pos)
		add_child(gui[k]);

	gridMan.add_child(cursor)
	add_child(pMan)
	cursor.set_owner(pMan)



	set_process_input(true)


