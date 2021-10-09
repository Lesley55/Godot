extends Node

var Matrix = load("res://MachineLearning/Matrix.gd")

func _ready():
	# testing
	var m = Matrix.new(2,2)
	print(m.data)
	m.random()
	print(m.data)
	m.add(2)
	print(m.data)
	m.multiply(2)
	print(m.data)
	
	var m2 = Matrix.new(2,2)
	m2.add(2)
	print(m2.data)
	m.add(m2)
	print(m.data)
	m.multiply(m2)
	print(m.data)
