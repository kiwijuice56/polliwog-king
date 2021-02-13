extends TextureButton

func _ready():
	connect("pressed", self, "pressed")

func pressed():
	disabled = true
