
extends Node

const REMOTE_FINISH = 0
const REMOTE_START = 1
const REMOTE_QUIT = 2
const REMOTE_SCORE = 3
const REMOTE_BLOCK = 4
const REMOTE_MSG = 5

var port = 54321

var is_network
var is_host
var is_client
var server
var client
var connection
#Store the peer stream used by both the lcient and server
var stream

func _ready():
	is_network = false
	is_host = false
	get_tree().get_root().get_node("GUIManager/OptionsMenu/Panel/PortField/LineEdit").set_text(str(port))

func set_host(isHost):
	is_host = isHost

func set_port(pt):
	port = pt;

func connect_to(ip, pt):
	is_client = true #just to tell if it's doing something :S
	connection = PacketPeerStream.new()
	stream = StreamPeerTCP.new()
	connection.set_stream_peer(stream)
	stream.connect(ip, pt);
	
	if stream.get_status() == stream.STATUS_CONNECTED or stream.get_status() == stream.STATUS_CONNECTING:
		print("Connecting to " + ip + ":" + str(port));
		set_process(true)
		#leave is_network as false to indicate we're still waiting for connection
	
	
func host(pt):
	server = TCP_Server.new()
	connection = PacketPeerStream.new()
	is_host = true
	print("Starting listening server on port " + str(pt))
	if server.listen(pt) == 0:
		set_process(true)
		print("Listening...")
	else:
		print("Failed to start server on port " + str(pt));
	
func _process(delta):
	if (is_host):
		#server processing stuff
		#use isNetwork to determine if we're still listening
		if !is_network:
			if server.is_connection_available():
				stream = server.take_connection()
				connection = PacketPeerStream.new()
				connection.set_stream_peer(stream)
				print("Connecting with player...")
				is_network = true
				server.stop()
				change_scene("res://network_test.scn")
				#MAKE CALL TO PUZZLE SELECTER
		else: #not listening anymore, have a client
			#do quick check to make sure we're still
			#connected
			if !stream.is_connected():
				print("Lost Connection!");
				is_network = false
				set_process(false)
				#QUIT GAME
				return
			#check if we have any data
			if connection.get_available_packet_count() > 0:
				#have to be careful about more than 1 packet per frame
				for i in range(connection.get_available_packet_count()):
					var data_array = connection.get_var()
					process_server_data(data_array)
					
	else:
		#client processing stuff
		if !is_network:
			#Still waiting for connection confirmed
			if stream.get_status() == stream.STATUS_CONNECTED:
				print("Connection established!")
				is_network = true
				change_scene("res://network_test.scn")
				return
			if stream.get_status() == stream.STATUS_NONE or stream.get_status() == stream.STATUS_ERROR:
				print("Error establishing connection!")
				set_process(false)
				return
				#stop running process loop, cause we have no connection
		else:
			#connecton established and confirmed. Do regular data processing
			#check if we have any data
			if connection.get_available_packet_count() > 0:
				for i in range(connection.get_available_packet_count()):
					var data_array = connection.get_var()
					process_server_data(data_array)
					#Call the server process script cuase it's peer to peer and we have the same functions!


func disconnect():
	#need to do lots of things! If the server is open and listening, but has no connection just stop listening!
	if is_host and !is_network:
		#this means we're waiting for connection still
		server.stop()
		print("closing server listener!")
	elif is_host and is_network:
		#have connections. Need to send them stop packet, and close connection
		connection.put_var([REMOTE_QUIT])
		stream.disconnect()
		print("Closing connection to remote player...")



func process_server_data(data_array):
	#have an array of data. First element should be identifying int
	var ID = data_array[0]
	print(ID)
	#no swithc statement. I'm crying right now while i type this. My fingers are bleeding
	if ID == REMOTE_START:
		#do start something or something whut
		print("remote_stuff")
	elif ID == REMOTE_FINISH:
		#again, do ending stuff
		print("remote_finish: " + str(data_array[1]))
	elif ID == REMOTE_QUIT:
		#omg those jerks!
		print("remote_quit")
	elif ID == REMOTE_SCORE:
		#what was their score?
		print("remote_score")
	elif ID == REMOTE_BLOCK:
		#get their block ifnormation!
		print("remote_block")
	elif ID == REMOTE_MSG:
		#sent some sort of message?
		print("remote_msg")

func send_start():
	if !is_network:
		print("Error sending start packet: not connected!")
		return
	var er = connection.put_var([REMOTE_START])
	print("Sending start and got [" + str(er) + "]")

func send_finish(score):
	if !is_network:
		print("Error sending finish packet: not connected!")
		return
	connection.put_var([REMOTE_FINISH, score])



func change_scene(scene):
	var root = get_tree().get_root()
	root.get_child( root.get_child_count() - 1 ).queue_free()
	root.add_child( ResourceLoader.load( scene ).instance() )