extends Area2D

export var value := 1
export var score := 10

func _ready():
	connect("area_entered", self, "area_entered")
	$AnimationPlayer.current_animation = "idle"
	$VisibilityNotifier2D.connect("screen_entered", self, "screen_entered")
	$VisibilityNotifier2D.connect("screen_exited", self, "screen_exited")

func screen_entered():
	$CollisionShape2D.disabled = false

func screen_exited():
	$CollisionShape2D.disabled = true

func collect():
	$AudioStreamPlayer.playing = true
	$AnimationPlayer.current_animation = "collect"
	yield($AnimationPlayer,"animation_finished")
	queue_free()

func area_entered(area):
	if area.is_in_group("Tongue") and area.attached == null:
		area.attached = self
