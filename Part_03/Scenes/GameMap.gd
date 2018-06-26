extends Node


onready var Tile = preload( "res://Scenes/Tile.tscn" )
onready var Rect = preload( "res://Scenes/Rect.tscn" )

var width
var height
var tiles = []
var rooms = []
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	Init( Game.map_size )
	InitializeTiles()
	
func _updateDisplayProperties():
	for x in range( width ):
		for y in range( height ):
			var wall = tiles[x][y].block_sight		
			if wall:
				tiles[x][y].color = Color( 0, 0, 0.5, 1 )
			else:	
				tiles[x][y].color = Color( 0.2, 0.2, 0.75, 1 )
				
func Init( mapSize ):
	width = mapSize.x
	height = mapSize.y
	
func InitializeTiles():
	tiles = []
	for x in range( width ):
		tiles.append( [] )
		for y in range( height ):
			tiles[x].append( [] )		
			var tile = Tile.instance()
			tile.blocked = true
			tile.block_sight = true
			tile.rect_position = Vector2( Vector2( x, y ) * Game.grid_size )
			tiles[x][y] = tile
			add_child( tile )
			
	Make_Map()
	Make_Tunnels()
		
	_updateDisplayProperties()
	#for x in range( width ):
	#	for y in range( height ):
	#		print( tiles[x][y].rect_position )	

func Is_Blocked( pos ):
	if tiles[ pos.x ][ pos.y ].blocked:
		return true
	else:
		return false



func Create_Room( room ):
	#print( "[GameMap:Create_Room]" )
	for x in range( room.pos.x + 1, room.pos.x + room.size.x - 1 ):
		for y in range( room.pos.y + 1, room.pos.y + room.size.y - 1 ):
			tiles[x][y].blocked = false
			tiles[x][y].block_sight = false
			
func Create_H_Tunnel( x1, x2, y ):
	for x in range( min( x1, x2 ), max( x1, x2 ) + 1 ):
		tiles[x][y].blocked = false
		tiles[x][y].block_sight = false
		
func Create_V_Tunnel( y1, y2, x ):
	for y in range( min( y1, y2 ), max( y1, y2 ) + 1 ):
		tiles[x][y].blocked = false
		tiles[x][y].block_sight = false	

func Make_Map():
	#var room1 = Rect.instance()
	#room1.Init( Vector2( 12, 12 ), Vector2( 10, 15 ) )
	#Create_Room( room1 )
	#var room2 = Rect.instance()	
	#room2.Init( Vector2( 22, 12 ), Vector2( 10, 15 ) )
	#Create_Room( room2 )	
	
	#Create_H_Tunnel( 21, 22, 20 )
	
	var room_max_size = 10
	var room_min_size = 6
	var max_rooms = 30
	
	var num_rooms = 0
	#print( range(max_rooms) )
	for r in range( max_rooms ):
		var x = randi() % ( int( Game.map_size.x ) - 2 )
		var y = randi() % ( int( Game.map_size.y ) - 2 )		
		var w = int( min( rand_range( room_min_size, room_max_size ), Game.map_size.x - x ) )
		var h = int( min( rand_range( room_min_size, room_max_size ), Game.map_size.y - y ) )
		var new_room = Rect.instance()	
		new_room.Init( Vector2( x, y ), Vector2( w, h ) )
		#print( new_room )
		if rooms.size() == 0:
			Create_Room( new_room )			
			rooms.append( new_room )
			num_rooms = num_rooms + 1
		else:
			var isIntersected = false
			for other_room in rooms:
				#print( str( new_room.pos.x ) + " " + str( new_room.pos.y ) + " " + str( new_room.size.x ) + " " + str( new_room.size.y ) )
				if new_room.Intersect( other_room ):
					isIntersected = true
					break
					
			if not isIntersected:	
				Create_Room( new_room )	
				rooms.append( new_room )
				num_rooms = num_rooms + 1
			
	print( "Total rooms:" + str( rooms.size() ) )
	
func Make_Tunnels():
	for i in range( 1, rooms.size() ):
		var prevRoomCenter = rooms[ i - 1 ].Center()
		var currRoomCenter = rooms[ i ].Center()
		
		if 1 == ( randi() % 2 ):
			Create_H_Tunnel( prevRoomCenter.x, currRoomCenter.x, prevRoomCenter.y )
			Create_V_Tunnel( prevRoomCenter.y, currRoomCenter.y, currRoomCenter.x )
		else:
			Create_V_Tunnel( prevRoomCenter.y, currRoomCenter.y, prevRoomCenter.x )
			Create_H_Tunnel( prevRoomCenter.x, currRoomCenter.x, currRoomCenter.y )