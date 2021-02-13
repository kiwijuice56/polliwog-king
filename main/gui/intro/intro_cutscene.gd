extends CanvasLayer

export(Array, Texture) var images
export(Array, String) var texts

signal done

onready var anim = $AnimationPlayer

var current_part = 0

func _ready():
	$AnimationPlayer.current_animation = "in"
	switch_part(0)

func switch_part(part_index: int):
	$TextureRect.texture = images[part_index]
	$MarginContainer/Label.text = texts[part_index]

func _unhandled_input(event):
	if Input.is_action_just_pressed("jump"):
		current_part += 1
		if current_part + 1> len(texts):
			emit_signal("done")
			return
		switch_part(current_part)
