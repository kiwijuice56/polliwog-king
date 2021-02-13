extends Area2D

func _ready():
	$AnimationPlayer.current_animation = "idle"
	connect("body_entered", self, "body_entered")

func body_entered(body):
	$AudioStreamPlayer.playing = true
