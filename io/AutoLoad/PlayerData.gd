extends Node

var NeuralNetwork = load("res://MachineLearning/NeuralNetwork.gd")

signal score_updated
signal player_died

var color = Color8(0,0,255,255) # blauw
var playerName = "name" setget set_name
var score = 0 setget set_score

var nn = NeuralNetwork.new([4,16,16,2]) # neural network
var nn_inputs = [] # data about playfield and player to use as input for neural network

func reset():
	score = 0

func set_name(value: String):
	value = value.strip_escapes() # remove unwanted escape characters
	value = value.strip_edges() # trim white spaces / unprintable
	if !value.empty() and value != " ":
		playerName = value
	else:
		playerName = "name"

func set_score(value: int):
	score = value
	if score < 0:
		score = 0
	emit_signal("score_updated")

func set_nn_inputs(data):
	nn_inputs = data # width, height, amount of food and amount of enemies
	print(nn.feed_forward(nn_inputs))

func die(elapsed_time):
	var targets = [score, elapsed_time]
	nn.train(nn_inputs, targets)
	
	emit_signal("player_died")

func save():
	return nn.to_dict()

func load_data(data):
	nn = NeuralNetwork.from_dict(data)
