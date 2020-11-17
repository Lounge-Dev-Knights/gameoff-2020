extends Node


# where the settings will be stored
const SETTINGS_FILENAME: String = "user://settings.json"


###
# define settings and (if needed) setters/getters
###
var master_volume: float = 1 setget _set_master_volume
var sound_volume: float = 1 setget _set_sound_volume
var music_volume: float = 1 setget _set_music_volume


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(_get_properties_to_persist())


# load settings from file
func _enter_tree() -> void:
	var save_file: File = File.new()
	if save_file.file_exists(SETTINGS_FILENAME):
		var error: int = save_file.open(SETTINGS_FILENAME, File.READ)
		
		if error == OK:
			var save_text: String = save_file.get_as_text()
			var save_dict = parse_json(save_text)
			
			if save_dict is Dictionary:
				for key in save_dict.keys():
					set(key, save_dict[key])
			else:
				var backup_filename = SETTINGS_FILENAME + ".bak"
				printerr("Settings file could not be parsed. Content (%s) is copied to %s." % [save_text, backup_filename])
				
				# backup settings file, to recover if important settings should not be overwritten with default
				var dir = Directory.new()
				var copy_error = dir.copy(SETTINGS_FILENAME, backup_filename)
				if copy_error != OK:
					printerr("Settings file copied. Reason: %d" % copy_error)
		else:
			printerr("Settings file couldn't be opened. Reason: %d" % error)
			
	# if settings-file doesn't exist yet, make sure every setter is called once anyway
	else:
		for property in _get_properties_to_persist():
			set(property, get(property))


# save settings before game is closed
func _exit_tree() -> void:
	var settings_file: File = File.new()
	# TODO: handle file errors
	var error: int = settings_file.open(SETTINGS_FILENAME, File.WRITE)
	
	if error == OK:
		var save_dict: Dictionary = {}
		
		# collect properties that should be persisted
		for property in _get_properties_to_persist():
			save_dict[property] = get(property)
		
		settings_file.store_line(to_json(save_dict))
	else:
		printerr("Settings file couldn't be written. Reason: %d" % error)


# get properties that should be persisted
# this works by checking for the usage flag PROPERTY_USAGE_SCRIPT_VARIABLE
# which will be set for all defined "var" in this file
func _get_properties_to_persist() -> Array:
	var properties_to_persist: Array = []
	
	for property in get_property_list():
		if property["usage"] == PROPERTY_USAGE_SCRIPT_VARIABLE:
			properties_to_persist.append(property["name"])
	
	return properties_to_persist


####
# define setters an getters below
# Example: set the volume of the Audiobus, every time the volume settings is set
###

# set soundeffect volume on AudioServer
func _set_sound_volume(new_value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sound Vol"), linear2db(new_value))
	sound_volume = new_value

# set music volume on AudioServer
func _set_music_volume(new_value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music Vol"), linear2db(new_value))
	music_volume = new_value

# set master volume on AudioServer
func _set_master_volume(new_value: float) -> void:
	var sound_vol = AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(new_value))
	master_volume = new_value
