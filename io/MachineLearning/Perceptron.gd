extends Node

# just for the concept of how perceptrons work
# this class is not used in the game / neural network
class_name Perceptron

var weights = []

func _init():
	randomize() # set randomizer seed
	# random weight for every input, simple example, so only 2
	for i in range(2):
		weights.append(rand_range(-1, 1))

func guess(inputs):
	# get weighted sum
	var sum = 0
	for i in len(weights):
		sum += inputs[i] * weights[i]
	# only return -1 or 1 to simplify
	var output = sign(sum)
	return output
