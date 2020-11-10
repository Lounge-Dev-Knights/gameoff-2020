extends Node

const POOL_SIZE = 8

const sounds = {
	"MenuButtonSound":preload("res://Sounds/MenuButtonSound.wav"),
	"MoonImpact":preload("res://Sounds/MoonImpact.wav"),
	"Wurmhole":preload("res://Sounds/wurmhole.wav"),
	"Reset":preload("res://Sounds/Reset.wav"),
}

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(POOL_SIZE):
		var player = AudioStreamPlayer.new()
		add_child(player)
		
		
func _get_idle_player():
	for player in get_children():
		if not (player as AudioStreamPlayer).playing:
			return player

func play_sound(sound_name: String):
	var audio_player: AudioStreamPlayer = _get_idle_player()
	audio_player.stream = sounds[sound_name]
	audio_player.play()
	
