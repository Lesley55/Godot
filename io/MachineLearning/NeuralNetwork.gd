extends Node

class_name NeuralNetwork
# instead of making a lot of perceptrons, somehow connecting and training them all,
# store their values and weights in matrices and use matrix math to calculate the outcome,
# this is more efficient and makes it easier to adjust values

var Matrix = load("res://MachineLearning/Matrix.gd")

# number of nodes in layer
var n_inputs = 0
var n_hidden = 0
var n_outputs = 0

# matrix of weights for connections between nodes
var weights_input_to_hidden = null
var weights_hidden_to_output = null
# matrix of weights for bias connections
var weights_bias_hidden = null
var weights_bias_output = null

# shape the neural network
func _init(inputs, hidden_nodes, outputs):
	n_inputs = inputs
	n_hidden = hidden_nodes # only one hidden layer for now (ToDo: multiple hidden layers)
	n_outputs = outputs
	
	# give a weight for every connection
	weights_input_to_hidden = Matrix.new(n_hidden, n_inputs)
	weights_hidden_to_output = Matrix.new(n_outputs, n_hidden)
	weights_input_to_hidden.random()
	weights_hidden_to_output.random()
	
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
	# output value is weighted sum of all hidden values times weights
	var outputs = Matrix.dot(weights_hidden_to_output, hidden)
	
	# return output values
	return outputs.to_array()

# supervised learning
# adjust the weights based on the known answers of certain inputs
func train(inputs, targets):
	var outputs = feed_forward(inputs) # get outputs array
	# turn array into matrix so i can perform matrix math
	outputs = Matrix.from_array(outputs)
	targets = Matrix.from_array(targets)
	
	# calculate error: difference between output and target
	var errors = targets.subtract(outputs) # note: not static, this changes targets matrix
	
	
	
