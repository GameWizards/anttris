
extends Node

var Network

func _ready():
	Network = Globals.get("Network")
	Network.proxy = self
	print("set proxy!")

func _process(delta):
	#simply delegate to the network's process
	Network._process(delta)


