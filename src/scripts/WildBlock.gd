extends "AbstractBlock.gd"

var textureName

func setTexture(textureName="WildRed"):
	var img = Image()
	self.textureName = textureName
	#var text = ImageTexture.new()

	# TODO preload
	var mat = load("res://materials/block_" + textureName + ".mtl")
	#img.load("res://textures/Block_" + textureName + ".png")

	#text.create_from_image(img)
	#mat.set_texture(FixedMaterial.PARAM_DIFFUSE, text)
	# TODO color the texture: mat.set_parameter(FixedMaterial.PARAM_DIFFUSE, Color(0.5, 0.5, 0))

	self.get_node("MeshInstance").set_material_override(mat)
	return self

# fly away only if self.pairName is selected
func activate(ev, click_pos, click_normal, justFly=false):
	var pairNode = pairActivate(ev, click_pos, click_normal)
	if pairNode == null:
		return
	if pairNode.selected:
		get_parent().samplePlayer.play("deraj_pop_sound_wild")
		# fly away
		var tweenNode = newTweenNode()
		tweenNode.interpolate_method( self, "set_translation", \
			self.get_translation(), self.get_translation().normalized() * far_away_corner, \
			1, Tween.TRANS_CIRC, Tween.EASE_IN_OUT )

		tweenNode.start()
		# just one call to activate...
		if not justFly:
			pairNode.activate(ev, click_pos, click_normal, true)
