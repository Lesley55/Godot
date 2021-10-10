extends Node

var Matrix = load("res://MachineLearning/Matrix.gd")

# not used in game, only for testing

func _ready():
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
