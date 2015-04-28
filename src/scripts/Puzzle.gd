# Provides functionality for the puzzle itself

extends Spatial

var DataMan = preload( "res://scripts/DataManager.gd" ).new()
var PuzzleManScript = preload( "res://scripts/PuzzleManager.gd" )
var PuzzleScn = preload("res://puzzle.scn")
var puzzleMan
var seed
var otherPuzzle
var generateRandom = true
var mainPuzzle = false

var time = {
		on = true,
		val = 0.0,
		label = Label.new(),
		tween = Tween.new() }

func addTimer():
	add_child(time.label)
	add_child(time.tween)
	time.label.set_pos(Vector2(15,15))

	time.label.set_theme(load("res://themes/MainTheme.thm"))
	time.tween.interpolate_method(time.label, "set_pos", \
			time.label.get_pos(), time.label.get_pos()*2, 0.5, \
			Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	time.tween.start()
	time.label.set_text(str(time.val))

func formatTime(t):
	var mins = floor(t / 60)
	var secs = fmod(floor(t), 60)
	var millis = floor((t - floor(t)) * 1000)
	return str(mins) + ":" + str(secs).pad_zeros(2) + ":" + str(millis).pad_zeros(3)

func _process(dTime):
	# start label tween on
	time.val += dTime
	time.label.set_text(formatTime(time.val))
	if fmod(time.val, 10) < 0.1:
		time.tween.seek(0.0)

# Called for initialization
func _ready():
	if time.on:
		set_process(true) # needed for time keeping
	addTimer()

	#set up network stuffs
	add_child(load("res://networkProxy.scn").instance())
	var Network = Globals.get("Network")
	if Network != null:
		Network.proxy.set_process(Network.isClient or Network.isHost)


	# generate puzzle
	puzzleMan = PuzzleManScript.new()

	if generateRandom:
		seed = OS.get_unix_time() # unix time
		seed *= OS.get_ticks_msec() # initial time
		seed *= 1 + OS.get_time().second
		seed *= 1 + OS.get_date().weekday
		seed = abs(seed) % 7919 # 1000th prime

		var puzzle = puzzleMan.generatePuzzle( 1, puzzleMan.DIFF_EASY )
		puzzle.puzzleMan = puzzleMan
		var steps = puzzle.solvePuzzleSteps()
		print("Generated ", puzzle.shape.size(), " blocks." )
		print( "PUZZLE IS SOLVEABLE?: ", steps.solveable )

		get_node( "GridView/GridMan" ).set_puzzle(puzzle)

	# make a new puzzle, embed using Viewport
	if mainPuzzle:
		var p = PuzzleScn.instance()
		#p.remove_and_delete_child(p.get_node("Lights"))
		#.remove_and_delete_child(p.get_node("Camera"))
		p.get_node("GridView").active = false
		p.mainPuzzle = false
		p.set_scale(Vector3(0.5, 0.5, 0.5))
		p.set_translation(Vector3(10, 5, -20))

		var v = Viewport.new()
		var c = Control.new()

		v.set_world(p.get_world())
		v.set_rect(Rect2(0, 0, 100, 100))
		v.set_physics_object_picking(false)
		get_tree().get_root().get_node( "Spatial" ).get_node( "Camera" ).add_child(p)
		v.add_child(p)
		add_child(c)
		c.add_child(v)
		otherPuzzle = p #for use with network
# child of control? easier input


