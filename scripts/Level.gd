extends Node2D

@export var grapple: bool
@export var lives: bool
@export var mouse: bool

@onready var player := $Player

@onready var preloadScene := preload("res://scenes/ui/echape_menu.tscn");

func _ready():
    if grapple:
        player.deactivate_grapple()
    if lives:
        player.deactivate_lives()
    if mouse:
        player.deactivate_mouse()

func _physics_process(_delta: float) -> void:
    if Input.is_action_pressed("echape"):

        var echapeMenu = preloadScene.instantiate()
        add_child(echapeMenu)

        get_tree().paused = true
