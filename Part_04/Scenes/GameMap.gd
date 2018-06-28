extends Node2D


onready var Tile = preload( "res://Scenes/Tile.tscn" )
onready var Rect = preload( "res://Scenes/Rect.tscn" )
onready var CollisionTile = preload( "res://Scenes/CollisionTile.tscn" )

var width
var height
var tiles = []
var rooms = []
var collidedPos = Vector2( 0,0 )
# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var lines = []

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	Init( Game.map_size )
	InitializeTiles()
	set_process( true )
	
	set_process_input( true )
	
func _process(delta):
	pass
	#update()
	
func _draw():
	for l in lines:
		draw_line( l[0], l[1], Color( 1, 0, 0, 1 ), 1 )
	
func _input(event):
	pass
	#if event is InputEventMouseButton:
	#	if event.button_index == BUTTON_LEFT and event.pressed:
	#		print("pressed")
	#		var pressedPos = Vector2( int( event.position.x / Game.grid_size.x ), int( event.position.y / Game.grid_size.y ) )
	#		print( pressedPos )
	#		draw_line( playerPos * Game.grid_size, pressedPos * Game.grid_size )
	#		_update()

	
func _updateDisplayProperties():
	for x in range( width ):
		for y in range( height ):
			var wall = tiles[x][y].block_sight		
			if tiles[x][y].isInFOV:
				if wall:
					tiles[x][y].color = Color( 0.5, 0, 0.0, 0.5 )
				else:	
					tiles[x][y].color = Color( 0.0, 0.5, 0.0, 0.5 )
			else:	
				if wall:
					tiles[x][y].color = Color( 0, 0, 0.5, 0.5 )
				else:	
					tiles[x][y].color = Color( 0.2, 0.2, 0.75, 0.5 )
				
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
			$DisplayingTiles.add_child( tile )
			
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
	
	var room_max_size = 20
	var room_min_size = 6
	var max_rooms = 10
	
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

func Calculate_FOV( playerPos, radius ):
	print( "[GameMap:Calculate_FOV]" )

	
	for n in $CollisionTiles.get_children():
		$CollisionTiles.remove_child( n )
		n.queue_free()
		
	for x in range( Game.map_size.x ):
		for y in range( Game.map_size.y ):
			tiles[x][y].isInFOV = false
		

	#print( ray.position )
	
	
	for x in range( -radius, radius + 1 ):
		for y in range( -radius, radius + 1 ):
			var checkingTilePos = Vector2( playerPos.x + x, playerPos.y + y )
			print( ( checkingTilePos - playerPos ).length() )
			if ( checkingTilePos - playerPos ).length() > radius * 0.9:
				continue
			if ( checkingTilePos.x ) >= 0 and ( checkingTilePos.x ) < Game.map_size.x and ( checkingTilePos.y) >= 0 and ( checkingTilePos.y ) < Game.map_size.y:
				if tiles[ checkingTilePos.x ][ checkingTilePos.y ].block_sight:
					var collisionTile = CollisionTile.instance()
					collisionTile.position = tiles[ checkingTilePos.x ][ checkingTilePos.y ].rect_position + Game.grid_size / 2
					$CollisionTiles.add_child( collisionTile )
					
					
					
	for x in range( -radius, radius + 1 ):
		for y in range( -radius, radius + 1 ):
			var checkingTilePos = Vector2( playerPos.x + x, playerPos.y + y )
			if ( checkingTilePos - playerPos ).length() > radius * 0.9:
				continue
			if ( checkingTilePos.x ) >= 0 and ( checkingTilePos.x ) < Game.map_size.x and ( checkingTilePos.y) >= 0 and ( checkingTilePos.y ) < Game.map_size.y:
				_CalculateTargetInFOV( playerPos, checkingTilePos )
				
	_updateDisplayProperties()	

func _IsRayCollided( ray, target ):	
	ray.cast_to = target - ray.position
	#print( ray.cast_to )
	ray.force_raycast_update()
	return ray.is_colliding()
		
func _CalculateTargetInFOV( sourcePos, targetPos ):
	
	var ray = RayCast2D.new()
	ray.enabled = true
	ray.position = sourcePos * Game.grid_size + Game.grid_size / 2
	$CollisionTiles.add_child( ray )
	
	var topLeftVisible = not _IsRayCollided( ray, tiles[targetPos.x][targetPos.y].rect_position + Vector2( 1, 1 ) )
	print( topLeftVisible )
	var topRightVisible = not _IsRayCollided( ray, tiles[targetPos.x][targetPos.y].rect_position + Vector2( Game.grid_size.x - 1, 1 ))
	print( topRightVisible )
	var bottomLeftVisible = not _IsRayCollided( ray, tiles[targetPos.x][targetPos.y].rect_position + Vector2( 1, Game.grid_size.y - 1 ) )				
	print( bottomLeftVisible )
	var bottomRightVisible = not _IsRayCollided( ray, tiles[targetPos.x][targetPos.y].rect_position + Vector2( Game.grid_size.x - 1, Game.grid_size.y - 1 ) )				
	print( bottomRightVisible )	
	
	tiles[targetPos.x][targetPos.y].isInFOV = topLeftVisible or topRightVisible or bottomLeftVisible or bottomRightVisible
	print( tiles[targetPos.x][targetPos.y].isInFOV )	
	
	$CollisionTiles.remove_child( ray )
	ray.queue_free()