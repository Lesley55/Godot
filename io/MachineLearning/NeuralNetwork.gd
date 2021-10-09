extends Node

class_name NeuralNetwork
# instead of making a lot of perceptrons, somehow connecting and training them all,
# store their values and weights in matrices and use matrix math to calculate the outcome,
# this is more efficient and makes it easier to adjust values

var Matrix = load("res://MachineLearning/Matrix.gd")

var inputs = null
var hidden = null
var outputs = null

# shape the neural network
func _init(inputs, hidden_layers, outputs):
	self.inputs = inputs
	self.hidden = hidden_layers
	self.outputs = outputs
