extends Area2D
@export var move_speed: float = 80  
@export var left_boundary: float =  -125
@export var right_boundary: float = 125
@export var up_boundary: float =  -75
@export var bottom_boundary: float = 75
@export var start_direction: int = -1  # initial direction (1 = r, -1 = l)
@export var animator: AnimatedSprite2D
@export var is_vectical: bool = false # true = up down float  false = left right float

var direction: int  # current direction
var start_position: Vector2  
var enter_wall = false

func _ready():
	start_position = global_position 
	direction = start_direction  

	
func _physics_process(delta: float):
	if is_vectical:
		position.y += delta * direction * move_speed
		if position.y > bottom_boundary or position.y < up_boundary:
			direction *= -1   
	else:
		position.x += delta * direction * move_speed
		# 碰到墙壁或超出范围时反转方向
		if position.x > right_boundary or position.x < left_boundary:
			direction *= -1   
			animator.flip_h = direction > 0 
			
	enter_wall = false


func _on_body_entered(body: Node2D) -> void:
	#print("body entered")
	if body is CharacterBody2D :
		body.player_attacked()
		#print("player enter")
	elif body is StaticBody2D:
		#print("wall enter")
		if not enter_wall:
			direction *= -1
			if not is_vectical:
				animator.flip_h = direction > 0
			enter_wall = true
