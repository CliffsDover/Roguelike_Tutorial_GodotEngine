extends Node

onready var Tile = preload( "res://Scenes/Tile.tscn" )
var width
var height
var tiles = []
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	Init( 50, 32 )
	InitializeTiles()
	
func _updateDisplayProperties():
	for x in range( width ):
		for y in range( height ):
			var wall = tiles[x][y].block_sight		
			if wall:
				tiles[x][y].color = Color( 0, 0, 0.5, 1 )
			else:	
				tiles[x][y].color = Color( 0.2, 0.2, 0.75, 1 )
				
func Init( _width, _height ):
	width = _width
	height = _height
	
func InitializeTiles():
	tiles = []
	for x in range( width ):
		tiles.append( [] )
		for y in range( height ):
			tiles[x].append( [] )		
			var tile = Tile.instance()
			tile.rect_position = Vector2( Vector2( x, y ) * Vector2( 16, 16 ) )
			tiles[x][y] = tile
			add_child( tile )
			
	tiles[15][11].blocked = true
	tiles[15][11].block_sight = true
	tiles[16][11].blocked = true
	tiles[16][11].block_sight = true
	tiles[17][11].blocked = true
	tiles[17][11].block_sight = true
		
	_updateDisplayProperties()
	#for x in range( width ):
	#	for y in range( height ):
	#		print( tiles[x][y].rect_position )	

func Is_Blocked( pos ):
	if tiles[ pos.x ][ pos.y ].blocked:
		return true
	else:
		return false
