extends Node

class_name Matrix

var Self = load("res://MachineLearning/Matrix.gd")

var data = []
var rows = 0
var columns = 0

# create matrix
func _init(rows, columns):
	self.rows = rows
	self.columns = columns
	# fill matrix with zero's
	for i in rows:
		data.append([])
		for j in columns:
			data[i].append(0)

func random():
	randomize()
	# give a random value to every item in the matrix
	for i in rows:
		for j in columns:
			data[i][j] = rand_range(0,10)

func add(other):
	if other is Self: # if also a matrix
		# add each value in matrix to corresponding value from other matrix
		for i in rows:
			for j in columns:
				data[i][j] += other.data[i][j]
	else:
		# add number to all values in matrix
		for i in rows:
			for j in columns:
				data[i][j] += other;

func multiply(other):
	if other is Self: # if also a matrix
		# mutiply each value in matrix by corresponding value from other matrix
		for i in rows:
			for j in columns:
				data[i][j] *= other.data[i][j]
	else:
		# multiply each value in matrix by number
		for i in rows:
			for j in columns:
				data[i][j] *= other;
