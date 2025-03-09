extends Node2D


@export var item_name: String = "MEMORY FRAGMENTS"
@export var sprite_texture: Texture
@export var collected: bool
@export var animator : AnimatedSprite2D
@export var float_height: float = 5
@export var float_speed: float = 2    
@onready var start_position = global_position  
var start_y: float
var door #parent node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	door = get_parent()
	collected = false
	start_y = global_position.y

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not collected and not door.locked: 
		door.global_position.y = start_y + sin(Time.get_ticks_msec() * 0.001 * float_speed) * float_height
		await get_tree().create_timer(0.5).timeout 
		if Input.is_action_just_pressed("interact"):
			collect()

func collect() -> void:
	if not collected:
		#print("collected")
		Inventory.add_to_inventory(item_name)
		animator.play("collect")
		await get_tree().create_timer(0.6).timeout 
		collected = true
	
