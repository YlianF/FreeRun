extends CharacterBody2D

@export var Acceleration: float = 2000.0
@export var JumpVelocity: float = -1000.0
@export var Friction: float = 7000.0
@export var Gravity: float = 2000.0
@export var Speed: int = 2000

var LastDirection: float = 1.0
var CanGrip: bool = false
var Gripping: RigidBody2D = null

var max_lives = 3
var lives = max_lives

var last_cp

@onready var gc := $GrappleController

func _ready():
	pass

func _physics_process(delta: float) -> void:

	if is_on_floor() && !gc.launched:
		gc.can_launch = true

	if not is_on_floor():
		velocity.y += Gravity * delta

	if Input.is_action_just_pressed("jump") && (is_on_floor() || gc.launched):
		velocity.y += JumpVelocity
		gc.retract()

	var direction: float = Input.get_action_strength("go_right") - Input.get_action_strength("go_left")
	
	if LastDirection != direction and direction != 0:
		velocity.x /= 4.0
		LastDirection = direction

	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * Speed, Acceleration * delta)
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, Friction * delta)
		if !is_on_floor():
			velocity.x = move_toward(velocity.x, 0, Friction/10 * delta)

	if Input.is_action_pressed("jump") and CanGrip:
		Gravity = 0
		global_position = Gripping.global_position
		gc.can_launch = false

	elif Input.is_action_just_released("jump") and CanGrip:
		velocity = Gripping.linear_velocity * 1.5
		if velocity.y > JumpVelocity:
			velocity.y += JumpVelocity
		Gripping.call("deactivate");
		Gravity = 2000
		CanGrip = false
		Gripping = null
		gc.can_launch = true

	if global_position.y > 1000:
		print(global_position)
		velocity = Vector2(0,0)
		if lives == 0:
			global_position = Vector2(0,0)
			lives = max_lives
		else:
			lives -= 1
			if last_cp:
				global_position = last_cp.global_position
			else:
				global_position = Vector2(0,0)

	self.velocity = velocity
	move_and_slide()

	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Boule":
		CanGrip = true
		Gripping = body as RigidBody2D
		body.call("activate");
	if body.name == "Checkpoint":
		if last_cp != body:
			last_cp = body
			lives = max_lives


func _on_grabbing_hitbox_body_exited(body:Node2D):
	if body.name == "Boule":
		CanGrip = false
		Gripping = null
		body.call("deactivate");
