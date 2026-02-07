extends StaticBody2D

@export var chest_name: String

var can_interact: bool = false
var is_open: bool = false

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D


func _ready() -> void:
	if SceneManager.open_chests.has(chest_name):
		is_open = true
		animated_sprite_2d.play("open")


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and can_interact:
		if not is_open:
			open_chest()


func open_chest() -> void:
	audio_stream_player_2d.play()
	animated_sprite_2d.play("open")
	is_open = true
	if chest_name:
		SceneManager.open_chests.append(chest_name)
	
	sprite_2d.visible = true
	var tween = get_tree().create_tween()
	tween.tween_property(sprite_2d, "position", Vector2.UP * 10, 0.5).as_relative()
	tween.tween_callback(func(): 
		await get_tree().create_timer(0.5).timeout
		sprite_2d.visible = false
		)
