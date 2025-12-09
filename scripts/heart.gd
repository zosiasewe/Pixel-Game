extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.has_method("add_heart"):
		body.add_heart(1)
		queue_free()  # Remove heart from world
