extends AudioStreamPlayer

export var hurt_sound : Resource
export var jump_sound : Resource
export var tongue_sound: Resource
export var eat_sound: Resource
export var heal_sound: Resource
export var coin_sound: Resource

export(Array, Resource) var step_sounds: Array

func play_sound(sound: String):
	volume_db = -8
	pitch_scale = 1.0
	match sound:
		"hurt": stream = hurt_sound
		"jump": stream = jump_sound
		"tongue": stream = tongue_sound
		"eat": stream = eat_sound
		"heal": stream = heal_sound
		"coin": stream = coin_sound
		"step": 
			pitch_scale = 1.25
			volume_db = 11 if get_parent().is_on_floor() else -80
			stream = step_sounds[randi() % len(step_sounds)]
	var new_player = AudioStreamPlayer.new()
	add_child(new_player)
	new_player.stream = stream
	new_player.volume_db = volume_db
	new_player.pitch_scale = 0.15 - randf() * 0.3 + pitch_scale
	print(new_player.pitch_scale)
	new_player.connect("finished", new_player, "queue_free")
	new_player.playing = true
