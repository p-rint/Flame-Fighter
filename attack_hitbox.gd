extends Area3D

@export var attacker : CharacterBody3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	area_entered.connect(_area_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _area_entered(area: Area3D) -> void:
	if area.has_method("getHolder"):
		var otherGuy = area.getHolder()
		if area.monitoring and otherGuy.name == "Player":
			print("hit")
			var dir : Vector3 = attacker.direction
			otherGuy.velocity = dir * 5
			
			if otherGuy.has_method("stun"):
				otherGuy.stun(.25)
			#targetRot = atan2(-velocity.x, -velocity.z)
