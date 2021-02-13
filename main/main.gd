extends Node

var level = null
var current_level_index := -1
var player = preload("res://main/world/player/Player.tscn").instance()
var info_gui = preload("res://main/gui/info/Info.tscn").instance()
var transition = preload("res://main/gui/transition/Transition.tscn").instance()
var outro = preload("res://main/gui/outro/Outro.tscn").instance()
var intro = preload("res://main/gui/intro/IntroCutscene.tscn")
export(Array, String) var level_paths

onready var music = $Music

signal transition_done

func _ready():
	$Title/MarginContainer/VBoxContainer2/VBoxContainer/Start.connect("pressed", self, "start_game")

func start_game():
	var cutscene = intro.instance()
	add_child(cutscene)
	yield(cutscene.anim, "animation_finished")
	$Title.queue_free()
	yield(cutscene, "done")
	current_level_index = 3
	switch_level(0)
	yield(self, "transition_done")
	cutscene.queue_free()

func next_level():
	if current_level_index == len(level_paths) - 1:
		add_child(transition)
		transition.transition_in(4)
		music.play_song(3)
		yield(transition.anim, "animation_finished")
		add_child(outro)
		transition.transition_out()
	else:
		switch_level(current_level_index + 1)

func switch_level(index: int):
	add_child(transition)
	transition.transition_in(index + 1)
	if not index == current_level_index:
		current_level_index = index
		music.play_song(current_level_index)
	yield(transition.anim, "animation_finished")
	emit_signal("transition_done")
	if info_gui.is_inside_tree(): remove_child(info_gui)
	if player.is_inside_tree():
		remove_child(player)
	if level:
		level.queue_free()
	level = load(level_paths[index]).instance()
	add_child(level)
	add_child(player)
	player.reset()
	move_child(level, 0)
	add_child(info_gui)
	transition.transition_out()
	yield(transition.anim, "animation_finished")
	remove_child(transition)

func _unhandled_input(event):
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
