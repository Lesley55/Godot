extends Node

var Perceptron = load("res://MachineLearning/Perceptron.gd")
var Matrix = load("res://MachineLearning/Matrix.gd")
var NeuralNetwork = load("res://MachineLearning/NeuralNetwork.gd")

# not used in game, only for testing

func _ready():
#	test_perceptron()
	test_matrix()
#	test_neural_network()

func test_perceptron():
	# Perceptron test
	var p = Perceptron.new(2)
	print(p.weights)
	# learn perceptron to output 1 if first input < second input
	for i in range(200):
		# random inputs
		var inputs = [rand_range(-1,1), rand_range(-1,1)]
		# answer that should be given
		var target = 0
		if inputs[0] < inputs[1]:
			target = 1
		else:
			target = -1
		var g = p.guess(inputs)
		print(g == target) # print if guessed the right answer
		p.train(inputs, target) # train
#		print(p.weights)
	# starts with a lot of false, after a while, almost all true / good guesses,
	# reason for occasional false is that the learning rate is big, so will overshoot the perfect weight value

func test_matrix():
	# Matrix math test
	var m = Matrix.new(2,2)
	print(m.data)
	m.random()
	print(m.data)
	m.add(2)
	print(m.data)
	m.multiply(2)
	print(m.data)
	
	var m2 = Matrix.new(2,2)
	m2.random()
	print(m2.data)
	m.add(m2)
	print(m.data)
	m.multiply(m2)
	print(m.data)
	
	var m3 = Matrix.new(2,3)
	var m4 = Matrix.new(3,2)
	m3.random()
	m4.random()
	print(m3.data)
	print(m4.data)
	var m5 = Matrix.dot(m3,m4)
	print(m5.data)
	
	var m6 = m5.transpose()
	print(m6.data)
	
	var arr = [1,2,3]
	var m7 = Matrix.from_array(arr)
	print(m7.data)
	var reverse = m7.to_array()
	print(reverse)

func test_neural_network():
	var n = NeuralNetwork.new(2,2,2)
	var inputs = [1,2]
	var outputs = n.feed_forward(inputs)
	print(outputs)
