extends CharacterBody2D

@export var Acceleration: float = 2000.0
@export var JumpVelocity: float = -1000.0
@export var Friction: float = 7000.0
@export var Gravity: float = 2000.0
@export var Speed: int = 2000

var LastDirection: float = 1.0
var CanGrip: bool = false
var Gripping: RigidBody2D = null

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

	if Input.is_action_pressed("jump") and CanGrip:
		Gravity = 0
		global_position = Gripping.global_position
		gc.can_launch = false

	elif Input.is_action_just_released("jump") and CanGrip:
		velocity = Gripping.linear_velocity * 1.5
		Gripping.call("deactivate");
		Gravity = 2000
		CanGrip = false
		Gripping = null
		gc.can_launch = true

	self.velocity = velocity
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "chaine3":
		CanGrip = true
		Gripping = body as RigidBody2D
		body.call("activate");


func _on_grabbing_hitbox_body_exited(body:Node2D):
	if body.name == "chaine3":
		CanGrip = false
		Gripping = null
		body.call("deactivate");
