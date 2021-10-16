extends Node

# just for the concept of how perceptrons work
# this class is not used in the game / neural network
class_name Perceptron

var weights = []
var learningRate = 0.1 # decide size of adjustments, if bigger, learns faster, but will also overshoot more

# if input = 0, no mather the weight, times 0 will always output 0,
# undesired output and training won't change weights, so to prevent this, add a bias
const bias = 1

# constructor
func _init(n): # n amount of inputs
	randomize() # set randomizer seed
	# random weight for every input
	for _i in range(n + 1): # +1 weight for the bias
		weights.append(rand_range(-1, 1))

# use inputs and their weights to guess the outcome
func guess(inputs):
	inputs.append(bias) # add bias
	
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
	var error = target - guess # use known answer to calculate the error
	
	# change the weights
	for i in len(weights):
		weights[i] += error * inputs[i] * learningRate
		# using inputs because for both weights the error and learning curve will be the same,
		# changing the weight by the same amount will not change the outcome of guess,
		# you want the weights for the inputs to change by a different amount so they can vary
