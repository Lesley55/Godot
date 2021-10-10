extends Node

class_name Matrix

# workaround for problem with godot, not aloud to use own name(Matrix) in class file, creates cyclic reference
var Self = load("res://MachineLearning/Matrix.gd") # Self = Matrix

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

func transpose():
	# turn matrix, rows become columns, columns become rows
	var result = Self.new(columns, rows)
	for i in rows:
		for j in columns:
			result.data[i][j] = data[j][i]

# get dot product of / multiply two matrices
static func dot(m1, m2):
	if m1.columns != m2.rows:
		print("first matrix columns should equal second matrix rows")
		return
	
	# workaround, godot has no static var, so cant access var Self in static function, 
	# instead getting Matrix class through param matrix: m1.Self, there might be a better way to do this
	var result = m1.Self.new(m1.rows, m2.columns) # create new matrix
	
	# get new matrix value by using new matrix coördinates as row/column of old matrices,
	# for those coördinates, get sum of (value in m1 row times value in m2 colomn)
	# example:
	# m1 = [[a,b,c]
	#		[d,e,f]]
	# m2 = [[g,h]
	#		[i,j]
	#		[k,l]]
	# result = [[a*g+b*i+c*k, a*h+b*j+c*l]
	#			[d*g+e*i+f*k, d*h+e*j+f*l]]
	for i in m1.rows:
		for j in m2.columns:
			# values in rows of m1 times values in columns of m2
			var sum = 0
			for k in m1.columns:
				sum += m1.data[i][k] * m2.data[k][j]
			
			# put sum in new matrix
			result.data[i][j] = sum
	
	return result
