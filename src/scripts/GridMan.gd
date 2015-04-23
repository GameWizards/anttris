extends Spatial

# block positions
var shape = {}

# sounds
var samplePlayer = SamplePlayer.new()

func add_block(b):
	shape[b.blockPos] = b
	add_child(b)

func get_block(pos):
	if shape.has(pos):
		return shape[pos]
	else:
		return null

func remove_block(block_node):
	if shape[block_node.blockPos] == null:
		return
	shape[block_node.blockPos] = null
	remove_and_delete_child(block_node)
	# TODO scan_layer, fire lasers if empty

# TODO wild block selected? can click any pair. can deselect wild block.
var wildBlockSelected = null

func set_puzzle(puzzle):
	puzzle = puzzle
	# Initalization here
	samplePlayer.set_voice_count(puzzle.puzzleLayers * 2)
	samplePlayer.set_sample_library(ResourceLoader.load("new_samplelibrary.xml"))



