extends Label

func _ready():
	get_tree().get_root().get_node("Main/Player").connect("time_updated", self, "time_updated")

func time_updated(new_time):
	text = str(new_time).pad_zeros(3)
