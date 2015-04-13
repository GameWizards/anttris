extends "AbstractBlock.gd"

func activate(ev, click_pos, click_normal):
	var tweenNode = newTweenNode()
	var s = 0.1
	tweenNode.interpolate_method( self, "set_scale", \
		self.get_scale(), Vector3(s, s, s), \
		1, Tween.TRANS_BOUNCE, Tween.EASE_OUT )

	tweenNode.start()

func _ready():
	set_ray_pickable(true)
