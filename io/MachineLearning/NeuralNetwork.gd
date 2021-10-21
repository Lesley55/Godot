extends Node

class_name NeuralNetwork
# instead of making a lot of perceptrons, somehow connecting and training them all,
# store their values and weights in matrices and use matrix math to calculate the outcome,
# this is more efficient and makes it easier to adjust values or see what a certain layer does

var Matrix = load("res://MachineLearning/Matrix.gd")

var _number_of_nodes = [] # number of nodes in each layer

# matrices of weights
var _weights = [] # weights/connections between nodes
var _biases = [] # weights for biases

var learning_rate = 0.1 # decide size of adjustments, if bigger, learns faster, but will also overshoot more

# shape the neural network
func _init(array):
	# number of nodes in each layer
	_number_of_nodes = array
	
	# give a weight for every connection between the nodes of the layers
	for i in range(len(_number_of_nodes) - 1):
		# new weight matrix based on size of current and next layer
		var weights_to_next_layer = Matrix.new(_number_of_nodes[i+1], _number_of_nodes[i])
		weights_to_next_layer.random() # give a random weight
		_weights.append(weights_to_next_layer) # add to weights array
		
		# new bias matrix based on size of next layer
		var bias_weights = Matrix.new(_number_of_nodes[i+1], 1)
		bias_weights.random() # give a random weight
		_biases.append(bias_weights) # add to bias weights array

# use inputs to calculate the values of the nodes in the next layer
# do the same with the value of previous layer for every layer in the neural network
func feed_forward(arr):
	# error handling
	if len(arr) != _number_of_nodes[0]:
		print("amount of inputs should equal that of neural network")
		return
	
	# turn inputs array into matrix
	var inputs = Matrix.from_array(arr)
	
	# weighted sum of inputs current layer and weights to next layer, gives the output/value of nodes in next layer
	var outputs = null
	for i in len(_weights):
		# weighted sum of all inputs times weights
		outputs = Matrix.dot(_weights[i], inputs)
		# add bias (instead of creating a new bias input node and then using the bias + weights dot product, just straight up add the biases
		outputs.add(_biases[i])
		# let outputs pass through activation function
		outputs.activation()
		# output of current layer is used as input for next layer
		inputs = outputs.copy()
	
	# return outputs (values of last layer)
	return outputs.to_array()

# supervised learning
# adjust the weights based on the known answers of certain inputs
func train(inputs, targets):
	# error handling
	if len(inputs) != _number_of_nodes[0] or len(targets) != _number_of_nodes[-1]:
		print("amount of inputs and targets(outputs) should equal that of neural network")
		return
	
	# turn array into matrix so i can perform matrix math
	inputs = Matrix.from_array(inputs)
	targets = Matrix.from_array(targets)
	
	# values of each layer
	var layers_nodes_values = []
	layers_nodes_values.append(inputs) # inputs are values of first layer
	
	# litterally copied feed_forward function instead of using it
	# because i need matrix values of the hidden layers to adjust the weights
	var outputs = null
	for i in len(_weights):
		outputs = Matrix.dot(_weights[i], inputs)
		outputs.add(_biases[i])
		outputs.activation()
		inputs = outputs.copy()
		layers_nodes_values.append(outputs) # remember values of layer nodes
	
	### backpropagation ###
	
	# calculate error: difference between output and target
	var errors = [targets]
	errors[0].subtract(outputs)
	
	# go backwards through the layers to calculate the errors
	for i in range(len(_weights) - 1, 0, -1):
		# there is no known output/target for the nodes before the output layer that you can use tot change the weights,
		# node influences output by weight devided by total weights to that output
		# so you can calculate how much that previous node contributed to the current error
		# which you can use as the error of that node
		var weights_transposed = _weights[i].transpose() # turn for backwards
		# calculate previous layer errors
		var prev_errors = Matrix.dot(weights_transposed, errors[0])
		# add errors to beginning of array, because we need them to stand backwards
		errors.push_front(prev_errors)
	
	# go backwards through the layers to calculate delta's: amount weights should change by
	for i in range(len(_weights) - 1, -1, -1):
		# slope of activation function at value of node * errors * learningrate
		var gradients = layers_nodes_values[i+1].copy()
		gradients.derivative()
		gradients.multiply(errors[i])
		gradients.multiply(learning_rate)
		
		# turn matrix for going backwards through neural network layers
		var layer_nodes_values_transposed = layers_nodes_values[i].transpose()
		# use gradient to calculate delta using all connections to node
		var weights_delta = Matrix.dot(gradients, layer_nodes_values_transposed)
		
		# change weights of layer
		_weights[i].add(weights_delta)
		# change biases by deltas: just the gradients
		_biases[i].add(gradients)

# turn all classes into array/dictionary data, so we can save it as json
func to_dict():
	var dict = {} # new dictionary
	dict["number_of_nodes"] = _number_of_nodes
	
	var weights_array = []
	for i in _weights:
		var matrix = {}
		matrix["rows"] = i.rows
		matrix["columns"] = i.columns
		matrix["data"] = i.data
		weights_array.append(matrix)
	dict["weights"] = weights_array
	
	var biases_array = []
	for i in _biases:
		var matrix = {}
		matrix["rows"] = i.rows
		matrix["columns"] = i.columns
		matrix["data"] = i.data
		biases_array.append(matrix)
	dict["biases"] = biases_array
	
	dict["learning_rate"] = learning_rate
	
	return dict

static func from_dict(data):
	# workaround
	var Matrix = load("res://MachineLearning/Matrix.gd")
	var Self = load("res://MachineLearning/NeuralNetwork.gd")
	
	var nn = Self.new(data["number_of_nodes"]) # new neural network
	
	# get matrices
	var weights_array = data["weights"]
	for i in len(weights_array):
		var matrix = Matrix.new(weights_array[i]["rows"], weights_array[i]["columns"])
		matrix.data = weights_array[i]["data"]
		nn._weights[i] = matrix # bad code, accessing (what should be) a private var
	
	var biases_array = data["biases"]
	for i in len(biases_array):
		var matrix = Matrix.new(biases_array[i]["rows"], biases_array[i]["columns"])
		matrix.data = biases_array[i]["data"]
		nn._biases[i] = matrix # bad code, accessing (what should be) a private var
	
	nn.learning_rate = data["learning_rate"]
	
	return nn
