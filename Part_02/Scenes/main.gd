extends Node

var grid_size = Vector2( 16, 16 )
var map_size = Vector2( 50, 32 )
var entities = []

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var entityScene = preload( "res://Scenes/Entity.tscn" )
onready var gameMapScene = preload( "res://Scenes/GameMap.tscn" )

func _ready():
	#$Player.rect_position = Vector2( screen_width / 2 * grid_width, screen_height / 2 * grid_height )
	set_process_input( true )
	
	var game_map = gameMapScene.instance()
	game_map.name = "game_map"
	add_child( game_map )
	
	var player = entityScene.instance()
	player.name = "player"
	player.Init( map_size / 2, "主", Color( 1, 1, 1, 1 ) )
	add_child( player )
	
	var npc = entityScene.instance()
	npc.Init( ( map_size / 2 + Vector2( -5, 0 ) ), "兵", Color( 1, 1, 0, 1 ) )
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