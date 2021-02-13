extends CanvasLayer

var score setget score_changed
var time setget time_changed

var duration = 2
var points_per_sec = 6
var wait_time = 5

onready var score_label = $CenterContainer/VBoxContainer/Score
onready var time_label = $CenterContainer/VBoxContainer/Time

signal done

func score_changed(new_score):
	score_label.text = "Score: " + str(int(new_score)).pad_zeros(6)
	score = new_score

func time_changed(new_time):
	time_label.text = "Time: " + str(int(new_time)).pad_zeros(3)
	time = new_time

func finish(given_score, given_time):
	self.score = given_score
	self.time = given_time
	$Tween.interpolate_property(self, "time", null, 0, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(self, "score", null, score +  (time * points_per_sec), duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_completed")
	$Timer.start(wait_time)
	yield($Timer, "timeout")
	emit_signal("done")
