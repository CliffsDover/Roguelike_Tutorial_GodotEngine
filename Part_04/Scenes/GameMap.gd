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
	
#func _draw():
#	for l in lines:
#		draw_line( l[0], l[1], Color( 1, 0, 0, 1 ), 1, true )
	
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
			#	var wall = tiles[x][y].block_sight		
			if tiles[x][y].isInFOV:
				if tiles[x][y].isWall:
					tiles[x][y].get_node("ColorRect").color = Game.light_wall
				elif tiles[x][y].block_sight:
					tiles[x][y].get_node("ColorRect").color = Game.light_wall
				else:	
					tiles[x][y].get_node("ColorRect").color = Game.light_ground
				tiles[x][y].explored = true
			elif tiles[x][y].explored:	
				if tiles[x][y].block_sight:
					tiles[x][y].get_node("ColorRect").color = Game.dark_wall
				else:	
					tiles[x][y].get_node("ColorRect").color = Game.dark_ground
				
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
			tile.position = Vector2( Vector2( x, y ) * Game.grid_size )
			tiles[x][y] = tile
			$DisplayingTiles.add_child( tile )
			
	Make_Map()
	Make_Tunnels()
	_CheckWalls()
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
	
	var room_max_size = 15
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

func Calculate_FOV( playerPos, radius ):
	#print( "[GameMap:Calculate_FOV]" )

		

		
	for x in range( Game.map_size.x ):
		for y in range( Game.map_size.y ):
			tiles[x][y].isInFOV = false
		

	#print( ray.position )
	
	
	for x in range( -radius, radius + 1 ):
		for y in range( -radius, radius + 1 ):
			var checkingTilePos = Vector2( playerPos.x + x, playerPos.y + y )
			#print( checkingTilePos )
			#print( ( checkingTilePos - playerPos ).length() )
			if ( checkingTilePos - playerPos ).length() > radius * 0.9:
				continue
			if ( checkingTilePos.x ) >= 0 and ( checkingTilePos.x ) < Game.map_size.x and ( checkingTilePos.y) >= 0 and ( checkingTilePos.y ) < Game.map_size.y:
				if tiles[ checkingTilePos.x ][ checkingTilePos.y ].block_sight:
					var collisionTile = CollisionTile.instance()
					collisionTile.get_node( "Area2D" ).set_meta( "id", checkingTilePos.y * Game.map_size.x + checkingTilePos.x )
					collisionTile.position = tiles[ checkingTilePos.x ][ checkingTilePos.y ].position + Game.grid_size / 2
					#print( collisionTile.position )
					$CollisionTiles.add_child( collisionTile )
					
					
					
	for x in range( -radius, radius + 1 ):
		for y in range( -radius, radius + 1 ):
			var checkingTilePos = Vector2( playerPos.x + x, playerPos.y + y )
			if ( checkingTilePos - playerPos ).length() > radius * 0.9:
				continue
			if ( checkingTilePos.x ) >= 0 and ( checkingTilePos.x ) < Game.map_size.x and ( checkingTilePos.y) >= 0 and ( checkingTilePos.y ) < Game.map_size.y:
				_CalculateTargetInFOV( playerPos, checkingTilePos )
				
	_updateDisplayProperties()	
	
	for n in $CollisionTiles.get_children():
		$CollisionTiles.remove_child( n )
		n.queue_free()		


func _IsRayCollided( ray, target ):	
	ray.cast_to = target - ray.position
	#print( target )
	#print( ray.position )
	#print( ray.cast_to )
	ray.force_raycast_update()

	return ray.is_colliding()
		
