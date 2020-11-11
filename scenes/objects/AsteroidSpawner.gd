extends Area2D

export var velocityFactor = 100
export var AsteroidLifecycleTime = 30.0
export(int, "Up", "Down", "Left", "Right") var direction
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var type = "AsteroidSpawner"

# Called when the node enters the scene tree for the first time.
func _ready():
	if SceneLoader.current_scene.name == "LevelEditor":
		$Line2D.visible = true
		_draw()
	else:
		$Line2D.visible = false
	_load_asteroid()
	pass # Replace with function body.

func _draw():
	if SceneLoader.current_scene.name == "LevelEditor":
		draw_circle(Vector2(0,0), 15, Color(1.0, 1.0, 1.0, 1.0))
	
func _load_asteroid():
	
	var ass = preload("res://scenes/objects/Astroids.tscn").instance()
	ass.AsteroidLifeTime = AsteroidLifecycleTime 
	
	add_child(ass)
	if direction == 0:
		$Line2D.rotation_degrees = 0
		ass.linear_velocity = Vector2(rand_range(-5,5)*velocityFactor/100, rand_range(-200,-300)*velocityFactor/100)
	if direction == 1:
		$Line2D.rotation_degrees = 180
		ass.linear_velocity = Vector2(rand_range(-5,5)*velocityFactor/100, rand_range(200,300)*velocityFactor/100)
	if direction == 2:
		$Line2D.rotation_degrees = 270
		ass.linear_velocity = Vector2(rand_range(-200,-300)*velocityFactor/100, rand_range(-5,5)*velocityFactor/100)
	if direction == 3:
		$Line2D.rotation_degrees = 90
		ass.linear_velocity = Vector2(rand_range(200,300)*velocityFactor/100, rand_range(-5,5)*velocityFactor/100)
	
		
	#ass.linear_velocity = Vector2(rand_range(-1,2)*velocityFactor/100, rand_range(10,15)*velocityFactor/100)
func get_additional_properties():
	return {"direction": direction}
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	_load_asteroid()
	pass # Replace with function body.
