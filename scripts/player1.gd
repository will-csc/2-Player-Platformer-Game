extends CharacterBody2D

var speed = 160.0
var dir

var jump_velocity = -300.0
var gravity = 980

var extra_jumps = 1

@onready var anim = $Player/AnimatedSprite2D
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
		dir = Input.get_axis("Left_Player1","Right_Player1")
	
	if dir:
		velocity.x = dir * speed
	elif dir == 0:
		velocity.x = 0
	
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if Input.is_action_just_pressed("Jump_Player1") and extra_jumps > 0 and is_alive:
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
		remove_from_group("Player")
		Global.register_player_death(name)
		anim.play("Hit")
		
		$CollisionShape2D.queue_free()
		$Area2D/CollisionShape2D.queue_free()
		velocity.y = jump_velocity - 30
		
		
		await  get_tree().create_timer(1).timeout
		
		if Global.should_reload_level_after_death():
			Global.reload_current_level()
		else:
			queue_free()
	
	pass
