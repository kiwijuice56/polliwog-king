extends CanvasLayer

onready var anim := $AnimationPlayer
onready var label := $VBoxContainer/Yellow/Level

func transition_in(level: int):
	anim.current_animation = "in"
	get_child(0).visible = true
	if level == 4:
		label.text = ""
		return
	label.text = "Level " + str(level)

func transition_out():
	anim.current_animation = "out"
	yield(anim, "animation_finished")
	get_child(0).visible = false
