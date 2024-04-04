extends Node2D
class_name Checkpoint

@export var spawnpoint: bool = false

var activated: bool = false

func _ready():
	if spawnpoint:
		activate()
		

func activate():
	GameManager.current_checkpoint = self
	activated = true
	$Deactivated.hide()
	$Activated.show()

func _on_area_2d_area_entered(area):
	if area.get_parent() is Player:
		activate()
		
		
#func update_current_checkpoint():
#	if GameManager.current_checkpoint != self:
#		activated = false
#		$Deactivated.show()
#		$Activated.hide()
