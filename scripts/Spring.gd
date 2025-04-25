extends RigidBody2D

var OnMouse: bool = false
var holding = false
var active = false

func _physics_process(delta: float) -> void:
	if OnMouse && Input.is_action_pressed("click"):
		holding = true
	if holding && !Input.is_action_pressed("click") && !OnMouse:
		holding = false

	if holding && active:
		apply_force(get_local_mouse_position())

func activate():
	active = true

func deactivate():
	active = false


func _on_mouse_entered():
	OnMouse = true


func _on_mouse_exited():
	OnMouse = false
