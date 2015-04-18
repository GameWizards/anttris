extends Spatial

# proposed script manager:
# var PuzzleManScript = get_node("Globals").get("PuzzleManScript")

var PuzzleManScript = preload( "res://scripts/PuzzleManager.gd" )
var PuzzleScn = preload("res://puzzle.scn")
var puzzleMan
var mainPuzzle = true

var time = {
		val = 0.0,
		label = null,
		tween = null }

func addTimer():
	time.label = Label.new()
	time.tween = Tween.new()
	add_child(time.label)
	add_child(time.tween)
	time.label.set_pos(Vector2(15,15))

	time.label.set_theme(load("res://themes/MainTheme.thm"))
	time.tween.interpolate_method(time.label, "set_pos", \
			time.label.get_pos(), time.label.get_pos()*2, 0.5, \
			Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	time.tween.start()
	time.label.set_text(str(time.val))

func _process(dTime):
	# start label tween on
	time.val += dTime
	time.label.set_text(str(time.val))
	if fmod(time.val, 3) < 0.1:
		time.tween.seek(0.0)

# Called for initialization
func _ready():
	set_process(true) # needed for time keeping
	puzzleMan = PuzzleManScript.new()
	var puzzle = puzzleMan.generatePuzzle( 2, puzzleMan.DIFF_EASY )

	print("Generated ", puzzle.blocks.size(), " blocks." )

	addTimer()

	# Place the blocks in the puzzle.
	var gridMan = get_node( "GridView/GridMan" )
	gridMan.shape = puzzleMan.shape
	gridMan.set_puzzle(puzzle)
	for block in puzzle.blocks:
		# Create a block node, add it to the tree
		var b = block.toNode()
		gridMan.add_block(b)
		gridMan.get_child(block.name) \
			.set_translation(block.blockPos * 2 )

	# make a new puzzle, embed using Viewport
	if mainPuzzle:
		var p = PuzzleScn.instance()
		p.mainPuzzle = false
		p.set_scale(Vector3(0.5, 0.5, 0.5))
		p.set_translation(Vector3(20, 0, 0))

		var v = Viewport.new()
		# ?
		v.set_as_render_target(true)

		v.set_world(p.get_world())
		v.set_rect(Rect2(0, 0, 100, 100))
		v.set_physics_object_picking(false)
		v.add_child(p)
		add_child(v)
# child of control? easier input


