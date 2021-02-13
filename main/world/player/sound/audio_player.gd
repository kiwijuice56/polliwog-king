extends AudioStreamPlayer

export var hurt_sound : Resource
export var jump_sound : Resource
export var tongue_sound: Resource
export var eat_sound: Resource
export var heal_sound: Resource
export var coin_sound: Resource

func play_sound(sound: String):
	match sound:
		"hurt": stream = hurt_sound
		"jump": stream = jump_sound
		"tongue": stream = tongue_sound
		"eat": stream = eat_sound
		"heal": stream = heal_sound
		"coin": stream = coin_sound
	playing = true
