extends Label

func _ready():
	get_tree().get_root().get_node("Main/Player").connect("score_updated", self, "score_updated")
	score_updated(0)

func score_updated(new_score):
	text = str(new_score).pad_zeros(6)
