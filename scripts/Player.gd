extends CharacterBody2D

@export var Acceleration: float = 1500.0
@export var JumpVelocity: float = -1000.0
@export var Friction: float = 7000.0
@export var Gravity: float = 2000.0
@export var Speed: int = 1500

@onready var HealthBar : TextureProgressBar = $UIPlayer/HealthBar

var LastDirection: float = 1.0
var CanGrip: bool = false
var Gripping: RigidBody2D = null

var max_lives = 3
var lives = max_lives

var last_cp

@onready var gc := $GrappleController

var deact_grapple = false;

func _ready():
	HealthBar.max_value = max_lives
	HealthBar.value = lives

func _physics_process(delta: float) -> void:

	if is_on_floor() && !gc.launched && !deact_grapple:
		gc.can_launch = true

	if not is_on_floor():
		velocity.y += get_gravity_custom(delta)
	
	handle_jump()

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
			velocity.x = move_toward(velocity.x, 0, Friction/50 * delta)

	if Input.is_action_pressed("jump") and CanGrip:
		Gravity = 0
		global_position = Gripping.global_position
		gc.can_launch = false

	elif Input.is_action_just_released("jump") and CanGrip:
		velocity = Gripping.linear_velocity * 1.3

		Gripping.call("deactivate");
		Gravity = 2000
		CanGrip = false
		Gripping = null
		if !deact_grapple:
			gc.can_launch = true

	if global_position.y > 1000:
		velocity = Vector2(0,0)
		gc.retract()
		if lives == 1:
			global_position = Vector2(0,0)
			lives = max_lives
			HealthBar.value = lives
			last_cp = null;
		else:
			lives -= 1
			HealthBar.value = lives
			if last_cp:
				global_position = last_cp.global_position
			else:
				global_position = Vector2(0,0)

	self.velocity = velocity
	move_and_slide()

func get_gravity_custom(delta) -> float:
	var g = Gravity * delta
	if velocity.y > -100:
		g *= 1.5
	return g

func handle_jump():
	if Input.is_action_just_pressed("jump") && (is_on_floor() || gc.launched):
		if is_on_floor():
			velocity.y += JumpVelocity
		else:
			if velocity.y < JumpVelocity:
				velocity.y += JumpVelocity/10
			else:
				velocity.y += JumpVelocity/2
		gc.retract()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Boule":
		CanGrip = true
		Gripping = body as RigidBody2D
		body.call("activate");
	if body.name.contains("Checkpoint"):
		if last_cp != body:
			last_cp = body
			lives = max_lives
			HealthBar.value = lives
	if body.name.contains("Goal"):
		get_tree().change_scene_to_file("res://scenes/ui/victory_menue.tscn");


func _on_grabbing_hitbox_body_exited(body:Node2D):
	if body.name == "Boule":
		CanGrip = false
		Gripping = null
		body.call("deactivate");

func deactivate_grapple():
	gc.visible = false
	deact_grapple = true

func deactivate_lives():
	HealthBar.visible = false

func deactivate_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
