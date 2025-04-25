extends TextureRect



func _ready():
	call_deferred("grossir")


func grossir():
	_resetPivotOffset()
	var tween := create_tween();
	tween.tween_property(self, "scale", Vector2(1.15, 1.15), 5)
	tween.connect("finished", Callable(self, "retressir"))


func retressir():
	_resetPivotOffset()
	var tween := create_tween();
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 5)
	tween.connect("finished", Callable(self, "grossir"))


func _resetPivotOffset():
	pivot_offset = size/2;
