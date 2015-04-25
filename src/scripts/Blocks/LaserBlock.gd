extends "AbstractBlock.gd"

var mat
var laserExtent = Vector3()
#var fired = false

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

# Force a laser to set off at the end of a layer.
func forceActivate():
	scaleTweenNode(0, 0.5, Tween.TRANS_ELASTIC).start()

# Can't manually activate a laser.
func activate():
	return
