extends Control
class_name ButtonDynamique


@onready var _label : TextDynamique = %TextDynamique;

@export var textButton : String = "";
@export var colorTextButton : Color = Color.WHITE;

@export_group("Zoom")
@export var zoomValue : float = 1;
@export var zoomTime : float = 0.1;


func _ready():
	_label.SetText(textButton);
	_label.SetFontColor(colorTextButton);



func SetText(s: String) -> void :
	_label.SetText(s);


func SetFontColor(color: Color) -> void:
	_label.SetFontColor(color);


func _on_mouse_entered() -> void:
	if(zoomValue != 1):
		_resetPivotOffset()
		var tween := create_tween();
		tween.tween_property(self, "scale", Vector2(zoomValue, zoomValue), zoomTime);


func _on_mouse_exited() -> void:
	if(zoomValue != 1):
		_resetPivotOffset()
		var tween := create_tween();
		tween.tween_property(self, "scale", Vector2(1, 1), zoomTime);


func _resetPivotOffset():
	pivot_offset = size/2;
