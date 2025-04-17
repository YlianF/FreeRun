extends Node2D

@export var rest_length = 200.0
@export var stiffness = 15.0
@export var damping = 1.0

@onready var player := get_parent()
@onready var ray := $RayCast2D
@onready var rope := $Grapple
@onready var preview := $RayCast2D/GrapplePreview

var launched = false
var target: Vector2

var can_launch = true;

func _process(delta):
	ray.look_at(get_global_mouse_position())
	
	if Input.is_action_pressed("click"):
		launch()
	if Input.is_action_just_released("click"):
		retract()
	
	if launched:
		handle_grapple(delta)

	if ray.is_colliding():
		preview.global_position = ray.get_collision_point()
	else:
		preview.position = Vector2(800, 0)

func launch():
	if ray.is_colliding() && can_launch:
		launched = true
		can_launch = false
		target = ray.get_collision_point()
		preview.hide()
		rope.show()

func retract():
	launched = false
	preview.show()
	rope.hide()

func handle_grapple(delta):
	var target_dir = player.global_position.direction_to(target)
	var target_dist = player.global_position.distance_to(target)
	
	var displacement = target_dist - rest_length
	
	var force = Vector2.ZERO
	
	if displacement > 0:
		var spring_force_magnitude = stiffness * displacement
		var spring_force = target_dir * spring_force_magnitude
		
		var vel_dot = player.velocity.dot(target_dir)
		var damping = -damping * vel_dot * target_dir
		
		force = spring_force + damping
	
	player.velocity += force * delta
	update_rope()

func update_rope():
	rope.set_point_position(1, to_local(target))
