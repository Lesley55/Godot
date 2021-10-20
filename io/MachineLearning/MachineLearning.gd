extends Node

var Perceptron = load("res://MachineLearning/Perceptron.gd")
var Matrix = load("res://MachineLearning/Matrix.gd")
var NeuralNetwork = load("res://MachineLearning/NeuralNetwork.gd")

# not used in game, only for testing

func _ready():
#	test_perceptron()
#	test_matrix()
	test_neural_network()

func test_perceptron():
	print("create perceptron")
	var p = Perceptron.new(2)
	print(p.weights)
	print("train perceptron")
	# learn perceptron to output 1 if first input < second input
	for _i in range(200):
		# random inputs
		var inputs = [rand_range(-1,1), rand_range(-1,1)]
		# answer that should be given
		var target = 0
		if inputs[0] < inputs[1]:
			target = 1
		else:
			target = -1
		var g = p.guess(inputs)
#		print(target, g)
		print(g == target) # print if guessed the right answer
		p.train(inputs, target) # train
#		print(p.weights)
	# starts with a lot of false, after a while, almost all true / good guesses,
	# reason for occasional false is that the learning rate is big, so will overshoot the perfect weight value

func test_matrix():
	print("create matrix")
	var m = Matrix.new(2,2)
	print(m.data)
	print("random")
	m.random()
	print(m.data)
	print("add number")
	m.add(2)
	print(m.data)
	print("multiply number")
	m.multiply(2)
	print(m.data)
	
	print("second random matrix")
	var m2 = Matrix.new(2,2)
	m2.random()
	print(m2.data)
	print("add matrices together")
	m.add(m2)
	print(m.data)
	print("multiply matrices together")
	m.multiply(m2)
	print(m.data)
	
	print("2 new matrices")
	var m3 = Matrix.new(2,3)
	var m4 = Matrix.new(3,2)
	m3.random()
	m4.random()
	print(m3.data)
	print(m4.data)
	print("dot product matrices")
	var m5 = Matrix.dot(m3,m4)
	print(m5.data)
	
	print("transpose matrix")
	var m6 = m5.transpose()
	print(m6.data)
	
	print("array to matrix")
	var arr = [1,2,3]
	var m7 = Matrix.from_array(arr)
	print(m7.data)
	print("matrix to array")
	var reverse = m7.to_array()
	print(reverse)

func test_neural_network():
	print("train neural network")
	var n = NeuralNetwork.new([2,6,6,1])
	# learn neural network to output 1 if first input < second input and other way around for second output
	for _i in range(500):
		var inputs = [rand_range(-1,1), rand_range(-1,1)]
		# answer that should be given
		var target = [0,0]
		if inputs[0] < inputs[1]:
			target = [-1]
		else:
			target = [1]
		
		var outputs = n.feed_forward(inputs)
		
		print(target, outputs)
		yield(get_tree(),"idle_frame") # wait a frame, so i can see al prints, no overflow in console
		
		n.train(inputs, target) # train
