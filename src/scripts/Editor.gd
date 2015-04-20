extends Spatial

var cursorPos = Vector3(15,0,0)
var cursor
var puzzleMan
var puzzle
var gridMan

var puzzleScn = preload("res://puzzle.scn")
var cursorScn = preload("res://cursor.scn")

func cursor_move(dir):
	var tween = Tween.new()
	var N = 1.5
	add_child(tween)
	tween.interpolate_method( cursor, "set_translation", \
		cursor.get_translation(), cursor.get_translation() + dir * N, \
		0.25, Tween.TRANS_EXPO, Tween.EASE_OUT )
	tween.start()
	
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

func _ready():
	var pMan = puzzleScn.instance()
	cursor = cursorScn.instance()
	cursor.set_translation(cursorPos)
	pMan.mainPuzzle = false
	pMan.time.on = false
	puzzleMan = pMan.puzzleMan
	print(pMan.get_child("GridView/GridMan"))
	pMan.get_child("GridView/GridMan").add_child(cursor)
	add_child(pMan)
	
	
	set_process_input(true)


