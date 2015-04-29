# Provides functionality for the puzzle itself

extends Spatial

var DataMan = preload( "res://scripts/DataManager.gd" ).new()
var PuzzleManScript = preload( "res://scripts/PuzzleManager.gd" )
var PuzzleScn = preload("res://puzzle.scn")
var puzzleMan
var seed
var initSeed
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

static func formatTime(t):
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
	var puzzle

	if generateRandom:
		seed = OS.get_unix_time() # unix time
		seed *= OS.get_ticks_msec() # initial time
		seed *= 1 + OS.get_time().second
		seed *= 1 + OS.get_date().weekday
		seed = abs(seed) % 7919 # 1000th prime
		
		#store the seed used to generate this puzzle for Network communications
		initSeed = seed
		rand_seed(seed)

		puzzle = puzzleMan.generatePuzzle( 2, puzzleMan.DIFF_HARD )
		puzzle.puzzleMan = puzzleMan
		var steps = puzzle.solvePuzzleSteps()
		print("Generated ", puzzle.shape.size(), " blocks." )
		print( "PUZZLE IS SOLVEABLE?: ", steps.solveable )

		var gridMan = get_node( "GridView/GridMan" )
		DataMan.savePuzzle("test.pzl", puzzle)
		var pCopy = DataMan.loadPuzzle("test.pzl")
		gridMan.set_puzzle(puzzle)



	# make a new puzzle, embed using Viewport
	if mainPuzzle:
		if (not Network == null and Network.isNetwork):
			print("Sending puzzle")
			Network.sendStart(initSeed)

		var p = PuzzleScn.instance()
		p.get_node("GridView").active = false
		#ip.get_node("GridView/GridMan").set_puzzle(puzzle)
		p.mainPuzzle = false
		p.set_scale(Vector3(0.5, 0.5, 0.5))
		p.set_translation(Vector3(10, 5, -20))

		var v = Viewport.new()
		var c = Control.new()

		v.set_world(p.get_world())
		v.set_render_target_to_screen_rect(Rect2(20,20,40,40))
		v.set_physics_object_picking(false)
		v.add_child(p)
		c.add_child(v)
		add_child(c)

		p.get_node("GridView").set_process_input(false)

		otherPuzzle = p #for use with network

	#music attempt
	var musicPlayer = Globals.get("StreamPlayer")
	var songs = [load("res://main_theme_antris.ogg")]
	add_child(StreamPlayer)
	add_child(musicPlayer)
	musicPlayer.set_stream(songs[0])
	musicPlayer.play()
