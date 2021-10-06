extends Camera2D

var playerOrbs = []

func _process(delta):
	# amount of orbs can vary, so need to get them every time
	playerOrbs = get_tree().get_nodes_in_group("player")
	
	if !playerOrbs.empty():
		# get positions and sizes
		var posTotal = Vector2.ZERO
		var sizeTotal = 1
		for orb in playerOrbs:
			posTotal += orb.position
			sizeTotal += orb.size
		
		# position camera in middle of player orbs by taking the average position
		position = posTotal / len(playerOrbs)
		
		# zoom camera by total size of all player orbs
		var z = sizeTotal * 0.6
		z /= (100 + sizeTotal * 4) / 100 # zoom in a bit when bigger
		zoom.x = lerp(zoom.x, z, 0.05)
		zoom.y = lerp(zoom.y, z, 0.05)
		
		# bird view for testing
		if Input.is_action_pressed("ui_page_up"):
			zoom = Vector2(12, 12)
