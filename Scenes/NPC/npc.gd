extends StaticBody2D


var can_interact: bool = false
var dialogue_lines: Array[String] = ["One", "Two", "Three"]

@onready var canvas_layer: CanvasLayer = $CanvasLayer


func _ready() -> void:
	print(dialogue_lines[0], dialogue_lines[2])


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and can_interact:
		canvas_layer.visible = !canvas_layer.visible
		get_tree().paused = !get_tree().paused
