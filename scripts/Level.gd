extends Node2D

@export var grapple: bool
@export var lives: bool
@export var mouse: bool

@onready var player := $Player

func _ready():
    if grapple:
        player.deactivate_grapple()
    if lives:
        player.deactivate_lives()
    if mouse:
        player.deactivate_mouse()