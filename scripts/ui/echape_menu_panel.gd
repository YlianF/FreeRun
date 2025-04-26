extends CanvasLayer



func _on_resume_gui_input(event:InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		get_tree().paused = false
		queue_free();

func _on_retry_gui_input(event:InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		get_tree().paused = false
		get_tree().change_scene_to_file("res://scenes/level/level_" + get_parent().name + ".tscn");

func _on_main_menu_gui_input(event:InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		get_tree().paused = false
		get_tree().change_scene_to_file("res://scenes/ui/MainMenu.tscn");
