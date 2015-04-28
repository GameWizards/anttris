extends "AbstractBlock.gd"

func activate(ev, click_pos, click_normal):
	scaleTweenNode(0.1).start()

func _ready():
	set_ray_pickable(true)
