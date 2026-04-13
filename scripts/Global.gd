extends Node

var score_pleyer1 = 0
var score_pleyer2 = 0
var level_start_score_player1 = 0
var level_start_score_player2 = 0
var players_started_level = 0
var players_dead_in_level = 0

var coop_camera_enabled = true
var coop_max_separation_x = 380.0

var _coop_camera: Camera2D
var _last_scene: Node
var _tracked_scene: Node
var _current_level_path := ""
var _resetting_game := false


func _ready() -> void:
	process_priority = 1000


func _physics_process(delta: float) -> void:
	var scene := get_tree().current_scene
	if scene == null:
		return

	_track_level_state(scene)

	if not coop_camera_enabled:
		return

	if scene != _last_scene:
		_last_scene = scene
		_configure_coop_camera()

	if _coop_camera == null or not is_instance_valid(_coop_camera):
		_configure_coop_camera()

	var players := _get_players()
	if players.is_empty():
		return

	if players.size() == 1:
		_update_single_player_camera(players[0])
		return

	var p1 := players[0]
	var p2 := players[1]

	_update_coop_camera(p1, p2)
	_apply_tether_x(p1, p2)


func _track_level_state(scene: Node) -> void:
	if scene == _tracked_scene:
		return

	_tracked_scene = scene
	_current_level_path = scene.scene_file_path
	level_start_score_player1 = score_pleyer1
	level_start_score_player2 = score_pleyer2
	players_started_level = _get_players().size()
	players_dead_in_level = 0
	_resetting_game = false


func restart_game_to_level_1() -> void:
	if _resetting_game:
		return

	_resetting_game = true
	score_pleyer1 = 0
	score_pleyer2 = 0
	get_tree().call_deferred("change_scene_to_file", "res://scenes/level_1.tscn")


func restore_player_score(player_name: String) -> void:
	if player_name == "Player2":
		score_pleyer2 = level_start_score_player2
	else:
		score_pleyer1 = level_start_score_player1


func register_player_death(player_name: String) -> void:
	restore_player_score(player_name)
	if players_started_level <= 0:
		return

	players_dead_in_level = min(players_dead_in_level + 1, players_started_level)


func should_reload_level_after_death() -> bool:
	return players_started_level > 0 and players_dead_in_level >= players_started_level


func reload_current_level() -> void:
	if _resetting_game or _current_level_path.is_empty():
		return

	_resetting_game = true
	get_tree().call_deferred("change_scene_to_file", _current_level_path)


func get_required_finishers() -> int:
	return max(players_started_level - players_dead_in_level, 0)


func _get_players() -> Array[Node2D]:
	var result: Array[Node2D] = []
	for n in get_tree().get_nodes_in_group("Player"):
		if n is Node2D:
			result.append(n)

	result.sort_custom(func(a: Node2D, b: Node2D) -> bool:
		return a.name < b.name
	)
	return result


func _configure_coop_camera() -> void:
	_coop_camera = null
	var scene := get_tree().current_scene
	if scene == null:
		return

	var players := _get_players()
	for p in players:
		var cam := p.get_node_or_null("Camera2D")
		if cam is Camera2D:
			_coop_camera = cam
			break

	if _coop_camera == null:
		return

	_coop_camera.top_level = true
	_coop_camera.make_current()


func _update_coop_camera(p1: Node2D, p2: Node2D) -> void:
	if _coop_camera == null:
		return

	var midpoint := (p1.global_position + p2.global_position) * 0.5
	_coop_camera.global_position = midpoint


func _update_single_player_camera(player: Node2D) -> void:
	if _coop_camera == null:
		return

	_coop_camera.global_position = player.global_position


func _apply_tether_x(p1: Node2D, p2: Node2D) -> void:
	var left := p1
	var right := p2
	if left.global_position.x > right.global_position.x:
		left = p2
		right = p1

	var separation := right.global_position.x - left.global_position.x
	if separation <= coop_max_separation_x:
		return

	right.global_position.x = left.global_position.x + coop_max_separation_x
