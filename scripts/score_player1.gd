extends Label

func _process(delta: float) -> void:
	
	text = "Player 1: " + str(Global.score_pleyer1)
