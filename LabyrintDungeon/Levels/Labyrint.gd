extends Node2D

# signal, const, enum, export var, public var, private _var

signal layout_generated
#signal ground_generated
#signal other_generated
#signal enemies_generated
signal map_generated
signal generating_ended

# tile size in pixels
const layout_tile_size = 3
const maze_tile_size = 32

# binary representation of walls on a tile, total of 0 for no walls, up to 16 for all 4 walls
const N = 1
const E = 2
const S = 4
const W = 8

# vectors pointing in directions
const cell_walls = {Vector2(0, -1): N, Vector2(1, 0): E, Vector2(0, 1): S, Vector2(-1, 0): W}

export(int, 1, 50) var maze_width = 16 # width of map in tiles
export(int, 1, 50) var maze_height = 9 # height of map in tiles
export(int, 3, 33) var chunk_size = 9 # 1 tile in maze_layout converts to chunk_size of tiles in maze
export(bool) var watch_generation_process = false
export(bool) var watch_generation_process_fast = true

#onready var nav = $Navigation2D
onready var mazeLayout = $MazeLayout
onready var progressBar = $Loading/Panel/ProgressBar
onready var camera = $Camera2D

var maze = null
var ground = null

var start_pos = Vector2.ZERO
var end_pos = Vector2.RIGHT

func _ready():	
	# scale layout to same size as maze
	mazeLayout.scale = Vector2(maze_tile_size / layout_tile_size * chunk_size, maze_tile_size / layout_tile_size * chunk_size)
	camera.zoom = Vector2(maze_tile_size * maze_width * chunk_size / get_viewport().size.x, maze_tile_size * maze_height * chunk_size / get_viewport().size.y)
	
	progressBar.value = 0
	randomize() # reseeds global random generater (i think)
	generate_layout()

func check_neighbors(cell, unvisited):
	# returns an array of cell's unvisited neighbors
	var list = []
	for n in cell_walls.keys():
		if cell + n in unvisited:
			list.append(cell + n)
	return list

func generate_layout():
	var unvisited = []  # array of unvisited tiles
	var stack = []
	# fill the map with solid tiles
	mazeLayout.clear()
	for x in range(maze_width):
		for y in range(maze_height):
			unvisited.append(Vector2(x, y))
			mazeLayout.set_cellv(Vector2(x, y), N|E|S|W) # operator | is bit samenvoegen, 0001+0100=0101, N|E|S|W = 15
	var current = Vector2(randi() % maze_width, randi() % maze_height)
	start_pos = current
	unvisited.erase(current)
	
	var furthest = 0 # dead end
	var total :float = unvisited.size() + 1 # layout generation amount for progress bar
	while unvisited:
		if watch_generation_process_fast:
			if unvisited.size() % 10 == 0:
				yield(get_tree(), 'idle_frame')
		progressBar.set_value((total - unvisited.size()) / total * 50)
		
		var neighbors = check_neighbors(current, unvisited)
		if neighbors.size() > 0:
			var next = neighbors[randi() % neighbors.size()]
			stack.append(current)
			# remove walls from *both* cells
			var dir = next - current
			var current_walls = mazeLayout.get_cellv(current) - cell_walls[dir]
			var next_walls = mazeLayout.get_cellv(next) - cell_walls[-dir]
			mazeLayout.set_cellv(current, current_walls)
			mazeLayout.set_cellv(next, next_walls)
			current = next
			unvisited.erase(current)
		elif stack:
			if stack.size() > furthest:
				furthest = stack.size()
				end_pos = current
			current = stack.pop_back()
		if furthest == 0: # no dead ends
			end_pos = current
		
		if watch_generation_process:
			yield(get_tree(), 'idle_frame')
	
	emit_signal("layout_generated")

func generate_map():
	if watch_generation_process_fast:
		yield(get_tree(), 'idle_frame')
		yield(get_tree(), 'idle_frame')
	
	var before :float = progressBar.value
	for x in range(maze_width):
		progressBar.set_value(before + float(x) / maze_width * (100 - before))
		if watch_generation_process_fast:
			yield(get_tree(), 'idle_frame')
		for y in range(maze_height):
			generate_chunk(x, y)
			if watch_generation_process:
				yield(get_tree(), 'idle_frame')
	
	ground.update_dirty_quadrants()
	emit_signal("map_generated")

func generate_chunk(x, y):
	var x_pos = chunk_size * x
	var y_pos = chunk_size * y
	for i in range(chunk_size):
		for j in range(chunk_size):
			ground.set_cellv(Vector2(x_pos + i, y_pos + j), 0)
	
#	corners
	ground.set_cellv(Vector2(x_pos, y_pos), 1)
	ground.set_cellv(Vector2(x_pos + chunk_size - 1, y_pos), 1)
	ground.set_cellv(Vector2(x_pos, y_pos + chunk_size - 1), 1)
	ground.set_cellv(Vector2(x_pos + chunk_size - 1, y_pos + chunk_size - 1), 1)
	
#	create walls, this could be done better
	var tile_index = mazeLayout.get_cellv(Vector2(x, y))
	if tile_index - W >= 0:
		tile_index -= W
		for i in range(chunk_size):
			ground.set_cellv(Vector2(x_pos, y_pos + i), 1)
	if tile_index - S >= 0:
		tile_index -= S
		for i in range(chunk_size):
			ground.set_cellv(Vector2(x_pos + i, y_pos + chunk_size - 1), 1)
	if tile_index - E >= 0:
		tile_index -= E
		for i in range(chunk_size):
			ground.set_cellv(Vector2(x_pos + chunk_size - 1, y_pos + i), 1)
	if tile_index - N >= 0:
		tile_index -= N
		for i in range(chunk_size):
			ground.set_cellv(Vector2(x_pos + i, y_pos), 1)


func _on_layout_generated():
#	mazeLayout.hide()
	
	maze = load("res://Levels/Maze.tscn")
	maze = maze.instance()
	get_tree().get_root().add_child(maze) # simultaneous scene, dont forget to free current one
	get_tree().set_current_scene(maze)
	maze = get_tree().get_root().get_node("Maze")
	ground = get_tree().get_root().get_node("Maze/Navigation2D/Ground")
	connect("generating_ended", maze, "_on_generating_ended")
	
	generate_map()

func _on_map_generated():
	progressBar.value = 100
	
	var player = get_tree().get_root().get_node("Maze/Navigation2D/Player")
	var end = get_tree().get_root().get_node("Maze/Navigation2D/end_pos")
	
	# position in middle of chunk, int chunk /2 first will round to position on tilemap grid, put /2 at end for middle pixel instead
	var mid = Vector2(chunk_size / 2 * maze_tile_size, chunk_size / 2 * maze_tile_size)
	
	player.position = start_pos * chunk_size * maze_tile_size + mid
	end.position = end_pos * chunk_size * maze_tile_size + mid
	
	queue_free()
	emit_signal("generating_ended")
