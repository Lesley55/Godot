extends Node

const SAVE_FOLDER = "user://saves"
const MAP_FOLDER = "user://maps"
var SAVE_NAME_TEMPLATE = "save_%03d.json" # dat, tres, json
var MAP_NAME_TEMPLATE = "map_%03d.json"
const _ENCRYPT_PASS = "encrypypa"

#var current_save_id : int # maybe an idea?

# maybe change to use a second Thread, so player won't notice

func save_game(id : int):
	var save_dict = _get_data_to_save("save")
	_make_directory(SAVE_FOLDER) # make if it doesn't exist
	var save_path = SAVE_FOLDER.plus_file(SAVE_NAME_TEMPLATE % id)
	_save_to_file(save_path, save_dict)
	
	save_map(id)

func save_map(id : int):
	var save_dict = _get_data_to_save("save_map")
	_make_directory(MAP_FOLDER) # make if it doesn't exist
	var save_path = MAP_FOLDER.plus_file(MAP_NAME_TEMPLATE % id)
	_save_to_file(save_path, save_dict)

func load_game(id : int):
	var save_path = SAVE_FOLDER.plus_file(SAVE_NAME_TEMPLATE % id)
	_load_to_game(save_path)
	
	load_map(id)

func load_map(id : int):
	var save_path = MAP_FOLDER.plus_file(MAP_NAME_TEMPLATE % id)
	_load_to_game(save_path)


func _get_data_to_save(group : String):
	# calls save() on every node in group and combines data to dictionary
	var save_dict = {}
	var nodes_to_save = get_tree().get_nodes_in_group(group)
	for node in nodes_to_save:
		save_dict[node.get_path()] = node.save()
	return save_dict

func _make_directory(path : String):
	# creates a directory if it doesn't exist yet
	var directory = Directory.new()
	if !directory.dir_exists(path):
		directory.make_dir_recursive(path)

func _save_to_file(save_path : String, save_dict : Dictionary):
	var file = File.new()
	var err = file.open(save_path, File.WRITE)
#	var err = file.open_encrypted_with_pass(save_path, File.WRITE, _ENCRYPT_PASS)
	if err == OK:
		file.store_line(to_json(save_dict))
		file.close()
		print("Saved to %s" % save_path)
	else:
		print("There was an issue writing the save to %s" % save_path)

func _load_to_game(save_path : String):
	var file = File.new()
	if !file.file_exists(save_path):
		print("Save file %s doesn't exist" % save_path)
		return
	
	var err = file.open(save_path, File.READ)
#	var err = file.open_encrypted_with_pass(save_path, File.READ, _ENCRYPT_PASS)
	if err == OK:
		var data = {}
		data = parse_json(file.get_as_text())
		file.close()
		
		for node_path in data.keys():
			var node = get_node(node_path)
			node.load_data(data[node_path])
#			for attribute in data[node_path]:
#				if attribute == "pos":
#					node.set_pos(Vector2(data[node_path]["pos"]["x"], data[node_path]["pos"]["y"]))
#				else:
#					node.set(attribute, data[node_path][attribute])
		print("Loaded %s" % save_path)
	else:
		print("There was an issue reading the save at %s" % save_path)
