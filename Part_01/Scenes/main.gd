extends Node

var grid_width = 16
var	 grid_height = 16

var screen_width = 50
var	 screen_height = 32
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	$Player.rect_position = Vector2( screen_width / 2 * grid_width, screen_height / 2 * grid_height )
	set_process_input( true )
	
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			if event.scancode == KEY_LEFT:
				$Player.rect_position = Vector2( $Player.rect_position.x - grid_width, $Player.rect_position.y )
			elif event.scancode == KEY_RIGHT:
				$Player.rect_position = Vector2( $Player.rect_position.x + grid_width, $Player.rect_position.y )	
			elif event.scancode == KEY_UP:
				$Player.rect_position = Vector2( $Player.rect_position.x, $Player.rect_position.y - grid_height )
			elif event.scancode == KEY_DOWN:
				$Player.rect_position = Vector2( $Player.rect_position.x, $Player.rect_position.y + grid_height )					