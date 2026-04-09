extends Area3D

@export var holder : CharacterBody3D 
@onready var player: CharacterBody3D = %Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	area_entered.connect(_area_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _area_entered(area: Area3D) -> void:
	if area.has_method("getHolder"):
		var attacker = area.getHolder()
		if area.monitoring:
			print("hit")
			holder.velocity = -attacker.camForw.normalized() * 5
			
			if holder.has_method("stun"):
				holder.stun(1.0)
			#targetRot = atan2(-velocity.x, -velocity.z)
