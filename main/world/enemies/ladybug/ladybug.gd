extends Enemy

export var bullet = preload("res://main/world/bullets/mini_bullet/MiniBullet.tscn")
export var bullet_num := 6

func shoot():
	if not target: return
	if not is_in_group("Damage"): return
	var angle = 360/bullet_num
	for i in range(bullet_num):
		var new_bullet : Area2D = bullet.instance()
		dir = Vector2(1,0).rotated(deg2rad(i * angle))
		new_bullet.dir = dir
		new_bullet.get_node("Trail").rotation_degrees = rad2deg(Vector2(1,0).angle_to(dir))
		new_bullet.global_position = global_position
		get_tree().get_root().call_deferred("add_child", new_bullet)
