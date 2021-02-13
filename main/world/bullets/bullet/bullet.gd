extends Area2D
class_name Bullet

export var speed := 1.0
export var life_time := 10.0
export var explosion_time := 0.4
export var damage:= 1.0
var dir := Vector2()

func _ready():
	$Timer.connect("timeout", self, "death")
	$Timer.start(life_time)
	connect("body_entered", self, "body_entered")

func body_entered(body):
	death()

func death():
	$CollisionShape2D.call_deferred("set_disabled", true)
	dir = Vector2()
	$AnimationPlayer.current_animation = "death"
	yield($AnimationPlayer,"animation_finished")
	queue_free()

func _physics_process(delta):
	position += dir * speed
