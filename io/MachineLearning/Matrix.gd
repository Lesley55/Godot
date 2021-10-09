extends Node

class_name Matrix

var Self = load("res://MachineLearning/Matrix.gd")

var data = []
var rows = 0
var columns = 0

func _init(rows, columns):
	self.rows = rows
	self.columns = columns
	
	for i in rows:
		data.append([])
		for j in columns:
			data[i].append(0)

func random():
	randomize()
	for i in rows:
		for j in columns:
			data[i][j] = rand_range(0,10)

func add(other):
	if other is Self:
		for i in rows:
			for j in columns:
				data[i][j] += other.data[i][j]
	else:
		for i in rows:
			for j in columns:
				data[i][j] += other;

func multiply(other):
	if other is Self:
		for i in rows:
			for j in columns:
				data[i][j] *= other.data[i][j]
	else:
		for i in rows:
			for j in columns:
				data[i][j] *= other;
