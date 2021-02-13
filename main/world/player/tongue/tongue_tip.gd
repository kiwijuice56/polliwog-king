extends Area2D

export var distance := 30
export var trip_time := .5

#Initial values set by player
var offset := 0
var dir := Vector2()
var orientation:= 1

var forward := true
var attached = null 
var original_pos: Vector2

onready var tween = $Tween
onready var line = $Line
onready var outline = $Outline

func _ready():
	connect("body_entered", self, "body_entered")

func start():
	$AudioStreamPlayer.playing = true
	position.y -= offset
	original_pos = position
	way_forward()
	yield(tween, "tween_completed")
	way_backward()
	yield(tween, "tween_completed")
	if attached: get_parent().eat(attached)
	get_parent().remove_child(self)

func way_forward():
	forward = true
	tween.interpolate_property(self, "position", null, position + (dir * distance), trip_time/2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start() 

func way_backward():
	forward = false
	tween.interpolate_property(self, "position", null, original_pos, trip_time/2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start() 

func _process(delta):
	line.points[0] = -Vector2(position.x + offset * orientation, position.y + offset)
	outline.points[0] = -Vector2(position.x + offset * orientation, position.y + offset)
	if attached: attached.global_position = global_position

func body_entered(body):
	if forward:
		tween.stop_all()
		tween.emit_signal("tween_completed")
