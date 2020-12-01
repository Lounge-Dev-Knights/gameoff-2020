extends PopupPanel


onready var video = $VBoxContainer/VideoPlayer
onready var description = $VBoxContainer/Label


func show_god_preview(stream: Resource, preview_description: String) -> void:
	video.stream = stream
	video.play()
	description.text = preview_description
	popup_centered_minsize()


func _on_VideoPlayer_finished():
	video.play()
	

func _on_GodPreview_popup_hide():
	video.stop()
