extends Timer

onready var anim = $AnimationPlayer

func _ready():
	connect("timeout", self, "timeout")

func timeout():
	anim.current_animation = "okay"
	
