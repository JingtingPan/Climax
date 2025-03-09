extends CharacterBody2D

@export var speed : float = 100
@export var jump_force : float = 350.0  
@export var gravity : float = 800.0  
@export var dashSpeed : float = 300
@export var dash_duration: float = 0.2
@export var animator : AnimatedSprite2D
@export var climb_speed : float = 100

@onready var ladder_detector = $LadderDetector
var is_attacked = false 
var is_falling_through = false
var is_dashing = false
var is_climbing = false
var can_dash = true  # is the player eligible for dashing
var is_jumping = false
func _ready():
	z_index = 10  # 设置 Z Index 为 10
	z_as_relative = true  # 让它在父节点内保持相对顺序
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float):
	if is_climbing:
		handle_climbing(delta)
		handle_jump()
		
	else:
		apply_gravity(delta)
		handle_movement()
		handle_jump()
		handle_platform_pass_through()
		handle_dash()
	 # 检查玩家是否在梯子附近
	check_ladder_overlap()
	
	update_animation()
	move_and_slide()
	
#add in the gravity
func apply_gravity(delta: float):
	if not is_on_floor():
		velocity.y += gravity * delta
		
# left and right movement

		
func handle_movement():
	if is_dashing:
		return  # no movement control during dashing
		
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed
		animator.flip_h = velocity.x < 0
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	
func handle_climbing(delta: float):
	velocity.x = 0  # no horizontal speed
	if Input.is_action_pressed("up"):
		velocity.y = -climb_speed  # climb up
		if not animator.is_playing() or animator.animation != "climb":
			animator.play("climb")  
	elif Input.is_action_pressed("down"):
		velocity.y = climb_speed  # climb down
		if not animator.is_playing() or animator.animation != "climb":
			animator.play("climb")  
	else:
		velocity.y = 0  # stop climbing
		if not animator.is_playing() or animator.animation != "climb":
			animator.stop()
			
#check if the player is on another ladder
func check_ladder_overlap():
	var is_near_ladder = false
	for area in ladder_detector.get_overlapping_areas():
		if area.is_in_group("ladder"):
			is_near_ladder = true
			break
	if is_near_ladder and not is_jumping:
		is_climbing = true
		#print("Entered ladder")
	else:
		#print("Exited ladder")
		is_climbing = false			
	
	
# jump
func handle_jump():
	if is_on_floor() or is_climbing:
		if Input.is_action_just_pressed("jump"):
			velocity.y = -jump_force
			can_dash = true # reset dash
			is_jumping = true
			if is_climbing:
				is_climbing = false
			await get_tree().create_timer(0.3).timeout  # wait for a while to be able to climb again
			is_jumping = false  # reset jump state
func disable_ladder_collision():
	ladder_detector.monitoring = false  # ban ladder detector

func enable_ladder_collision():
	ladder_detector.monitoring = true  
			
# dash while in the air
func handle_dash():
	if Input.is_action_just_pressed("dash") and not is_on_floor() and can_dash:
		start_dash()
			
# Dash 逻辑
func start_dash():
	is_dashing = true
	can_dash = false  # only dash once
	velocity.y = 0  # prevernt from falling during dash
	velocity.x = (-1 if animator.flip_h else 1) * dashSpeed  # Dash direction
	animator.play("dash")  # play dash ani
	
	await get_tree().create_timer(dash_duration).timeout  # Dash duration
	stop_dash()


func stop_dash():
	is_dashing = false
	velocity.x = 0  #  stop dash


# player pass through platform
func handle_platform_pass_through():
	if Input.is_action_just_pressed("down") and is_on_floor():
		disable_platform_collision()
		is_falling_through = true
		await get_tree().create_timer(0.3).timeout  # restore crashing after 0.3s
		enable_platform_collision()
		is_falling_through = false
		
# update players animation
func update_animation():
	if is_dashing:
		animator.play("dash")
	elif is_climbing:
		if not animator.is_playing() or animator.animation != "climb":
			animator.play("climb")
	elif not is_on_floor():
		animator.play("jumpUp" if velocity.y < 0 else "jumpDown")
	else:
		animator.play("run" if velocity.x != 0 else "idle")
			
func disable_platform_collision():
	# turn off collision between player and platform
	set_collision_mask_value(2, false)  

func enable_platform_collision():
	# turn off collision between player and platform
	set_collision_mask_value(2, true)
	
#player engaged with enemy
func player_attacked():
	if is_attacked:
		return # avoid multiple attack
	is_attacked = true
	set_physics_process(false)  # ban physics
	velocity = Vector2.ZERO
	animator.play("die")
	
	await get_tree().create_timer(1).timeout  # wait time until player can move again
	is_attacked = false
	animator.play("idle")
	set_physics_process(true)  # reactivate physics
