extends StaticBody2D


@onready var canvas_layer: CanvasLayer = $CanvasLayer


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		canvas_layer.visible = !canvas_layer.visible
