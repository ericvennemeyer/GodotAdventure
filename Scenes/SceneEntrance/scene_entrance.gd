extends Area2D


@export var next_scene: String


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		get_tree().change_scene_to_file.call_deferred(next_scene)


func _on_body_exited(body: Node2D) -> void:
	print(str(body.name) + " has exited me!")
