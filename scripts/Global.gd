extends Node

var score_pleyer1 = 0
var score_pleyer2 = 0

var coop_camera_enabled = true
var coop_max_separation_x = 380.0

var _coop_camera: Camera2D
var _last_scene: Node
var _resetting_game := false


func _ready() -> void:
	process_priority = 1000


func _physics_process(delta: float) -> void:
	var scene := get_tree().current_scene
	if scene == null:
		return

	_maybe_restart_game_on_level_3_death_line(scene)

	if not coop_camera_enabled:
		return

	if scene != _last_scene:
		_last_scene = scene
		_configure_coop_camera()

	var players := _get_players()
	if players.size() < 2:
		return

	var p1 := players[0]
	var p2 := players[1]

	_update_coop_camera(p1, p2)
	_apply_tether_x(p1, p2)


func _maybe_restart_game_on_level_3_death_line(scene: Node) -> void:
	if _resetting_game:
		return

	if scene.scene_file_path != "res://scenes/level_3.tscn":
		return

	var death_line := scene.get_node_or_null("DeathLine")
	if not (death_line is Node2D):
		return

	for p in _get_players():
		if p.global_position.y > death_line.global_position.y:
			restart_game_to_level_1()
			return


func restart_game_to_level_1() -> void:
	if _resetting_game:
		return

	_resetting_game = true
	score_pleyer1 = 0
	score_pleyer2 = 0
	get_tree().call_deferred("change_scene_to_file", "res://scenes/level_1.tscn")


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
