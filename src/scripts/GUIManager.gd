extends Node

var menuOn
var timer
var splashTween

var initialWait = .5
var splashTimer = 2.0
var warningTimer = 5.0

var Splash_Team5
var Splash_Warning
var Menu_Main
var Menu_Chooser
var Menu_MP
var Menu_HostGame
var Menu_JoinGame
var Menu_Options

var MENU_INIT			= 0
var MENU_SPLASHTEAM5	= 1
var MENU_SPLASHWARNING	= 2
var MENU_MAIN			= 3
var MENU_CHOOSER		= 4
var MENU_MP				= 5
var MENU_HOSTGAME		= 6
var MENU_JOINGAME		= 7
var MENU_OPTIONS		= 8

func _ready():
	# Initial setup.
	menuOn = MENU_INIT
	timer = 0.0
	set_process( true )
	set_process_input( true )
	
	# Setup the splash fader tween.
	splashTween = Tween.new()
	get_node( "SplashFader" ).add_child( splashTween )
	splashTween.interpolate_method( get_node( "SplashFader" ), "set_opacity", 1.0, 0.0, 1.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT )
	
	# Gather all of the menus.
	Splash_Team5 = get_node( "SplashTeam5" )
	Splash_Warning = get_node( "SplashWarning" )
	Menu_Main = get_node( "MainMenu" )
	Menu_Chooser = get_node( "ChooserMenu" )
	Menu_MP = get_node( "Multiplayer" )
	Menu_HostGame = get_node( "HostGame" )
	Menu_JoinGame = get_node( "JoinGame" )
	Menu_Options = get_node( "OptionsMenu" )

func _process( delta ):
	# Handle the initial wait.
	if( menuOn == MENU_INIT ):
		if( timer > initialWait ):
			menuOn = MENU_SPLASHTEAM5
			timer = 0.0
			Splash_Team5.guiIn()
			
	# Handle the Team5 splash screen.
	if( menuOn == MENU_SPLASHTEAM5 ):
		if( timer > splashTimer ):
			menuOn = MENU_SPLASHWARNING
			timer = 0.0
			Splash_Team5.guiOut()
			Splash_Warning.guiIn()
			
	# Handle the warning splash screen.
	if( menuOn == MENU_SPLASHWARNING ):
		if( timer > warningTimer ):
			menuOn = MENU_MAIN
			timer = 0.0
			Splash_Warning.guiOut()
			Menu_Main.guiIn()
			splashTween.start()
			
	# Increase the timer each frame.
	timer += delta

func _input( ev ):
	# Handle exit.
	if( ev.is_action( "ui_cancel" ) ):
		exit()

func exit():
	print( "Exiting" )
	OS.get_main_loop().quit()

func _on_Exit_pressed():
	exit()

func _on_Options_pressed():
	Menu_Main.guiOut()
	Menu_Options.guiIn()
	timer = 0.0
	menuOn = MENU_OPTIONS

func _on_Cancel_pressed():
	Menu_Options.guiOut()
	Menu_Main.guiIn()
	timer = 0.0
	menuOn = MENU_MAIN

func _on_SaveQuit_pressed():
	# Add save options here.
	_on_Cancel_pressed()

func _on_SP_pressed():
	Menu_Main.guiOut()
	Menu_Chooser.guiIn()
	timer = 0.0
	menuOn = MENU_CHOOSER

func _on_MainMenu_pressed():
	Menu_Chooser.guiOut()
	Menu_Main.guiIn()
	timer = 0.0
	menuOn = MENU_MAIN

func _on_MainMenuMP_pressed():
	Menu_MP.guiOut()
	Menu_Main.guiIn()
	timer = 0.0
	menuOn = MENU_MAIN

func _on_MP_pressed():
	Menu_Main.guiOut()
	Menu_MP.guiIn()
	timer = 0.0
	menuOn = MENU_MP

func _on_MainMenuHG_pressed():
	Menu_HostGame.guiOut()
	Menu_Main.guiIn()
	timer = 0.0
	menuOn = MENU_MAIN
	get_node("/root/Network").disconnect()

func _on_HostGame_pressed():
	Menu_MP.guiOut()
	Menu_HostGame.guiIn()
	timer = 0.0
	menuOn = MENU_HOSTGAME

func _on_JoinGame_pressed():
	Menu_MP.guiOut()
	Menu_JoinGame.guiIn()
	timer = 0.0
	menuOn = MENU_JOINGAME

func _on_MainMenuJG_pressed():
	Menu_JoinGame.guiOut()
	Menu_Main.guiIn()
	timer = 0.0
	menuOn = MENU_MAIN


func _on_RandomPuzzle_pressed():
	var root = get_tree().get_root()
	root.get_child( root.get_child_count() - 1 ).queue_free()
	root.add_child( ResourceLoader.load( "res://puzzle.scn" ).instance() )
