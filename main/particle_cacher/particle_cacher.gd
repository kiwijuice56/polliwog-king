extends Node2D
export (Array, Resource) var materials

func _ready():
	global_position = Vector2(1000,1000) 
	for material in materials:
		var particles_instance = Particles2D.new()
		particles_instance.set_process_material(material)
		particles_instance.set_one_shot(true)
		particles_instance.set_emitting(true)
		self.add_child(particles_instance)
