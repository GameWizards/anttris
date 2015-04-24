extends "AbstractBlock.gd"

# Is there a better way to do this?
const BLOCK_LASER	= 0
const BLOCK_WILD	= 1
const BLOCK_PAIR	= 2
const BLOCK_GOAL	= 3
const BLOCK_BLOCK   = 4

var textureName

func setTexture(textureName="Red"):
	var img = Image()
	self.textureName = textureName

	# TODO preload
	var mat = load("res://materials/block_Wild" + textureName + ".mtl")

	self.get_node("MeshInstance").set_material_override(mat)
	return self

# Sets off the blocks removal animation.
func popBlock():
	get_parent().samplePlayer.play("deraj_pop_sound_wild")
	# fly away
	var tweenNode = newTweenNode()
	tweenNode.interpolate_method( self, "set_translation", \
		self.get_translation(), self.get_translation().normalized() * far_away_corner, \
		1, Tween.TRANS_CIRC, Tween.EASE_IN_OUT )

	tweenNode.start()

# Activates this wild block.
func activate(justFly=false):
	var gridView = get_parent()

	if gridView.selectedBlocks.size() > 0:
		var selBlock = gridView.get_node( "GridMan" ).get_node( gridView.selectedBlocks[0] )
		
		if selBlock.getBlockType() == BLOCK_PAIR:
			if selBlock.textureName == textureName:
				gridView.clearSelection()
				popBlock()
				selBlock.forceActivate()
				return

