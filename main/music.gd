extends AudioStreamPlayer

export(Array, Resource) var songs := []

func _ready():
	volume_db = -3
	stream = songs[3]
	playing = true

func play_song(index: int):
	$Tween.interpolate_property(self, "volume_db", -3, -25, .5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_completed")
	stream = songs[index]
	playing = true
	$Tween.interpolate_property(self, "volume_db", null, -3, .5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
