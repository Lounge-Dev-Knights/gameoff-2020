extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var AsteroidLifeTime = 30.0

# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(AsteroidLifeTime), "timeout")
	queue_free()

func explode():
	
	linear_velocity = linear_velocity*0
	mass = 0
	gravity_scale = 0.1
	#get_tree().call_group("cameras", "add_trauma", 0.15) #Screen shake
	SoundEngine.play_sound("MoonImpact")
	$AsteroidExplosion.play("AsteroidExplosion")
	yield($AsteroidExplosion,"animation_finished") 
	queue_free()

func disappear(node = Node2D):
	
	$Tween.interpolate_property($Sprite,"scale",$Sprite.scale,Vector2(0,0),1,Tween.TRANS_CUBIC,Tween.EASE_OUT,0.2)
	$Tween.interpolate_property(self,"global_position",global_position, node.position, 2,Tween.TRANS_CUBIC,Tween.EASE_OUT,0)
	$Tween.start()
	yield($Tween,"tween_all_completed")

	
