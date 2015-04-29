# Core networking

extends Node

const REMOTE_FINISH = 0
const REMOTE_START = 1
const REMOTE_QUIT = 2
const REMOTE_BLOCK = 4
const REMOTE_PUZZLE_TRANSFORM = 5
const REMOTE_BLOCK_UPDATE = 6

var port = 54321
var root
var isNetwork
var isHost
var isClient = false
var server
var client
var connection
var proxy

var thisPuzzle

#Store the peer stream used by both the lcient and server
var stream

func _ready():
	print( "Making network." )
	isNetwork = false
	isHost = false
	var label = get_tree().get_root().get_node("GUIManager/OptionsMenu/Panel/PortField/LineEdit")
	if not label == null:
		label.set_text(str(port))

func setPort(pt):
	port = pt;

func connectTo(ip, pt):
	isClient = true #just to tell if it's doing something :S
	connection = PacketPeerStream.new()
	stream = StreamPeerTCP.new()
	connection.set_stream_peer(stream)
	stream.connect(ip, pt);

	if stream.get_status() == stream.STATUS_CONNECTED or stream.get_status() == stream.STATUS_CONNECTING:
		print("Connecting to " + ip + ":" + str(port));
		proxy.set_process(true)
		#leave is_network as false to indicate we're still waiting for connection


func host(pt):
	server = TCP_Server.new()
	#connection = PacketPeerStream.new()
	isHost = true
	print("Starting listening server on port " + str(pt))
	if server.listen(pt) == 0:
		proxy.set_process(true)
		print("Listening...")
	else:
		print("Failed to start server on port " + str(pt));

func _process(delta):
	if (isHost):
		#server processing stuff
		#use isNetwork to determine if we're still listening
		if !isNetwork:
			if server.is_connection_available():
				stream = server.take_connection()
				connection = PacketPeerStream.new()
				connection.set_stream_peer(stream)
				print("Connecting with player...")
				isNetwork = true
				server.stop()

				gotoPuzzle()

				thisPuzzle = root.get_node("Puzzle")
				#MAKE CALL TO PUZZLE SELECTER
		else: #not listening anymore, have a client
			#do quick check to make sure we're still
			#connected
			if !stream.is_connected():
				print("Lost Connection!");
				isNetwork = false
				proxy.set_process(false)
				#QUIT GAME
				return
			#check if we have any data
			if connection.get_available_packet_count() > 0:
				#have to be careful about more than 1 packet per frame
				for i in range(connection.get_available_packet_count()):
					var dataArray = connection.get_var()
					ProcessServerData(dataArray)

	else:
		#client processing stuff
		if !isNetwork:
			#Still waiting for connection confirmed
			if stream.get_status() == stream.STATUS_CONNECTED:
				print("Connection established!")
				isNetwork = true

				gotoPuzzle()

				thisPuzzle = root.get_node("Puzzle")
				return
			if stream.get_status() == stream.STATUS_NONE or stream.get_status() == stream.STATUS_ERROR:
				print("Error establishing connection!")
				proxy.set_process(false)
				return
				#stop running process loop, cause we have no connection
		else:
			#connecton established and confirmed. Do regular data processing
			#check if we have any data
			if connection.get_available_packet_count() > 0:
				for i in range(connection.get_available_packet_count()):
					var dataArray = connection.get_var()
					ProcessServerData(dataArray)
					#Call the server process script cuase it's peer to peer and we have the same functions!


func disconnect():
	#need to do lots of things! If the server is open and listening, but has no connection just stop listening!
	if isHost and !isNetwork:
		#this means we're waiting for connection still
		server.stop()
		print("closing server listener!")
	elif isHost and isNetwork:
		#have connections. Need to send them stop packet, and close connection
		connection.put_var([REMOTE_QUIT])
		stream.disconnect()
		print("Closing connection to remote player...")
		gotoMenu()
	elif !isHost and !isNetwork:
		stream.disconnect()
		print("Halting connection request...")
	elif !isHost and isNetwork:
		#connected to server already
		stream.disconnect()
		print("Disconnecting from server...")
		gotoMenu()

	#no matter where we wre before disconnect, set network to false and return to beginning screen!
	isNetwork = false;
	isHost = false;
	isClient = false;

	proxy.set_process(false)



func ProcessServerData(dataArray):
	#have an array of data. First element should be identifying int
	var ID = dataArray[0]
	var puzzle = root.get_node( "Puzzle" )
	var gridMan = puzzle.otherPuzzle.get_node("GridView/GridMan")
	#no switch statement. I'm crying right now while i type this. My fingers are bleeding
	if ID == REMOTE_START:
		#read other person's puzzle
		print("remote_stuff")
		gridMan.set_puzzle(dataArray[1])
	elif ID == REMOTE_FINISH:
		#again, do ending stuff
		print("remote_finish: " + str(dataArray[1]))
		gridMan.beatenWithScore(dataArray[1])
	elif ID == REMOTE_QUIT:
		#omg those jerks!
		print("remote_quit")
		disconnect()
	elif ID == REMOTE_BLOCK:
		#get their block ifnormation!
		print("remote_block")
	elif ID == REMOTE_PUZZLE_TRANSFORM:
		#sent block information
		#var scale = dataArray[1]
		var translation = dataArray[1]
		thisPuzzle.otherPuzzle.set_transform(Transform( translation ))
# better measurements!!!!		thisPuzzle.otherPuzzle.set_translation(Vector3(20, 12, -40))
##############3
		thisPuzzle.otherPuzzle.set_translation(Vector3(10, 5, -20))
	elif ID == REMOTE_BLOCK_UPDATE:
		#sent an updated block pair
		print("block update")
		var pos = dataArray[1]
		gridMan.forceClickBlock(pos)

func sendStart(puzzle):
	if !isNetwork:
		print("Error sending start packet: not connected!")
		return
	var er = connection.put_var([REMOTE_START, puzzle])

func sendBlockUpdate(pos):
	if !isNetwork:
		print("Error sending start packet: not connected!")
		return
	connection.put_var([REMOTE_BLOCK_UPDATE, pos])

func sendFinish(score):
	if !isNetwork:
		print("Error sending finish packet: not connected!")
		return
	connection.put_var([REMOTE_FINISH, root.get_node("Puzzle").time.val])

func sendQuit():
	if !isNetwork:
		print("Error sending finish packet: not connected!")
		return
	connection.put_var([REMOTE_QUIT])

func sendTransform(translation):
	if !isNetwork:
		print("Cannot send transformation over an unitialized network!")
		return
	connection.put_var([REMOTE_BLOCK_TRANSFORM, translation])


func gotoMenu():
	root.get_child( root.get_child_count() - 1 ).queue_free()
	root.add_child( load("res://menus.scn") )

func gotoPuzzle():
	var guiMan = preload("GUIManager.gd").new()
	guiMan.gotoPuzzleScene(root, true) # network = true
