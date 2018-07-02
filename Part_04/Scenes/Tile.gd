extends Node2D


var blocked = false
var block_sight = false
var isInFOV = false
var explored = false
var isWall = false


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
		
