extends Node

const blockColors = preload("PuzzleManager.gd").blockColors

const COLOR_RED		= 0
const COLOR_GREEN	= 1
const COLOR_BLUE	= 2
const COLOR_PURPLE	= 3
const COLOR_ORANGE	= 4
const COLOR_GRAY	= 5

var blockMats = {}

func _ready():
	print( "Creating materials." )

	# Add new arrays for each material and their glyphs.
	for r in range( blockColors.size() ):
		# Add the standard textures.
		var tex = ImageTexture.new()
		var img = Image()
		img.load( "res://textures/Block_" + blockColors[r] + ".png" )
		tex.create_from_image( img )
		blockMats[blockColors[r]] = FixedMaterial.new()
		blockMats[blockColors[r]].set_texture( FixedMaterial.PARAM_DIFFUSE, tex )

		# Add the three glyphs.
		for g in range( 3 ):
			var tex = ImageTexture.new()
			var img = Image()
			img.load( "res://textures/Block_" + blockColors[r] + str( g + 1 ) + ".png" )
			tex.create_from_image( img )
			blockMats[blockColors[r] + str( g + 1 )] = FixedMaterial.new()
			blockMats[blockColors[r] + str( g + 1 )].set_texture( FixedMaterial.PARAM_DIFFUSE, tex )

	for k in blockMats.keys():
		ResourceSaver.save( "res://glyph_materials/" + k + ".mtl", blockMats[k])

