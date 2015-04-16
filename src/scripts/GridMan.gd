extends Spatial

# used for paired selection
var selectedBlockName = null
var selectedLaserName = null

# used for score
var score = 0
var undoCount = 0

# used for undo
var blocksRemoved = []

var samplePlayer = SamplePlayer.new()


func _ready():
	# Initalization here
	samplePlayer.set_sample_library(ResourceLoader.load("new_samplelibrary.xml"))

	


