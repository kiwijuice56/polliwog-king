extends Enemy

export var bullet = preload("res://main/world/bullets/mini_bullet/MiniBullet.tscn")
export var bullet_num := 6

onready var hat_timer := $HatTimer

func _enter_tree():
	$HatTimer.connect("timeout", self, "replace_hat")

func replace_hat():
	anim.current_animation = "reload"
	yield(anim, "animation_finished")
	anim.current_animation = "idle"

func shoot():
	anim.current_animation = "idle_hatless"
	if not target:
		anim.current_animation = "idle"
		return
	var new_bullet : Area2D = bullet.instance()
	new_bullet.dir = dir
	new_bullet.target = target
	hat_timer.start(shoot_delay/2)
	new_bullet.global_position = global_position
	new_bullet.position.y -= 5
	get_tree().get_root().call_deferred("add_child", new_bullet)
