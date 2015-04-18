extends Button

var IPPanel


func _ready():
	connect("pressed", self, "pressed")

function pressed():
	IPPanel = get_tree().get_root().get_node("GUIManager/JoinGame/Panel/IPAddress")
	var ip = IPPanel.get_text();
	
	if (ip.empty()):
		return
	
	var network = get_node("/root/Network")
	if !network.is_client:
		network.connect_to(ip, network.port)


