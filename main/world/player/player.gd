extends KinematicBody2D

export var jump_height := -100.0
export var max_jump_steps := 12
export var speed := 60.0
export var gravity := 12.0
export var invincibility := 2.0

export var size_step := 1
export var max_size_steps := 3

export var tongue_delay := .4
export var tongue_offset := 6.0

var can_move = true
var vel := Vector2()
var dir := Vector2(1,0)
var jump_steps := 0
var tongue = preload("res://main/world/player/tongue/TongueTip.tscn").instance()
var level_finished = preload("res://main/gui/level_finish/LevelFinish.tscn")

var life := 4.0 setget life_updated
var checkpoint_gotten := false setget checkpoint_updated
var coins := 0 setget coins_updated
var saved_coins := 0
var score := 0 setget score_updated
var saved_score := 0
var time := 255 setget time_updated

signal life_updated(life)
signal checkpoint_updated(value)
signal coins_updated(coins)
signal score_updated(score)
signal time_updated(time)

onready var anim := $AnimationPlayer
onready var sprite := $Sprite
onready var hurt_timer := $HurtTimer
onready var tongue_timer := $TongueTimer
onready var timer := $Timer
onready var effects := $HurtEffect
onready var mouth := $Mouth
onready var audio_stream := $AudioStreamPlayer
onready var checkpoint
onready var startingpoint

### Setter functions
func life_updated(new_life):
	emit_signal("life_updated", new_life)
	if new_life <= 0: death()
	elif new_life >= 4: new_life = 4
	if life > new_life:
		effects.emitting = true
		audio_stream.play_sound("hurt")
		hurt_timer.start(invincibility)
		hurt_timer.anim.current_animation = "hurt"
	life = new_life

func checkpoint_updated(new_value):
	checkpoint_gotten = new_value
	emit_signal("checkpoint_updated", checkpoint_gotten)

func coins_updated(new_coins):
	coins = new_coins
	emit_signal("coins_updated", coins)

func score_updated(new_score):
	score = new_score
	emit_signal("score_updated", score)

func time_updated(new_time):
	time = round(new_time)
	emit_signal("time_updated", time)
###

#Collisions other than physics
func area_entered_detection(area):
	if area.is_in_group("Damage"):
		if not hurt_timer.is_stopped():
			return
		self.life -= area.damage
		if area.is_in_group("Bullet"):
			area.queue_free()
	elif area.is_in_group("Checkpoint") and not checkpoint_gotten:
		self.checkpoint_gotten = true
		saved_score = score
		area.taken()
	elif area.is_in_group("Coin"):
		self.coins += area.value
		self.score += area.score
		area.collect()
	elif area.is_in_group("Heart"):
		self.life += area.value
		self.score += area.score
		area.collect()
	elif area.is_in_group("Goal"):
		can_move = false
		vel = Vector2()
		timer.stop()
		var level_finished_scene = level_finished.instance()
		add_child(level_finished_scene)
		level_finished_scene.finish(score, time)
		yield(level_finished_scene, "done")
		saved_score = level_finished_scene.score
		saved_coins = coins
		get_parent().next_level()
		self.checkpoint_gotten = false
		level_finished_scene.queue_free()

func body_entered_mouth(body):
	if tongue.attached == body and tongue.forward == false:
		eat(body)

func eat(body):
	body.queue_free()
	self.score += body.score
	audio_stream.play_sound("eat")
	tongue.attached = null

func spit_tongue():
	tongue.position = Vector2()
	tongue.attached = null
	if not dir.y == 0:
		tongue.dir = Vector2(0, dir.y)
	else:
		tongue.dir = dir
	if not dir.y == 0:
		tongue.position.y -= tongue_offset
		tongue.position.x += (dir.x * tongue_offset)
	tongue.orientation = -dir.x
	tongue.offset = tongue_offset
	add_child(tongue)
	tongue.start()
	mouth.get_child(0).disabled = false

func tongue_back():
	mouth.get_child(0).disabled = true

func reset():
	self.life = 4
	self.coins = saved_coins
	self.score = saved_score
	self.time = 255
	timer.start(time)
	can_move = true
	if checkpoint_gotten:
		global_position = get_parent().level.get_node("Checkpoint").global_position
		get_parent().level.get_node("Checkpoint/AnimationPlayer").current_animation = "taken"
	else:
		global_position = get_parent().level.get_node("Startingpoint").global_position

#Resets state
func death():
	can_move = false
	get_parent().switch_level(get_parent().current_level_index)
	yield(get_parent(), "transition_done")
	reset()

#Handles animation
func animation():
	if vel.x:
		if dir.y == -1:
			anim.current_animation = "run_up"
		else:
			anim.current_animation = "run"
	else:
		if dir.y == -1:
			anim.current_animation = "idle_up"
		else:
			anim.current_animation = "idle"
	if not tongue_timer.is_stopped():
		return
	if dir.x == 1:
		sprite.scale.x = 1
		mouth.scale.x = 1
	elif dir.x == -1:
		sprite.scale.x = -1
		mouth.scale.x = -1

#Used for holding for higher jumps
func check_pressed_jumps():
	if jump_steps > 0 and jump_steps <= max_jump_steps:
		if Input.is_action_pressed("jump"):
			vel.y += jump_height/jump_steps
			jump_steps += 1

#Takes in input
func _input(event):
	vel.x = 0
	dir.y = 0
	if not can_move:
		animation()
		return
	if Input.is_action_pressed("run_right"):
		vel.x += 1 * speed
		dir.x = 1
	if Input.is_action_pressed("run_left"):
		vel.x -= 1 * speed
		dir.x = -1
	if Input.is_action_pressed("look_up"):
		dir.y = -1
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump_steps = 1
		audio_stream.play_sound("jump")
	#Flip sprites before shoot can lock direction
	animation()
	if Input.is_action_just_pressed("shoot") and tongue_timer.is_stopped():
		tongue_timer.start(tongue_delay)
		spit_tongue()
	if Input.is_action_just_pressed("reset"):
		self.life = 0

func _ready():
	$Detection.connect("area_entered", self, "area_entered_detection")
	$Mouth.connect("body_entered", self, "body_entered_mouth")
	$TongueTimer.connect("timeout", self, "tongue_back")
	$Timer.connect("timeout", self, "death")

#Main Loop
func _physics_process(delta):
	self.time = timer.time_left
	vel.y += gravity
	check_pressed_jumps()
	move_and_slide(vel, Vector2(0, -1))
	if is_on_floor():
		jump_steps = 0
		vel.y = 0
	if is_on_ceiling():
		vel.y -= vel.y/2
