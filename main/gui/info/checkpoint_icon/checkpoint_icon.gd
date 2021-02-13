extends TextureRect

export var taken_icon : Resource = preload("res://main/gui/info/checkpoint_icon/checkpoint1.png")
export var untaken_icon : Resource = preload("res://main/gui/info/checkpoint_icon/checkpoint2.png")

func _ready():
	get_tree().get_root().get_node("Main/Player").connect("checkpoint_updated", self, "checkpoint_updated")

func checkpoint_updated(taken: bool):
	if taken: texture = taken_icon
	else: texture = untaken_icon
