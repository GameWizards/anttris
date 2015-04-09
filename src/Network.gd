
extends Node

var is_network
var is_host

func _ready():
	is_network = false
	is_host = false

func set_host(isHost):
	is_host = isHost

