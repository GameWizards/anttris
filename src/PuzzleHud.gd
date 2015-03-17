
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
	var mins = floor(time_elapsed / 60)
	var secs = fmod(floor(time_elapsed), 60)
	var millis = floor((time_elapsed - floor(time_elapsed)) * 1000)
	get_node("TimeLabel").set_text(str(mins) + ":" + str(secs).pad_zeros(2) + ":" + str(millis).pad_zeros(3))