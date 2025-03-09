extends Area2D

@export var leftKey : bool = true #true = leftkey false = rightkey
@export var animator : AnimatedSprite2D
@export var float_height: float = 5
@export var float_speed: float = 2    
@onready var start_position = global_position  
var start_y: float
var player_near = false 
func _ready() -> void:
	start_y = global_position.y
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position.y = start_y + sin(Time.get_ticks_msec() * 0.001 * float_speed) * float_height #make key float around
	if player_near:
		if Input.is_action_just_pressed("interact"):
			Inventory.add_to_inventory("KEY")
			animator.play("collectL")
			print("key collected")
			await get_tree().create_timer(0.6).timeout
			queue_free()

#player enters
func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		player_near = true
	

func _on_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		player_near = false
