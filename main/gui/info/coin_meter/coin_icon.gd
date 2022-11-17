extends Node

onready var label = $Label

func _ready():
	get_tree().get_root().get_node("Main/Player").connect("coins_updated", self, "coins_updated")

func coins_updated(coins):
	label.text = str(coins).pad_zeros(2)
