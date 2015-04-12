
extends Spatial

# Cache the block scene
var blocks = []


# Unique names are needed for every node added to the
# tree.
var unique_id = 0

# Called for initialization
func _ready():
	# Load the blocks.
	blocks.append( preload("res://blocks/block_red.scn") )
	blocks.append( preload("res://blocks/block_green.scn") )
	blocks.append( preload("res://blocks/block_blue.scn") )
	blocks.append( preload("res://blocks/block_yellow.scn") )
	blocks.append( preload("res://blocks/block_orange.scn") )
	blocks.append( preload("res://blocks/block_purple.scn") )

	var n = 5
	var block_size = 1
	var offset = Vector3(0, (n * block_size)/2.0, 0)
	var min_ = float(-n * block_size / 2)
	var max_ = float(n * block_size / 2)
	var _range = range(min_, max_ + 1, block_size);
	
	for x in _range:
		for y in _range:
			for z in _range:
				# Create a block, name it and add it to the tree
				var block = blocks[randi() % 6].instance()
				var block_name = "block" + str(unique_id)
				block.set_name(block_name)
				get_node("GridView/GridMan").add_child(block)
				
				# Prepare for next block
				unique_id += 1
				
				# Configure block
				# Godot uses the forward slashes (/) on all platforms
				var pos = Vector3(x * 2, y * 2, z * 2)
				var node = get_node("GridView/GridMan/" + block_name)
				var mesh = node.get_node("MeshInstance")
				#var mat = FixedMaterial.new()
				# pos += offset
				node.set_translation(pos)
				#mat.set_parameter(FixedMaterial.PARAM_DIFFUSE, Color( \
				#	(x - min_) / (max_ - min_), \
				#	(y - min_) / (max_ - min_), \
				#	(z - min_) / (max_ - min_)  ))
				#mesh.set_material_override(mat)


