
extends Node

var Network

func _ready():
	Network = Globals.get("Network")
	Network.proxy = self
	set_process(Network.is_processing())

func _process(delta):
	#simply delegate to the network's process
	Network._process(delta)


