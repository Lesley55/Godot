extends Node

# just for the concept of how perceptrons work
# this class is not used in the game / neural network
class_name Perceptron

var weights = []
var learningRate = 0.1 # decide size of adjustments, if bigger, learns faster, but will also overshoot more

# constructor
func _init():
	randomize() # set randomizer seed
	# random weight for every input, simple example, so only 2
	for i in range(2):
		weights.append(rand_range(-1, 1))

# use inputs and their weights to guess the outcome
func guess(inputs):
	# get weighted sum
	var sum = 0
	for i in len(weights):
		sum += inputs[i] * weights[i]
	# only return -1 or 1
	var output = sign(sum)
	return output

# training the perceptron: adjusting the weights
func train(inputs, target):
	var guess = guess(inputs)
	# use known answer to calculate the error
	var error = target - guess
	
	# change the weights
	for i in len(weights):
		weights[i] += error * inputs[i] * learningRate
		# using input\ because for both weights the error and learning curve will be the same,
		# changing the weight by the same amount will not change the outcome of guess,
		# you want the weights for the inputs to change by a different amount so they can vary
