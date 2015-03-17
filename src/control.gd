extends Node

var current_scene = null

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child( root.get_child_count() - 1)
	
		
func goto_scene(scene):
	current_scene.queue_free()
	
	var s = ResourceLoader.load(scene)
	current_scene = s.instance()
	get_tree().get_root().add_child(current_scene)