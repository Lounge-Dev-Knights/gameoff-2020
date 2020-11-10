extends Node2D

export var velocityFactor = 100
export var AsteroidLifecycleTime = 30.0
export(int, "Up", "Down", "Left", "Right") var direction
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _load_asteroid():
	
	var ass = preload("res://scenes/objects/Astroids.tscn").instance()
	ass.AsteroidLifeTime = AsteroidLifecycleTime 
	add_child(ass)
	if direction == 0:
		ass.linear_velocity = Vector2(rand_range(-5,5)*velocityFactor/100, rand_range(-200,-300)*velocityFactor/100)
	if direction == 1:
		ass.linear_velocity = Vector2(rand_range(-5,5)*velocityFactor/100, rand_range(200,300)*velocityFactor/100)
	if direction == 2:
		ass.linear_velocity = Vector2(rand_range(-200,-300)*velocityFactor/100, rand_range(-5,5)*velocityFactor/100)
	if direction == 3:
		ass.linear_velocity = Vector2(rand_range(200,300)*velocityFactor/100, rand_range(-5,5)*velocityFactor/100)
	#ass.linear_velocity = Vector2(rand_range(-1,2)*velocityFactor/100, rand_range(10,15)*velocityFactor/100)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	_load_asteroid()
	pass # Replace with function body.
