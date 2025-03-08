extends CharacterBody2D

@export var speed : float = 100
@export var jump_force : float = 350.0  
@export var gravity : float = 800.0  
@export var dashSpeed : float = 300
@export var dash_duration: float = 0.2
@export var animator : AnimatedSprite2D
# Called when the node enters the scene tree for the first time.

var is_attacked = false 
var is_falling_through = false
var is_dashing = false
var can_dash = true  # is the player eligible for dashing

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float):
	apply_gravity(delta)
	handle_movement()
	handle_jump()
	handle_platform_pass_through()
	handle_dash()
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

# jump
func handle_jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_force
		can_dash = true # reset dash
		
# dash while in the air
func handle_dash():
	if Input.is_action_just_pressed("dash") and not is_on_floor() and can_dash:
		start_dash()
			
# Dash 逻辑
func start_dash():
	is_dashing = true
	can_dash = false  # 只允许空中 Dash 一次
	velocity.y = 0  # 防止 Dash 期间掉落
	velocity.x = (-1 if animator.flip_h else 1) * dashSpeed  # Dash 方向
	animator.play("dash")  # 播放 Dash 动画
	
	await get_tree().create_timer(dash_duration).timeout  # Dash 持续时间
	
	stop_dash()

func stop_dash():
	is_dashing = false
	velocity.x = 0  # Dash 结束后停止
	
# player pass through platform
func handle_platform_pass_through():
	if Input.is_action_just_pressed("down") and is_on_floor():
		disable_platform_collision()
		is_falling_through = true
		await get_tree().create_timer(0.3).timeout  # 0.3秒后恢复碰撞
		enable_platform_collision()
		is_falling_through = false
		
# update players animation
func update_animation():
	if is_dashing:
		animator.play("dash")
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
