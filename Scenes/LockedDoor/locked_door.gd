extends StaticBody2D


var buttons_pressed: int
var buttons_needed: int

@export var puzzle_button: Array[PuzzleButton]

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	if not puzzle_button.is_empty():
		buttons_needed = puzzle_button.size()
		for button in puzzle_button:
			button.pressed.connect(_on_puzzle_button_pressed)
			button.unpressed.connect(_on_puzzle_button_unpressed)


func _on_puzzle_button_pressed() -> void:
	buttons_pressed += 1
	if buttons_pressed == buttons_needed:
		print("Door: Now I'm unlocked.")
		visible = false
		collision_shape_2d.set_deferred("disabled", true)


func _on_puzzle_button_unpressed() -> void:
	buttons_pressed -= 1
	if buttons_pressed < buttons_needed:
		print("Door: Now I'm locked.")
		visible = true
		collision_shape_2d.set_deferred("disabled", false)
