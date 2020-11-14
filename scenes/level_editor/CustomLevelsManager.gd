extends PanelContainer


const CUSTOM_LEVELS_PATH = "user://levels/"


onready var levels_list = $MarginContainer/HBoxContainer/CustomLevels
onready var export_text_dialog = $ExportTextDialog


var selected_level: String


# Called when the node enters the scene tree for the first time.
func _ready():
	load_custom_levels()
	
	get_tree().connect("files_dropped", self, "_on_files_dropped")


func get_levelname_from_path(path: String) -> String:
	var regex = RegEx.new()
	regex.compile("(.+/)(.+)(.json)")
	var result = regex.search(path)
	
	return result.strings[2]
	


func load_custom_levels():
	levels_list.clear()
	
	var dir = Directory.new()
	var err = dir.open(CUSTOM_LEVELS_PATH)
	
	dir.list_dir_begin(true)
	var next = dir.get_next()
	
	while next != "":
		if next.ends_with(".json"):
			var level_name = get_levelname_from_path(CUSTOM_LEVELS_PATH + next)
			
			# load preview image
			var preview: Image = Image.new()
			var e = preview.load(CUSTOM_LEVELS_PATH + level_name + ".png")
			
			# create texture
			var texture = ImageTexture.new()
			texture.create_from_image(preview)
			
			# add level to list
			levels_list.add_item(level_name, texture)
		next = dir.get_next()
		
	dir.list_dir_end()


func delete_level(level: String):
	var dir = Directory.new()
	var error = dir.remove(level)
	print("Delete %s. Error: %d" %[level, error])
	load_custom_levels()


func export_level(level: String, destination: String):
	var dir = Directory.new()
	var error = dir.copy(level, destination)
	print("export %s to %s. Error: %d" % [level, destination, error])


# Download the level as json file in HTML5 runtimes
# javascript downloadcode from volzotan; https://stackoverflow.com/a/30800715
# CC BY-SA 4.0 - https://creativecommons.org/licenses/by-sa/4.0/
func download_level(level: String):
	var file_name = level.get_file()
	var file = File.new()
	var error = file.open(level, File.READ)
	# TODO evaluate error
	
	var level_data = file.get_as_text()
	
	var export_script = """
			function downloadObjectAsJson(exportObj, exportName) {
				var dataStr = 'data:text/json;charset=utf-8,' + encodeURIComponent(exportObj);
				var downloadAnchorNode = document.createElement('a');
				downloadAnchorNode.setAttribute('href', dataStr);
				downloadAnchorNode.setAttribute('download', exportName);
				document.body.appendChild(downloadAnchorNode); // required for firefox
				downloadAnchorNode.click();
				downloadAnchorNode.remove();
			}
			
			downloadObjectAsJson('%s', '%s');
		""" % [level_data, file_name]
		
	JavaScript.eval(export_script)



func import_level(file_path: String) -> void:
	var dir = Directory.new()
	# var file_name = file_path.substr(file_path.find_last("/"))
	var file_name = file_path.get_file()
	
	var error = dir.copy(file_path, CUSTOM_LEVELS_PATH + file_name)
	print("export %s to %s. Error: %d" % [file_path, CUSTOM_LEVELS_PATH + file_name, error])
	


func _on_CustomLevels_item_selected(index):
	$ContextMenu.popup_centered_minsize()
	$ContextMenu.rect_position = get_global_mouse_position() + Vector2(5, 5)
	selected_level = CUSTOM_LEVELS_PATH + levels_list.get_item_text(index) + ".json"


func _on_CustomLevels_item_activated(index):
	selected_level = CUSTOM_LEVELS_PATH + levels_list.get_item_text(index) + ".json"
	SceneLoader.goto_scene("res://scenes/Game.tscn", {"level_path": selected_level})


func _on_Play_pressed() -> void:
	SceneLoader.goto_scene("res://scenes/Game.tscn", {"level_path": selected_level})


func _on_Edit_pressed() -> void:
	SceneLoader.goto_scene("res://scenes/level_editor/LevelEditor.tscn", {"level_path": selected_level})


func _on_Rename_pressed() -> void:
	$RenameFileDialog.popup_centered()
	$RenameFileDialog.dialog_text = "Rename %s to:" % get_levelname_from_path(selected_level)
	$RenameFileDialog/HBoxContainer2/LineEdit.text = get_levelname_from_path(selected_level)


func _on_Export_pressed() -> void:
	if OS.has_feature("HTML5"):
		download_level(selected_level)
	else:
		$ExportFileDialog.popup_centered()


func _on_Delete_pressed() -> void:
	$DeleteConfirmationDialog.popup_centered()


func _on_DeleteConfirmationDialog_confirmed() -> void:
	delete_level(selected_level)


func _on_ExportFileDialog_file_selected(destination: String) -> void:
	export_level(selected_level, destination)


func _on_NewLevel_pressed():
	var dir = Directory.new()
	var i = 1
	while dir.file_exists("user://levels/Untitled Level " + str(i) + ".json"):
		i += 1
	SceneLoader.goto_scene("res://scenes/level_editor/LevelEditor.tscn", {"level_path": "user://levels/Untitled Level " + str(i) + ".json"})


func _on_Import_pressed():
	$ImportDialog.popup_centered()


func _on_ImportFileDialog_file_selected(path):
	import_level(path)


func _on_Back_pressed():
	SceneLoader.goto_scene("res://scenes/title_screen/TitleScreen.tscn")


func _on_PopupPanel_about_to_show():
	$AnimationPlayer.play("open_popup")


func _on_RenameFileDialog_confirmed():
	var dir = Directory.new()
	dir.rename(selected_level, CUSTOM_LEVELS_PATH + $RenameFileDialog/HBoxContainer2/LineEdit.text + ".json")
	load_custom_levels()


func _on_ExportText_pressed():
	var file = File.new()
	file.open(selected_level, File.READ)
	export_text_dialog.get_node("VBoxContainer/TextEdit").text = Marshalls.utf8_to_base64(file.get_as_text())
	
	export_text_dialog.popup_centered()


func _on_files_dropped(files: Array, screen: int):
	for f in files:
		import_level(f)
	$ImportDialog.hide()
	load_custom_levels()


func _on_CopyToClipboard_pressed():
	OS.set_clipboard(export_text_dialog.get_node("VBoxContainer/TextEdit").text)
	export_text_dialog.get_node("VBoxContainer/HBoxContainer/CopyToClipboard").text = "Copied!"


func _on_ExportText_Close_pressed():
	export_text_dialog.hide()


func _on_button_mouse_entered():
	SoundEngine.play_sound("MenuButtonHoverSound")


func _on_button_pressed():
	SoundEngine.play_sound("MenuButtonSound")
	$ContextMenu.hide()



func _on_ImportDialog_level_imported():
	load_custom_levels()
