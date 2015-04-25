
extends Node

var Network

func _ready():
	Network = globals.get("Network")
	Network.proxy = self

func _process(delta):
	#simply delegate to the network's process
	Network._process(delta)


