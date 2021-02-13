extends TextureProgress

func _ready():
	get_tree().get_root().get_node("Main/Player").connect("life_updated", self, "life_updated")

func life_updated(life):
	value = life
