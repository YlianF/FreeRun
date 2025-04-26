extends GridContainer





func _ready():
	var preloadScene = preload("res://scenes/ui/button.tscn");
	for i in range(1, ProjectSettings.get_setting("global/NbLvl")+1):
		var button = preloadScene.instantiate()
		add_child(button)
		button.SetText(str(i))
		button.name = str(i)
		button.zoomValue = 1.1
		button.connect("gui_input", Callable(self, "_on_level_grid_button_gui_input").bind(button));






func _on_level_grid_button_gui_input(event:InputEvent, button:ButtonDynamique) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		get_tree().change_scene_to_file("res://scenes/level/level_" + button.name + ".tscn");


func _on_button_back_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		get_tree().change_scene_to_file("res://scenes/ui/MainMenu.tscn");
