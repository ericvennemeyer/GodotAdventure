extends StaticBody2D


var can_interact: bool = false
var dialogue_index: int = 0

@export var dialogue_lines: Array[String] = ["One", "Two", "Three"]

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var dialogue_label: Label = $CanvasLayer/DialogueLabel
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and can_interact:
		audio_stream_player_2d.play()
		if dialogue_index < dialogue_lines.size():
			get_tree().paused = true
			canvas_layer.visible = true
			dialogue_label.text = dialogue_lines[dialogue_index]
			dialogue_index += 1
		else:
			get_tree().paused = false
			canvas_layer.visible = false
			dialogue_index = 0
