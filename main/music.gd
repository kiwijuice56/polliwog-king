extends AudioStreamPlayer

export(Array, Resource) var songs := []

func _ready():
	return
	volume_db = -8
	stream = songs[3]
	playing = true

func play_song(index: int):
	return
	$Tween.interpolate_property(self, "volume_db", -8, -25, .5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_completed")
	stream = songs[index]
	playing = true
	$Tween.interpolate_property(self, "volume_db", null, -8, .5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
