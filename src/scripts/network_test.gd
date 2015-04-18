
extends Control

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	get_node("Start").connect("pressed", self, "start_button")
	get_node("Quit").connect("pressed", self, "quit_button")
	get_node("Finish").connect("pressed", self, "finish_button")
	get_node("Score").connect("pressed", self, "score_button")
	get_node("Block").connect("pressed", self, "block_button")

func start_button():
	print("start")

func quit_button():
	print("quit")

func finish_button():
	print("finish")

func score_button() :
	print("score")

func block_button():
	print("block")