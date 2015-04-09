extends Button

var IPPanel = get_node("IPAddress");

func _ready():
	connect("pressed", self, "pressed")

function pressed():
	var ip = IPPanel.get_text();
	
	if (ip.empty()):
		return
	
	


