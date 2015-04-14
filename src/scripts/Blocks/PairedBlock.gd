extends "AbstractBlock.gd"

var pairName = null
var selected = false

func setTexture(textureName="Red"):
	var img = Image()
	var mat = FixedMaterial.new()
	var text = ImageTexture.new()
	
	img.load("res://textures/Block_" + textureName + ".png")
	text.create_from_image(img)
	mat.set_texture(FixedMaterial.PARAM_DIFFUSE, text)
	# TODO color the texture: mat.set_parameter(FixedMaterial.PARAM_DIFFUSE, Color(0.5, 0.5, 0))

	self.get_node("MeshInstance").set_material_override(mat)
	return self

func setPairName(other):
	pairName = other
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
		scaleTweenNode(0.6).start()

func _ready():
	set_ray_pickable(true)
