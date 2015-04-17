
extends Node

const REMOTE_FINISH = 0
const REMOTE_START = 1
const REMOTE_QUIT = 2
const REMOTE_SCORE = 3
const REMOTE_BLOCK = 4
const REMOTE_MSG = 5

var is_network
var is_host
var server
var client
var connections
#Store the peer stream used by both the lcient and server
var stream

func _ready():
	is_network = false
	is_host = false

func set_host(isHost):
	is_host = isHost

func connnect(ip. port):
	stream = StreamPeerTCP.new()
	stream.connect(ip, port);
	
	if stream.get_status() == stream.STATUS_CONNECTED or stream.get_status() == stream.STATUS_CONNECTING:
		print("Connecting to " + ip + ":" + str(port));
		set_process(true)
		#leave is_network as false to indicate we're still waiting for connection
	
	
func host(port):
	server = TCP_Server.new()
	is_host = true
	if server.listen(port) == 0:
		set_process(true)
	else:
		print("Failed to start server on port " + str(port));
	
func _process(delta):
	if (is_host):
		#server processing stuff
		
	#use isNetwork to determine if we're still listening
		if is_network:
			if server.is_connection_available():
				client = server.take_connection()
				stream = PacketPeerStream.new()
				stream.set_stream_peer(client)
				print("Connecting with player...")
		else: #not listening anymore, have a client
			#do quick check to make sure we're still
			#connected
			if !client.is_connected():
				print("Lost Connection!");
				return
			
			#check if we have any data
			if stream.get_available_packet_count():
				#have to be careful about more than 1 packet per frame
				for i in range(stream.get_available_packet_count()):
					var data_array = stream.get_var()
					process_server_data(data_array)
					
	else:
		#client processing stuff
		if !is_network:
			#Still waiting for connection confirmed
			if stream.get_status() == stream.STATUS_CONNECTED:
				print("Connection established!")
				is_network = true
				return
			if stream.get_status() == stream.STATUS_NONE or connection.get_status() == stream.STATUS_ERROR:
				print("Error establishing connection!")
				set_process(false)
				#stop running process loop, cause we have no connection
			
		else:
			#connecton established and confirmed. Do regular data processing
			







func process_server_data(data_array):
	#have an array of data. First element should be identifying int
	var ID = data_array[0]
	
	#no swithc statement. I'm crying right now while i type this. My fingers are bleeding
	if ID == REMOTE_START:
		#do start something or something whut
	elif ID == REMOTE_FINISH:
		#again, do ending stuff
	elif ID == REMOTE_QUIT:
		#omg those jerks!
	elif ID == REMOTE_SCORE:
		#what was their score?
	elif ID == REMOTE_BLOCK:
		#get their block ifnormation!
	elif ID == REMOTE_MSG:
		#sent some sort of message?
