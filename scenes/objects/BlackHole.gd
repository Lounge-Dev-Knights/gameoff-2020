extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_BlackHole_body_entered(body):
	if body.has_method("dissappear"):
		body.dissappear(self)
		
