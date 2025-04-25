extends Control 
class_name TextDynamique

@onready var _label : Label = %TextLabel;




func SetText(s: String) -> void :
    _label.text = s;


func SetFontColor(color: Color) -> void:
    _label.add_theme_color_override("font_color", color);


