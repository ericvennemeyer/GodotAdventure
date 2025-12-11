extends Area2D


func _on_body_entered(body: Node2D) -> void:
	print(str(body.name) + " has entered me!")


func _on_body_exited(body: Node2D) -> void:
	print(str(body.name) + " has exited me!")
