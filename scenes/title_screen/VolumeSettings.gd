extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	$Music/Music.value = Settings.music_volume
	$Sound/Sound.value = Settings.sound_volume
	$Mute/CheckBox.pressed = Settings.master_volume == 0
	
	$Sound/Sound.connect("value_changed", self, "_sound_check")

func _on_Music_value_changed(value):
	Settings.music_volume = value


func _on_Sound_value_changed(value):
	Settings.sound_volume = value


func _sound_check(_new_value):
	if not $SoundVolCheck.playing:
		$SoundVolCheck.play()
	$SoundCheckTimer.start()


func _on_SoundCheckTimer_timeout():
	$SoundVolCheck.stop()


func _on_mutus_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		$Mute/CheckBox.pressed = !$Mute/CheckBox.pressed


func _on_CheckBox_toggled(button_pressed: bool) -> void:
	Settings.master_volume = 0 if button_pressed else 1
