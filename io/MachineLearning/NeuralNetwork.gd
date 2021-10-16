extends Node

class_name NeuralNetwork
# instead of making a lot of perceptrons, somehow connecting and training them all,
# store their values and weights in matrices and use matrix math to calculate the outcome,
# this is more efficient and makes it easier to adjust values or see what a certain layer does

var Matrix = load("res://MachineLearning/Matrix.gd")

# number of nodes in each layer
var number_of_nodes = []

# matrices of weights for connections between nodes
var weights = []

## matrix of weights for bias connections
#var weights_bias_hidden = null
#var weights_bias_output = null

var learning_rate = 0.1 # decide size of adjustments, if bigger, learns faster, but will also overshoot more

# shape the neural network
func _init(array):
	# number of nodes in each layer
	number_of_nodes = array
	
	# give a weight for every connection between the nodes of the layers
	for i in range(len(number_of_nodes) - 1):
		# new weight matrix based on size of current and next layer
		var weights_to_next_layer = Matrix.new(number_of_nodes[i+1], number_of_nodes[i])
		weights_to_next_layer.random() # give a random weight
		weights.append(weights_to_next_layer) # add to weights array
	
#	# give a weight for every bias
#	weights_bias_hidden = Matrix.new(n_hidden, 1)
#	weights_bias_output = Matrix.new(n_outputs, 1)
#	weights_bias_hidden.random()
#	weights_bias_output.random()

# use inputs to calculate the values of the nodes in the next layer
# do the same with the value of previous layer for every layer in the neural network
func feed_forward(arr):
	# turn inputs array into matrix
	var inputs = Matrix.from_array(arr)
	
	# ToDo: bias
	
	# weighted sum of inputs current layer and weights to next layer, gives the output/value of nodes in next layer
	var outputs = null
	for i in len(weights):
		# weighted sum of all inputs times weights
		outputs = Matrix.dot(weights[i], inputs)
		# let outputs pass through activation function
		outputs.activation()
		# output of current layer is used as input for next layer
		inputs = outputs.copy()
	
	# return outputs (values of last layer)
	return outputs.to_array()

# supervised learning
# adjust the weights based on the known answers of certain inputs
func train(inputs, targets):
	# turn array into matrix so i can perform matrix math
	inputs = Matrix.from_array(inputs)
	targets = Matrix.from_array(targets)
	
	# values of each layer
	var layers_nodes_values = []
	layers_nodes_values.append(inputs) # inputs are values of first layer
	
	# litterally copied feed_forward function instead of using it
	# because i need matrix values of the hidden layers to adjust the weights
	var outputs = null
	for i in len(weights):
		outputs = Matrix.dot(weights[i], inputs)
		outputs.activation()
		inputs = outputs.copy()
		layers_nodes_values.append(outputs) # remember values of nodes
	
	### backpropagation ###
	
	# calculate error: difference between output and target
	var errors = targets
	errors.subtract(outputs)
	
	# go backwards through the layers
	for i in range(len(weights) - 1, -1, -1):
		# calculate delta's: amount weights should change by
		
		# slope of activation function at value of node * errors * learningrate
		var gradients = layers_nodes_values[i+1].copy()
		gradients.derivative()
		gradients.multiply(errors)
		gradients.multiply(learning_rate)
		
		# turn matrix for going backwards through neural network layers
		var layer_nodes_values_transposed = layers_nodes_values[i].transpose()
		# use gradient to calculate delta using all connections to node
		var weights_delta = Matrix.dot(gradients, layer_nodes_values_transposed)
		
		# change weights of layer
		weights[i].add(weights_delta)
		
		# there is no known output/target for the nodes before the output layer that you can use tot change the weights,
		# node influences output by weight devided by total weights to that output
		# so you can calculate how much that previous node contributed to the current error
		# which you can use as the error of that node to continue backwards
		if i > 0:
			var weights_transposed = weights[i].transpose() # turn for backwards
			# calculate previous layer errors
			errors = Matrix.dot(weights_transposed, errors)
