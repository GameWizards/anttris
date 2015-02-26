
extends Spatial

# Cache the block scene
var block_scn = preload("res://block.scn")

# Unique names are needed for every node added to the
# tree.
var unique_id = 0

# Called for initialization
func _ready():
	var n = 5
	var block_size = 1
	var offset = Vector3(0, (n + 1) * block_size, 0)
	var min_ = float(-n * block_size / 2)
	var max_ = float(n * block_size / 2)
	var _range = range(min_, max_, block_size);
	
	for x in _range:
		for y in _range:
			for z in _range:
				# Create a block, name it and add it to the tree
				var block = block_scn.instance()
				var block_name = "block" + str(unique_id)
				block.set_name(block_name)
				add_child(block)
				
				# Prepare for next block
				unique_id += 1
				
				# Configure block
				var pos = Vector3(x * 2.1, y * 2.1, z * 2.1)
				var node = get_node(block_name)
				var mesh = get_node(block_name + "/MeshInstance")
				var mat = FixedMaterial.new()
				pos += offset
				node.set_translation(pos)
				mat.set_parameter(FixedMaterial.PARAM_DIFFUSE, Color( \
					(x - min_) / (max_ - min_), \
					(y - min_) / (max_ - min_), \
					(z - min_) / (max_ - min_)  ))
				mesh.set_material_override(mat)


