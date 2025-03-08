extends Node2D

var entropyLevel: int = 0

func _on_timer_timeout() -> void:
	entropyLevel +=1
	print("Entropy is now at " + str(entropyLevel))
