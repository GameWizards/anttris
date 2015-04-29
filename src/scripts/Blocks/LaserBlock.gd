extends "AbstractBlock.gd"

var mat
var laserExtent = Vector3()

# color
func setTexture(color=Color(0.5, 0, 0)):
	var mat = load("res://materials/block_Laser.mtl")
	mat.set_parameter(FixedMaterial.PARAM_EMISSION, Color(0.2, 0.1, 0.1))
	self.get_node("MeshInstance").set_material_override(mat)

	return self

# sets light emission color
func setColor(col):
	mat.set_parameter(FixedMaterial.PARAM_EMISSION, col)
	return self

func setExtent(laserExtent):
	self.laserExtent = laserExtent
	return self

# Force a laser to set off at the end of a layer.
func forceActivate():
	scaleTweenNode(0, 0.5, Tween.TRANS_ELASTIC).start()

# Can't manually activate a laser.
func activate():
	return
