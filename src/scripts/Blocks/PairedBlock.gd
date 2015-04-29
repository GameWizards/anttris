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
	print( self.textureName )
	#var mat = load("res://materials/block_" + textureName + ".mtl")
	print( Globals.get( "MaterialMaker" ) )
	self.get_node("MeshInstance").set_material_override( Globals.get( "MaterialMaker" ).blockMats[textureName] )
	return self

# Animate the removal of this block and its pair.
func popBlock( pairNode, justFly=false ):
	get_parent().samplePlayer.play("deraj_pop_sound_low")
	# fly away
	var tweenNode = newTweenNode()
	tweenNode.interpolate_method( self, "set_translation", \
		self.get_translation(), self.get_translation().normalized() * far_away_corner, \
		1, Tween.TRANS_CIRC, Tween.EASE_IN_OUT )

	# remove on animation end
	tweenNode.connect("tween_complete", self, "request_remove")
	tweenNode.start()
	# just one call to activate...
	if not justFly:
		pairNode.activate(true)
		get_parent().popPair( blockPos )

# THIS IS EVERYWHERE, ANY BETTER WAY TO HAVE FUNCTIONS BETWEEN SCRIPTS?
func calcBlockLayerVec( pos ):
	return max( max( abs( pos.x ), abs( pos.y ) ), abs( pos.z ) )

# fly away only if self.pairName is selected
func activate(justFly = false):
	var gridMan = get_parent()
	if gridMan.selectedBlocks.size() > 0:
		var selBlock = gridMan.get_node( gridMan.selectedBlocks[0] )

		if selBlock.getBlockType() == BLOCK_WILD:
			if selBlock.textureName == textureName.substr( 0, selBlock.textureName.length() ):
				if calcBlockLayerVec( selBlock.blockPos ) == calcBlockLayerVec( blockPos ):
					gridMan.clearSelection()
					selBlock.popBlock()
					forceActivate()

					return

	var pairNode = pairActivate()
	if pairNode == null:
		return
	if pairNode.selected:
		popBlock( pairNode, justFly )


# Force the pair to activate.
func forceActivate():
	var pairNode = pairActivate()
	if pairNode == null:
		return

	popBlock( pairNode )

