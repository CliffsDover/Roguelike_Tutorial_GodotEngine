extends Node


var entities = []

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var entityScene = preload( "res://Scenes/Entity.tscn" )
onready var gameMapScene = preload( "res://Scenes/GameMap.tscn" )

func _ready():
	randomize()
	#$Player.rect_position = Vector2( screen_width / 2 * grid_width, screen_height / 2 * grid_height )
	set_process_input( true )
	
	var game_map = gameMapScene.instance()
	game_map.name = "game_map"
	add_child( game_map )
	
	var player = entityScene.instance()
	player.name = "player"
	player.Init( Game.map_size / 2, "主", Color( 1, 1, 1, 1 ) )
	#player.Init( Vector2( 3, 3 ), "主", Color( 1, 1, 1, 1 ) )
	add_child( player )
	
	var npc = entityScene.instance()
	npc.Init( ( Game.map_size / 2 + Vector2( -5, 0 ) ), "兵", Color( 1, 1, 0, 1 ) )
	add_child( npc )
	
	entities= [ player, npc ]
	
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			var delta = Vector2( 0, 0 )
			if event.scancode == KEY_LEFT:
				delta = Vector2( -1, 0 )
			elif event.scancode == KEY_RIGHT:
				delta = Vector2( 1, 0 )
			elif event.scancode == KEY_UP:
				delta = Vector2( 0, -1 )
			elif event.scancode == KEY_DOWN:
				delta = Vector2( 0, 1 )
			if not $game_map.Is_Blocked( $player.position + delta ):
				$player.Move( delta )
	elif event is InputEventMouseMotion:
		#print("Mouse Motion at: ", event.position / Game.grid_size )			
		$HUD/MousePosLabel.text = "(" + str( int( event.position.x / Game.grid_size.x ) ) + "," + str( int( event.position.y / Game.grid_size.y ) ) + ")"

func _on_FPSTimer_timeout():
	$HUD/FPSLabel.text = "FPS:" + str( int( Engine.get_frames_per_second() ) )
