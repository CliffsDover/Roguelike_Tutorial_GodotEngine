extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var pos = Vector2()
var size = Vector2()

func Init( _pos, _size ):
	pos = _pos
	size = _size
	
func Center():
	var center_x = int( pos.x + size.x / 2 )
	var center_y = int( pos.y + size.y / 2 )
	return Vector2( center_x, center_y )
	
func Intersect( other ):
	#print( "[Rect:Intersect]"  )
	#print( self )
	#print( other )
	#print( ( ( pos.y + size.y ) >= other.pos.y ) )
	var isIntersected = ( pos.x <= ( other.pos.x + other.size.x ) ) and ( ( pos.x + size.x ) >= other.pos.x ) and ( pos.y <= ( other.pos.y + other.size.y ) ) and ( ( pos.y + size.y ) >= other.pos.y )
	#print( "isIntersected = " + str( isIntersected ) )
	return isIntersected 
	