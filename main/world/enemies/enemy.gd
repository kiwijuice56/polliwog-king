extends Area2D
class_name Enemy

export var movement_speed := 1.0
export var shoot_delay := 1.0
export var invincibility := 0.3
export var life := 3.0
export var score := 100
export (Array, int) var path
export var eat_able: bool
export var path_range := 2.0
export var damage := 1.0


onready var shoot_timer := $ShootTimer
onready var hurt_timer := $HurtTimer
onready var hurt_effect := $HurtEffect
onready var anim = $AnimationPlayer
onready var player = get_tree().get_root().get_node("Main").player
onready var path_points := get_parent().get_parent().get_node("PathPoints")

var dir := Vector2(0, 1)
var vel := Vector2()
var target: KinematicBody2D
var path_point := 0

func _ready():
	$ShootTimer.connect("timeout", self, "shoot")
	$Range.connect("body_entered", self, "target_detected")
	$Range.connect("body_exited", self, "target_undetected")
	connect("area_entered", self, "area_entered")
	$VisibilityNotifier2D.connect("screen_entered", self, "on_screen")
	$VisibilityNotifier2D.connect("screen_exited", self, "off_screen")
	$AnimationPlayer.current_animation = "idle"

func on_screen():
	$CollisionShape2D.disabled = false

func off_screen():
	$CollisionShape2D.disabled = true

func target_detected(new_target):
	target = new_target
	if shoot_timer.is_stopped():
		shoot()
		shoot_timer.start(shoot_delay)

func target_undetected(old_target):
	if target == old_target:
		target = null
		#shoot_timer.stop()

func area_entered(area):
	if eat_able and area.is_in_group("Tongue") and area.attached == null and area.forward == true:
		area.attached = self
		remove_from_group("Damage")
		return
	elif area.is_in_group("Bullet"):
		if not hurt_timer.is_stopped():
			return
		life -= area.damage
		hurt_timer.start(invincibility)
		hurt_timer.anim.current_animation = "hurt"
		area.queue_free()
		hurt_effect.emitting = true
		if life <= 0:
			movement_speed = 0
			yield(hurt_timer, "timeout")
			queue_free()

func follow_path():
	if path.size() == 0:
		vel = Vector2()
		return
	var difference : Vector2 = path_points.get_child(path[path_point]-1).global_position - global_position
	if difference.length() < path_range:
		path_point += 1
		if path_point == path.size():
			path_point = 0
	vel = difference.normalized()
	global_position += vel * movement_speed

func shoot():
	pass

func _physics_process(delta):
	follow_path()
