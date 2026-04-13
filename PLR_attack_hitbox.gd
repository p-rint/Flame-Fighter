extends Area3D

@export var attacker : CharacterBody3D

@onready var canvas_layer: CanvasLayer = $"../../../../../CanvasLayer"

@onready var player = %Player
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
		if area.monitoring and otherGuy.name != "Player":
			#%Player.camForw
			var dir : Vector3 = attacker.camForw
			
			otherGuy.velocity = -dir * 5
			makeSparks()
			if otherGuy.has_method("stun"):
				otherGuy.stun(1.0)
			if otherGuy.health <= 0:
				player.score += 1
			#targetRot = atan2(-velocity.x, -velocity.z)


func makeSparks():
	var new : GPUParticles3D = $"../../../Particles/Sparks".duplicate()
	$"../../..".add_child(new)
	new.emitting = true
	await new.finished
	print("done!!")
