extends VBoxContainer

var LEADERBOARDITEM = preload("res://UI/LeaderboardItem.tscn")

const LENGTH = 15
var _data = []
var current_score = {}

onready var scoreList = $ScoreList

func save():
	current_score = {
		playerName = PlayerData.playerName, 
		color = PlayerData.color.to_html(false), # get hex value without alpha
		score = PlayerData.score
	}
	_data.append(current_score)
	return _data

func load_data(data):
	_data = data

func update_leaderboard():
	GameSaver.load_game(1)
	var sorted = _sort_leaderboard(_data)
	var size = len(sorted)
	if size > LENGTH:
		size = LENGTH
	for i in size:
		var n = LEADERBOARDITEM.instance()
		add_child(n)
		n.get_node("Name").text = sorted[i].playerName
		n.get_node("Name").modulate = Color(sorted[i].color)
		n.get_node("Score").text = str(sorted[i].score)
#		if sorted[i] == current_score: # doesn't work because type changes
		if sorted[i].playerName == current_score.playerName and sorted[i].color == current_score.color and sorted[i].score == current_score.score:
			n.get_node("Score").modulate = Color(sorted[i].color)

func _sort_leaderboard(list):
	list.sort_custom(MyCustomSorter, "sort")
	return list

class MyCustomSorter:
	static func sort(a, b):
		if a["score"] > b["score"]:
			return true
		return false
