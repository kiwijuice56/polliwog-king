extends Area2D

func _ready():
	$AnimationPlayer.current_animation = "untaken"

func taken():
	$AnimationPlayer.current_animation = "taken"
	$CollectionEffect.emitting = true
	$AudioStreamPlayer.playing = true
