extends ColorRect


var blocked = false
var block_sight = false

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass


func Init( isBlocked, isBlockSight = null ):
	blocked = isBlocked
	
	if isBlockSight is null:
		block_sight = blocked
	else:
		block_sight = isBlockSight	
		
