extends Label

var displayChar = "@"
var displayColor = Color( 1, 1, 1, 1 )
var position = Vector2( 0, 0 )

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass
	
func _updatePosition():
	rect_position = position * Vector2( 16, 16 )
	
func _updateDisplayProperties():
	text = displayChar
	#add_color_override( "font_color", displayColor )
	set( "custom_colors/font_color", displayColor )

func Init( _position, _displayChar, _displayColor ):
	position = _position
	displayChar = _displayChar
	displayColor = _displayColor
	
	_updateDisplayProperties()
	_updatePosition()
	
func Move( delta ):
	position += delta
	_updatePosition()
