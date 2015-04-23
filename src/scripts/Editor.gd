extends Spatial

var cursorPos = Vector3(1,0,0)
var cursor
var puzzleMan
var puzzle
var gridMan
var selectedBlock = null

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
	
	gridMan.add_child(cursor)
	add_child(pMan)
	cursor.set_owner(pMan)

	set_process_input(true)


