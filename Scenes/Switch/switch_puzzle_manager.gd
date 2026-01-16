extends Marker2D


signal puzzle_solved
signal puzzle_failed


@export var target_score: int = 0
var score: int:
	set(value):
		score = value
		if score >= target_score:
			puzzle_solved.emit()
		else:
			puzzle_failed.emit()


func increase_score() -> void:
	score += 1
	print(score)


func decrease_score() -> void:
	score -= 1
	print(score)
