extends CharacterBody3D

var direction : Vector3
var input_dir : Vector2
const SPEED = 3.0
const LUNGESPEED = 10.0
var curSpeed = SPEED
const JUMP_VELOCITY = 4.5

@onready var model = $Character

var dt : float
var targetRot = 0
@export var health = 99

@onready var animPlr: AnimationPlayer = $AnimationPlayer

@onready var player: CharacterBody3D = %Player

var toPlr : Vector3

@onready var stunTimer : Timer = $Timers/Stun

func flatten(vector: Vector3) -> Vector3:
	return Vector3( vector.x, 0, vector.z)

enum States {MOVE, STUNNED, ATTACKING, RECOVERING}

var state = States.MOVE


func move() -> void:
	model.rotation.y = lerp_angle(model.rotation.y, targetRot, .5)
	
	#$CollisionShape3D.rotation.y = model.rotation.y
	if direction:
		if state != States.STUNNED and state != States.RECOVERING:
			velocity.x = lerp(velocity.x, direction.x * curSpeed, .15 * 2)
			velocity.z = lerp(velocity.z, direction.z * curSpeed, .15 * 2)
			targetRot = atan2(-velocity.x, -velocity.z)
		else:
			#print ("Freez")
			velocity = lerp(velocity, Vector3.ZERO + Vector3(0,velocity.y,0), 8 * dt)

func _physics_process(delta: float) -> void:
	dt = delta
	
	toPlr = player.position - position
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	direction = flatten(toPlr).normalized()
	
	
	if toPlr.length() <= 10:
		curSpeed = LUNGESPEED
	else:
		curSpeed = SPEED
	if toPlr.length() <= 1.8 and state != States.RECOVERING and state != States.STUNNED:
		attack()
	
	runState()
	
	move_and_slide()
	
	

func runState() -> void:
	if state == States.MOVE:
		move()
	if state == States.STUNNED:
		move()
	if state == States.RECOVERING:
		move()

func stun(time : float) -> void:
	state = States.STUNNED
	stunTimer.start(time)
	animPlr.play("Stun")

func recover(time : float) -> void:
	state = States.RECOVERING
	stunTimer.start(time)

func attack():
	targetRot = atan2(-direction.x,-direction.z)
	print("Attack")
	recover(1)
	animPlr.play("RESET")
	animPlr.play("Attack")
	

func _on_stun_timeout() -> void:
	state = States.MOVE
