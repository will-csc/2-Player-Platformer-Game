extends CharacterBody2D

var speed = 160.0
var dir

var jump_velocity = -300.0
var gravity = 980

var extra_jumps = 1

@onready var anim = $AnimatedSprite2D
@onready var death_line = $"../DeathLine"

var is_alive = true

func _ready() -> void:	
		
	pass
	
func _physics_process(delta: float) -> void:
	
	move(delta)
	
	if is_alive:
		animations ()
	
	pass
	
func move (delta):
	
	if is_alive:
		dir = Input.get_axis("Left_Player2","Right_Player2")
	
	if dir:
		velocity.x = dir * speed
	elif dir == 0:
		velocity.x = 0
	
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if Input.is_action_just_pressed("Jump_Player2") and extra_jumps > 0 and is_alive:
		velocity.y = jump_velocity
		if extra_jumps > 0:
			extra_jumps -= 1
	
	if is_on_floor():
		extra_jumps = 1
		
	if global_position.y > death_line.global_position.y and is_alive:
		die()
	
	move_and_slide()
	
	pass
	
func animations ():
	
	if velocity.x != 0 and is_on_floor():
		anim.play("Run")
	elif velocity.x == 0 and is_on_floor():
		anim.play("Idle")
	elif not is_on_floor() and extra_jumps >= 1:
		anim.play("Jump")
		
	if dir > 0:
		anim.flip_h = false
	elif dir < 0:
		anim.flip_h = true
	pass

func die():
	
	if is_alive:
	
		is_alive = false
		anim.play("Hit")
		
		$CollisionShape2D.queue_free()
		$Area2D/CollisionShape2D.queue_free()
		velocity.y = jump_velocity - 30
		
		
		await  get_tree().create_timer(1).timeout
		
		Global.score_pleyer1 = 0
		Global.score_pleyer2 = 0
		get_tree().change_scene_to_file("res://scenes/level_1.tscn")
	
	pass
