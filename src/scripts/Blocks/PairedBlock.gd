extends "AbstractBlock.gd"

var pairName = null
var selected = false

func setTexture(textureName):
	var img = Image()
	var mat = FixedMaterial.new()
	var text = ImageTexture.new()
	
	img.load("res://textures/Block_" + textureName + ".png")
	text.create_from_image(img)
	mat.set_texture(FixedMaterial.PARAM_DIFFUSE, text)

	self.get_node("MeshInstance").set_material_override(mat)
	return self

func setPairName(other):
	pairName = other
	print(other)
	return self

# fly away only if self.pairName is selected
func activate(ev, click_pos, click_normal, justFly=false):
	selected = true
	var pairNode = get_node("../" + pairName)
	if pairNode.selected:
		var tweenNode = newTweenNode()
		tweenNode.interpolate_method( self, "set_translation", \
			self.get_translation(), self.get_translation().normalized() * far_away_corner, \
			1, Tween.TRANS_CIRC, Tween.EASE_IN_OUT )

		tweenNode.start()
		if not justFly:
			pairNode.activate(ev, click_pos, click_normal, true)
	else:
		var shrinktweenNode = newTweenNode()
		var s = 0.5
		shrinktweenNode.interpolate_method( self, "set_scale", \
			self.get_scale(), Vector3(s, s, s), \
			1, Tween.TRANS_BOUNCE, Tween.EASE_OUT )
		shrinktweenNode.start()

func _ready():
	set_ray_pickable(true)
