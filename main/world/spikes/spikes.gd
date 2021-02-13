extends Area2D

export var damage:= 1.5

func _ready():
	$VisibilityNotifier2D.connect("screen_entered", self, "screen_entered")
	$VisibilityNotifier2D.connect("screen_exited", self, "screen_exited")

func screen_entered():
	$CollisionShape2D.disabled = false

func screen_exited():
	$CollisionShape2D.disabled = true
