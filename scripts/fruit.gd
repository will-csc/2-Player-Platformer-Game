extends Area2D

func _on_area_entered(area: Area2D) -> void:
	
	var player := area.get_parent()
	if player == null:
		return

	if player.is_in_group("Player"):
		$AnimatedSprite2D.play("Collect")
		$CollisionShape2D.queue_free()
		
		if player.name == "Player2":
			Global.score_pleyer2 += 1
		else:
			Global.score_pleyer1 += 1
		
		await get_tree().create_timer(1).timeout
		
		queue_free()
