extends Label

func _ready():
	get_tree().get_root().get_node("Main/Player").connect("score_updated", self, "score_updated")

func score_updated(new_score):
	text = "Score: " + str(new_score).pad_zeros(6)
