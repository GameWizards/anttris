
extends EmptyControl

# member variables here, example:
# var a=2
# var b="textvar"
var time_elapsed

func _ready():
	# Initalization here
	time_elapsed = 0
	
	set_process(true)
	pass

func get_time_elpased():
	return time_elapsed

func _process(delta):
	time_elapsed += delta
	get_node("TimeLabel").set_text(str(time_elapsed))