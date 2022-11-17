extends Bullet

var target = null

func _physics_process(delta):
	if target:
		dir = (target.global_position - global_position).normalized()
		var angle = Vector2(1,0).rotated(deg2rad(rotation_degrees)).angle_to(dir)
		rotation_degrees += clamp(rad2deg(angle), -.7, .7)
		position += Vector2(1,0).rotated(deg2rad(rotation_degrees)) * speed * delta
		speed *= 1 + delta
