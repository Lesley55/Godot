extends Node2D

const BushEffect = preload("res://Effects/BushEffect.tscn")

func bush_effect():
	var bushEffect = BushEffect.instance()
	get_parent().add_child(bushEffect)
	bushEffect.global_position = $Sprite.global_position

func _on_Hurtbox_area_entered(_area):
	PlayerData.score += 1
	bush_effect()
	queue_free()
