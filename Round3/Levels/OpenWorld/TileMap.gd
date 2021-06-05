extends TileMap

const CHUNK_SIZE = 8
const TILE_SIZE = 32 # in pixels

const ELEVATION_SIZE = 64
const MOISTURE_SIZE = 256

var elevation_noise = OpenSimplexNoise.new()
var moisture_noise = OpenSimplexNoise.new()

var map_data = {}
var loaded_chunks = []

var player = null

func _ready():
	randomize()
	elevation_noise.seed = randi()
	moisture_noise.seed = randi()
	elevation_noise.octaves = 1
	moisture_noise.octaves = 1
	elevation_noise.period = ELEVATION_SIZE
	moisture_noise.period = MOISTURE_SIZE
	
#	GameSaver.load_map(1)
	update_map()

func _process(delta):
	if Input.is_action_just_pressed("reload_map"):
		for chunk in loaded_chunks:
			# clear tiles on tilemap
			for x in range(CHUNK_SIZE):
				for y in range(CHUNK_SIZE):
					var tilemap_x = x + chunk.x * CHUNK_SIZE
					var tilemap_y = y + chunk.y * CHUNK_SIZE
					set_cell(tilemap_x, tilemap_y, -1)
		loaded_chunks = []
		map_data = {}
		
		elevation_noise.seed = randi()
		moisture_noise.seed = randi()
	
	update_map()

# maybe change to use a second Thread, so player won't notice
func update_map():
	if player != null:
		# get current chunk from player position
		var current_chunk_x = int(player.position.x / TILE_SIZE / CHUNK_SIZE)
		var current_chunk_y = int(player.position.y / TILE_SIZE / CHUNK_SIZE)
		
		# for chunk to draw, load or generate chunk
		for chunk_x in range(current_chunk_x - 3, current_chunk_x + 4): # 3 chunks on both x sides of player
			for chunk_y in range(current_chunk_y - 2, current_chunk_y + 3): # 2 chunks on both y sides of player
				var chunk = Vector2(chunk_x, chunk_y)
				if !loaded_chunks.has(chunk):
					loaded_chunks.append(chunk)
					if map_data.has(var2str(chunk)):
						_load_chunk(chunk)
					else:
						_generate_chunk(chunk)
		
		# remove chunks from tilemap that are to far away
		_remove_chunks(Vector2(current_chunk_x, current_chunk_y))
		
		update_bitmask_region(Vector2(0,0), get_viewport_rect().end)

func _load_chunk(chunk):
	# draw chunk from map_data to tilemap
	var tiles = map_data[var2str(Vector2(chunk.x, chunk.y))]
	var x = 0
	var y = 0
	for index in tiles:
		var tilemap_x = x + chunk.x * CHUNK_SIZE
		var tilemap_y = y + chunk.y * CHUNK_SIZE
		set_cell(tilemap_x, tilemap_y, index)
		y += 1
		if y >= CHUNK_SIZE:
			y = 0
			x +=1

func _generate_chunk(chunk):
	# generate chunk with simplex noise
	for x in range(CHUNK_SIZE):
		for y in range(CHUNK_SIZE):
			var tilemap_x = x + chunk.x * CHUNK_SIZE
			var tilemap_y = y + chunk.y * CHUNK_SIZE
			
			var elevation = (elevation_noise.get_noise_2d(tilemap_x, tilemap_y) + 1) * 0.5
			var moisture = (moisture_noise.get_noise_2d(tilemap_x, tilemap_y) + 1) * 0.5
			
			var biome = _get_biome(elevation, moisture)
			
			set_cell(tilemap_x, tilemap_y, tile_set.find_tile_by_name(biome))
	
	# update auto tiles in chunk region
#	var chunk_pos_top_left = Vector2(chunk.x * CHUNK_SIZE, chunk.y * CHUNK_SIZE)
#	var chunk_pos_bottom_right = Vector2(chunk.x * CHUNK_SIZE + CHUNK_SIZE, chunk.y * CHUNK_SIZE + CHUNK_SIZE)
#	update_bitmask_region(chunk_pos_top_left, chunk_pos_bottom_right)
	
	_save_chunk(chunk) ########################################

func _get_biome(elevation, moisture):
	if (elevation < 0.1):
		return "OCEAN"
	elif (elevation < 0.12):
		return "BEACH"
	elif (elevation > 0.8):
		if (moisture < 0.1):
			return "SCORCHED";
		elif (moisture < 0.2):
			return "BARE";
		elif (moisture < 0.5):
			return "TUNDRA";
		else:
			return "SNOW";
	if (elevation > 0.6):
		if (moisture < 0.33):
			return "TEMPERATE_DESERT";
		if (moisture < 0.66):
			return "SHRUBLAND";
		return "TAIGA";
	if (elevation > 0.3):
		if (moisture < 0.16):
			return "TEMPERATE_DESERT";
		if (moisture < 0.50):
			return "GRASSLAND";
		if (moisture < 0.83):
			return "TEMPERATE_DECIDUOUS_FOREST";
		return "TEMPERATE_RAIN_FOREST";
	if (moisture < 0.16):
		return "SUBTROPICAL_DESERT";
	if (moisture < 0.33):
		return "GRASSLAND";
	if (moisture < 0.66):
		return "TROPICAL_SEASONAL_FOREST";
	else:
		return "TROPICAL_RAIN_FOREST";

func _remove_chunks(current_chunk):
	# remove loaded chunks that are to far away from current chunk
	for chunk in loaded_chunks:
		var dist = chunk - current_chunk
		# distance around player on each side in update_map() + 1 
		# (+1 so if moving on the edge of chunk, not infinitely adding and removing)
		if dist.x < -4 || 4 < dist.x || dist.y < -3 || 3 < dist.y:
			loaded_chunks.remove(loaded_chunks.find(chunk))
			# clear tiles on tilemap
			for x in range(CHUNK_SIZE):
				for y in range(CHUNK_SIZE):
					var tilemap_x = x + chunk.x * CHUNK_SIZE
					var tilemap_y = y + chunk.y * CHUNK_SIZE
					set_cell(tilemap_x, tilemap_y, -1)

#func _notification(what):
#	# save game when tilemap exits tree/scene
#	if what == NOTIFICATION_EXIT_TREE:
#		GameSaver.save_map(1)

func save():
	# give back data to save, which is then saved to file by GameSaver
	_save_loaded_chunks()
	var save_dict = {}
	save_dict["elevation_noise_seed"] = elevation_noise.seed
	save_dict["moisture_noise_seed"] = moisture_noise.seed
	save_dict["map"] = map_data
	return save_dict

# maybe change to only save changed chunks as generate will always be same with saved seed, so dont need to save unchanged parts of the map
func _save_loaded_chunks():
	# save every chunk currently loaded on tilemap
	for chunk in loaded_chunks:
		_save_chunk(chunk)

func _save_chunk(chunk):
	# save chunk to local var map_data
	var chunk_map = []
	for x in range(CHUNK_SIZE):
		for y in range(CHUNK_SIZE):
			var tilemap_x = x + chunk.x * CHUNK_SIZE
			var tilemap_y = y + chunk.y * CHUNK_SIZE
			chunk_map.push_back(get_cell(tilemap_x, tilemap_y))
	map_data[var2str(chunk)] = chunk_map

func load_data(data):
	# get save file data from GameSaver
	elevation_noise.seed = data["elevation_noise_seed"]
	moisture_noise.seed = data["moisture_noise_seed"]
	map_data = data["map"]
	update_map() # change to update complete map instead of just new tiles, maybe different function
