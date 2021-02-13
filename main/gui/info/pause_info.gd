extends Label

func _unhandled_input(event):
	if Input.is_action_just_pressed("pause"):
		visible = not visible
