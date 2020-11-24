extends Area2D

var type: String = "Text"

var text: String = "text" setget  _set_text


func get_additional_properties():
	return {"text": text}


func _set_text(new_text):
	text = new_text
	$Label.text = text
