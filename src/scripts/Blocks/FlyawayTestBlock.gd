extends "AbstractBlock.gd"

func activate(ev, click_pos, click_normal):
	var tweenNode = newTweenNode()
	tweenNode.interpolate_method( self, "set_translation", \
		self.get_translation(), self.get_translation().normalized() * far_away_corner, \
		1, Tween.TRANS_CIRC, Tween.EASE_IN_OUT )

	tweenNode.start()

func _ready():
	set_ray_pickable(true)
