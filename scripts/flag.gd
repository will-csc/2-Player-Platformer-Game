extends Area2D

@export_file("*.tscn") var next_level_path: String
@export var required_players := 2

var _players_in_flag := {}
var _changing_scene := false

func _ready() -> void:
	if not area_entered.is_connected(_on_area_entered):
		area_entered.connect(_on_area_entered)
	if not area_exited.is_connected(_on_area_exited):
		area_exited.connect(_on_area_exited)
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	if not body_exited.is_connected(_on_body_exited):
		body_exited.connect(_on_body_exited)

	_players_in_flag.clear()
	_changing_scene = false


func _process(delta: float) -> void:
	_update_and_maybe_change_scene()

func _get_player_from_trigger(trigger: Node) -> Node:
	if trigger == null:
		return null
	if trigger is Area2D:
		return trigger.get_parent()
	return trigger


func _update_and_maybe_change_scene() -> void:
	if _changing_scene:
		return

	var alive_finishers := Global.get_required_finishers()
	var current_required_players := required_players
	if alive_finishers > 0:
		current_required_players = min(required_players, alive_finishers)
	if current_required_players <= 0:
		return

	if _players_in_flag.size() < current_required_players:
		return

	if next_level_path.is_empty():
		push_error("Flag.next_level_path não está definido.")
		return

	_changing_scene = true
	get_tree().call_deferred("change_scene_to_file", next_level_path)


func _on_area_entered(area: Area2D) -> void:
	var player := _get_player_from_trigger(area)
	if player != null and player.is_in_group("Player"):
		_players_in_flag[player] = true
		player.remove_from_group("Player")
		player.queue_free()
		_update_and_maybe_change_scene()


func _on_area_exited(area: Area2D) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	var player := _get_player_from_trigger(body)
	if player != null and player.is_in_group("Player"):
		_players_in_flag[player] = true
		player.remove_from_group("Player")
		player.queue_free()
		_update_and_maybe_change_scene()

func _on_body_exited(body: Node2D) -> void:
	pass