func _CalculateTargetInFOV( sourcePos, targetPos ):
	
	var ray = RayCast2D.new()
	ray.enabled = true
	$CollisionTiles.add_child( ray )
	
	#print( targetPos )
	#print( targetPos.y * Game.map_size.x + targetPos.x )
	
	for rayPos in [ sourcePos * Game.grid_size + Game.grid_size / 2]:#, sourcePos * Game.grid_size, sourcePos * Game.grid_size + Vector2( Game.grid_size.x, 0 ), sourcePos * Game.grid_size + Vector2( 0, Game.grid_size.y ), sourcePos * Game.grid_size + Vector2( Game.grid_size.x, Game.grid_size.y ) ]: 
		ray.position = rayPos
		var centerVisible = not _IsRayCollided( ray, tiles[targetPos.x][targetPos.y].position + Game.grid_size / 2 )
		#print( centerVisible )
		if not centerVisible:
			#print( ray.get_collider().position )
			#print( "cid" + str( ray.get_collider().get_meta( "id" ) ) )
			if ray.get_collider().get_meta( "id" ) == ( targetPos.y * Game.map_size.x + targetPos.x ):
				centerVisible = true
			
		var topLeftVisible = not _IsRayCollided( ray, tiles[targetPos.x][targetPos.y].position + Vector2( 1, 1 ) )
		#print( topLeftVisible )
		if not topLeftVisible:
			#print( targetPos.y * Game.map_size.x + targetPos.x )
			#print( "cid" + str( ray.get_collider().get_meta( "id" ) ) )
			if ray.get_collider().get_meta( "id" ) == ( targetPos.y * Game.map_size.x + targetPos.x ):
				topLeftVisible = true
		
		var topRightVisible = not _IsRayCollided( ray, tiles[targetPos.x][targetPos.y].position + Vector2( Game.grid_size.x - 1, 1 ))
		#print( topRightVisible )
		if not topRightVisible:
			#print( targetPos.y * Game.map_size.x + targetPos.x )
			#print( ray.get_collider().get_meta( "id" ) )
			if ray.get_collider().get_meta( "id" ) == ( targetPos.y * Game.map_size.x + targetPos.x ):
				topRightVisible = true
		
		var bottomLeftVisible = not _IsRayCollided( ray, tiles[targetPos.x][targetPos.y].position + Vector2( 1, Game.grid_size.y - 1 ) )				
		#print( bottomLeftVisible )
		if not bottomLeftVisible:
			#print( targetPos.y * Game.map_size.x + targetPos.x )
			#print( ray.get_collider().get_meta( "id" ) )
			if ray.get_collider().get_meta( "id" ) == ( targetPos.y * Game.map_size.x + targetPos.x ):
				bottomLeftVisible = true
		
		var bottomRightVisible = not _IsRayCollided( ray, tiles[targetPos.x][targetPos.y].position + Vector2( Game.grid_size.x - 1, Game.grid_size.y - 1 ) )				
		#print( bottomRightVisible )	
		if not bottomRightVisible:
			#print( targetPos.y * Game.map_size.x + targetPos.x )
			#print( ray.get_collider().get_meta( "id" ) )
			if ray.get_collider().get_meta( "id" ) == ( targetPos.y * Game.map_size.x + targetPos.x ):
				bottomRightVisible = true
		
		
		tiles[targetPos.x][targetPos.y].isInFOV = centerVisible or topLeftVisible or topRightVisible or bottomLeftVisible or bottomRightVisible
			
	
	$CollisionTiles.remove_child( ray )
	ray.queue_free()
	
func _CheckWalls():
	for x in range( width ):
		for y in range( height ):				
			tiles[x][y].isWall = _checkWall( Vector2(x,y) )	
			#if tiles[x][y].isWall:
			#	print( str( x ) + "," + str( y ) + " is wall" )
				
func _checkWall( pos ):
	var isWall = false
			
	for dx in range( -1, 2 ):
		for dy in range( -1, 2):
			if dx == 0 and dy == 0:
				continue
			var checkingTilePos = Vector2( pos.x + dx, pos.y + dy )
			if checkingTilePos.x >= 0 and checkingTilePos.x < width and checkingTilePos.y >= 0 and checkingTilePos.y < height:
				if not tiles[ checkingTilePos.x ][ checkingTilePos.y ].block_sight:
					isWall = isWall or true
					

	return ( tiles[pos.x][pos.y].block_sight and isWall )	