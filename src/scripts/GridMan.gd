extends Spatial

var shape

# used for score
var score = 0
var undoCount = 0

# used for undo
var blocksRemoved = []

var samplePlayer = SamplePlayer.new()

func add_block(b):
	add_child(b)

func get_block(pos):
	if shape.has(pos):
		return shape[pos]
	else:
		return null

func set_puzzle(puzzle):
	puzzle = puzzle
	# Initalization here
	samplePlayer.set_voice_count(puzzle.puzzleLayers * 2)
	samplePlayer.set_sample_library(ResourceLoader.load("new_samplelibrary.xml"))



