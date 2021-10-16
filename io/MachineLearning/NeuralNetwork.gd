extends Node

class_name NeuralNetwork
# instead of making a lot of perceptrons, somehow connecting and training them all,
# store their values and weights in matrices and use matrix math to calculate the outcome,
# this is more efficient and makes it easier to adjust values or see what a certain layer does

var Matrix = load("res://MachineLearning/Matrix.gd")

# number of nodes in each layer
var number_of_nodes = []

# matrix of weights for connections between nodes
var weights_input_to_hidden = null
var weights_hidden_to_output = null

## matrix of weights for bias connections
#var weights_bias_hidden = null
#var weights_bias_output = null

var weights = []

var learning_rate = 0.1 # decide size of adjustments, if bigger, learns faster, but will also overshoot more

# shape the neural network
func _init(array):
	# number of nodes in each layer
	number_of_nodes = array
	
	# give a weight for every connection
	weights_input_to_hidden = Matrix.new(number_of_nodes[1], number_of_nodes[0])
	weights_hidden_to_output = Matrix.new(number_of_nodes[2], number_of_nodes[1])
	weights_input_to_hidden.random()
	weights_hidden_to_output.random()
	
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
	
	# hidden value is weighted sum of all inputs times weights
	var hidden = Matrix.dot(weights_input_to_hidden, inputs)
	# let outputs of the hidden layer pass through activation function
	hidden.activation()

	# output value is weighted sum of all hidden values times weights
	var outputs = Matrix.dot(weights_hidden_to_output, hidden)
	# let outputs of the output layer pass through activation function
	outputs.activation()
	
#	# weighted sum of inputs current layer and weights to next layer, gives the output/value of nodes in next layer
#	var outputs = null
#	for i in len(weights):
#		outputs = Matrix.dot(weights[i], inputs)
#		outputs.activation()
#		inputs = outputs.copy() # output of current layer is used as input for next layer
	
	# return outputs (values of last layer)
	return outputs.to_array()

# supervised learning
# adjust the weights based on the known answers of certain inputs
func train(inputs, targets):
	var layers_nodes_values = []
	
#	var outputs = feed_forward(inputs) # get outputs array
	
	# litterally copied feed_forward function instead of using it
	# because i need matrix values of the hidden layers to adjust the weights
	inputs = Matrix.from_array(inputs)
	var hidden = Matrix.dot(weights_input_to_hidden, inputs)
	hidden.activation()
	var outputs = Matrix.dot(weights_hidden_to_output, hidden)
	outputs.activation()
	
#	var outputs = null
#	for i in len(weights):
#		outputs = Matrix.dot(weights[i], inputs)
#		outputs.activation()
#		inputs = outputs.copy()
#		layers_nodes_values.append(outputs) # remember values of nodes
	
	# turn array into matrix so i can perform matrix math
#	outputs = Matrix.from_array(outputs) # this step became unnecessary
	targets = Matrix.from_array(targets)
	
	### backpropagation ###
	
	# calculate error: difference between output and target
	var output_errors = targets
	output_errors.subtract(outputs) # note: not static, this changes matrix

	# ToDo: loop over multiple hidden layers
	# turn matrix for going backwards through neural network layers
	var weights_hidden_output_transposed = weights_hidden_to_output.transpose()
	# calculate previous/hidden layer errors
	var hidden_errors = Matrix.dot(weights_hidden_output_transposed, output_errors)

	# calculate delta's: amount weights should change by
	# slope of activation function * errors * learningrate
	var gradients_output = outputs.copy()
	gradients_output.derivative()
	gradients_output.multiply(output_errors)
	gradients_output.multiply(learning_rate)

	# gradients for next layer
	var gradients_hidden = hidden.copy()
	gradients_hidden.derivative()
	gradients_hidden.multiply(hidden_errors)
	gradients_hidden.multiply(learning_rate)

	# change weights hidden to output layer
	hidden = hidden.transpose() # turn for backwards
	var weights_hidden_to_output_delta = Matrix.dot(gradients_output, hidden)
	weights_hidden_to_output.add(weights_hidden_to_output_delta)

	# change weights input to hidden layer
	inputs = inputs.transpose() # turn for backwards
	var weights_input_to_hidden_delta = Matrix.dot(gradients_hidden, inputs)
	weights_input_to_hidden.add(weights_input_to_hidden_delta)
	
	
#	# calculate error: difference between output and target
#	var errors = targets
#	errors.subtract(outputs)
#
#	# go backwards through the layers
#	for i in range(len(weights) - 1, -1, -1):
#		# calculate delta's: amount weights should change by
#
#		# slope of activation function at value of node * errors * learningrate
#		var gradients = layers_nodes_values[i].copy()
#		gradients.derivative()
#		gradients.multiply(errors)
#		gradients.multiply(learning_rate)
#
#		# turn matrix for going backwards through neural network layers
#		var layer_nodes_values_transposed = layers_nodes_values[i].transpose()
#		# use gradient to calculate delta using all connections to node
#		var weights_delta = Matrix.dot(gradients, layer_nodes_values_transposed)
#
#		# change weights of layer
#		weights[i].add(weights_delta)
#
#		# there is no known output/target for the nodes before the output that you can use tot change the weights,
#		# node influences output by weight devided by total weights to that output
#		# so you can calculate how much that previous node contributed to the current error
#		# which you can use as the error of that node to continue backwards
#		if i > 0:
#			var weights_transposed = weights[i].transpose() # turn for backwards
#			# calculate previous layer errors
#			errors = Matrix.dot(weights_transposed, errors)
