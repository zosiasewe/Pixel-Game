extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.has_method("drink_potion"):
		body.drink_potion()
		queue_free()  # Remove drink after collecting
  
