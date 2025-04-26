extends Node


var levelNumber : int;
@onready var levelXFinish : TextDynamique = %LevelXFinish;



func SetLevel(thisLevel:int):
	levelNumber = thisLevel
	levelXFinish.SetText("Level " + str(thisLevel) + " Finish")


func _on_next_level_gui_input(event:InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		get_tree().paused = false
		if(levelNumber >= ProjectSettings.get_setting("global/NbLvl")):
			get_tree().change_scene_to_file("res://scenes/ui/MainMenu.tscn");
		else:
			get_tree().change_scene_to_file("res://scenes/level/level_" + str(levelNumber+1) + ".tscn");


func _on_retry_gui_input(event:InputEvent) -> void:
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		get_tree().paused = false
		get_tree().change_scene_to_file("res://scenes/level/level_" + str(levelNumber) + ".tscn");

func _on_level_select_gui_input(event:InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		get_tree().paused = false
		get_tree().change_scene_to_file("res://scenes/ui/level_selecteur.tscn");
