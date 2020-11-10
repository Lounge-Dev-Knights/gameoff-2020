extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var AsteroidLifeTime = 30.0

# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(AsteroidLifeTime), "timeout")
	free()
	
func explode():
	#$AnimationPlayer.play("explode")
	queue_free()

func dissappear(node = Node2D):
	
	$Tween.interpolate_property($Sprite,"scale",$Sprite.scale,Vector2(0,0),1,Tween.TRANS_CUBIC,Tween.EASE_OUT,0.2)
	$Tween.interpolate_property(self,"global_position",global_position, node.position, 2,Tween.TRANS_CUBIC,Tween.EASE_OUT,0)
	$Tween.start()
	yield($Tween,"tween_all_completed")
	print("ASS HAS BEEN EXTERMINATED")
	
