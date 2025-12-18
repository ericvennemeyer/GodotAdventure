extends StaticBody2D


@export var puzzle_button: PuzzleButton

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	if puzzle_button:
		puzzle_button.pressed.connect(_on_puzzle_button_pressed)
		puzzle_button.unpressed.connect(_on_puzzle_button_unpressed)


func _on_puzzle_button_pressed() -> void:
	print("Door: Now I'm unlocked.")
	visible = false
	collision_shape_2d.set_deferred("disabled", true)


func _on_puzzle_button_unpressed() -> void:
	print("Door: Now I'm locked.")
	visible = true
	collision_shape_2d.set_deferred("disabled", false)
