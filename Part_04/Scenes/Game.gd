extends Node

var grid_size = Vector2( 16, 16 )
var map_size = Vector2( 50, 32 )

var dark_wall = Color( 0.0 / 255.0, 0.0 / 255.0, 100.0 / 255.0 )
var dark_ground = Color( 50.0 / 255.0, 50.0 / 255.0, 150.0 / 255.0 )
var light_wall = Color( 130.0 / 255.0, 110.0 / 255.0, 50.0 / 255.0 )
var light_ground = Color( 200.0 / 255.0, 180.0 / 255.0, 50.0 / 255.0 )

#var dark_wall = Color( 0.0 / 255.0, 0.0 / 255.0, 0.0 / 255.0, 128.0 / 255.0 )
#var dark_ground = Color( 0.0 / 255.0, 0.0 / 255.0, 0.0 / 255.0, 128.0 / 255.0 )
#var light_wall = Color( 0.0 / 255.0, 0.0 / 255.0, 0.0 / 255.0, 128.0 / 255.0 )
#var light_ground = Color( 0.0 / 255.0, 0.0 / 255.0, 0.0 / 255.0, 128.0 / 255.0 )