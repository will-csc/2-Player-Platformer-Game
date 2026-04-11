extends StaticBody2D

var life = 3


func _on_area_2d_area_entered(area: Area2D) -> void:
	
	if area.get_parent().is_in_group("Player"):
		$AnimatedSprite2D.play("Hit")
		life -= 1
		area.get_parent().velocity.y = -500
		if life <=0:
			
			$CPUParticles2D.restart()
			$AnimatedSprite2D.queue_free()
			$CollisionShape2D.queue_free()
			$Area2D.queue_free()
			
			await get_tree().create_timer(1).timeout
			
			queue_free()
	
	
	pass # Replace with function body.
