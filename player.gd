extends CharacterBody3D

var direction : Vector3
var input_dir : Vector2
const SPEED = 6.0
const SSPEED = 10.0
const JUMP_VELOCITY = 4.5

@onready var camPiv = $CamPivot
@onready var AttackFuncs = $"../GameFunctions/Attacks"
@onready var model = $Character

var dt : float
var targetRot = 0
@export var health = 99

@export var score : int = 0

@onready var animPlr: AnimationPlayer = $AnimationPlayer

var camForw : Vector3


@onready var stunTimer : Timer = $Timers/Stun

enum States {MOVE, STUNNED, ATTACKING, RECOVERING}

var state = States.MOVE

var attackNum = 0

func flatten(vector: Vector3) -> Vector3:
	return Vector3( vector.x, 0, vector.z)


func move() -> void:
	model.rotation.y = lerp_angle(model.rotation.y, targetRot, .5)
	
	#$CollisionShape3D.rotation.y = model.rotation.y
	var canMove = state != States.STUNNED and state != States.RECOVERING
	if direction and canMove:
		velocity.x = lerp(velocity.x, direction.x * SPEED, .15 * 2)
		velocity.z = lerp(velocity.z, direction.z * SPEED, .15 * 2)
		targetRot = atan2(-velocity.x, -velocity.z)
	else:
		velocity = lerp(velocity, Vector3.ZERO + Vector3(0,velocity.y,0), 8 * dt)

func _physics_process(delta: float) -> void:
	dt = delta
	camForw = flatten($CamPivot.basis.z)
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_just_pressed("Attack"):
		if state != States.RECOVERING and state != States.STUNNED:
			attack()
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	input_dir = Input.get_vector("Left", "Right", "Up", "Down")
	direction = flatten($CamPivot.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	
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



func attack() -> void:
	animPlr.play("RESET")
	if attackNum == 0:
		animPlr.play("Attack1")
	else:
		animPlr.play("Attack2")
	
	attackNum = wrapi(attackNum + 1, 0, 2)
	print(attackNum)
	#animPlr.play("RESET")
	velocity = -camForw.normalized() * 5
	
	targetRot = atan2(-velocity.x, -velocity.z)


func _on_stun_timeout() -> void:
	state = States.MOVE
