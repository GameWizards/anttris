extends "AbstractBlock.gd"

var mat
var laserExtent = Vector3()
var fired = false

#const beamScn = preload( "res://blocks/block.scn" )
#const Beam = preload("res://scripts/Blocks/Beam.gd")
#const laserBlockImg = Image() # TODO preload this somewhere else

# color
func setTexture(color=Color(0.5, 0, 0)):
	var mat = load("res://materials/block_Laser.mtl")
	mat.set_parameter(FixedMaterial.PARAM_EMISSION, color)
	self.get_node("MeshInstance").set_material_override(mat)

	return self

# sets light emission color
func setColor(col):
	mat.set_parameter(FixedMaterial.PARAM_EMISSION, col)

func setExtent(laserExtent):
	 self.laserExtent = laserExtent

# create a beam and activate it
func activate():
	#var pairNode = pairActivate()
	#if pairNode == null or pairNode.selected == false:
	#	return
	# shrink to 80% size, 0.5 sec
	scaleTweenNode(0, 0.5, Tween.TRANS_ELASTIC).start()

	#var tweenNode = newTweenNode()
	# fade emission color
	#tweenNode.interpolate_method( self, "setColor", \
	#	self.mat.get_parameter(FixedMaterial.PARAM_EMISSION), Color(0.1, 0.1, 0.1), \
	#	0.5, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT )
	#tweenNode.interpolate_method( self, "set_translation", \
	#	self.get_translation(), self.get_translation().normalized() * far_away_corner, \
	#	1, Tween.TRANS_CIRC, Tween.EASE_IN_OUT )
	#tweenNode.start()

	if fired:
		return

	fired = true
