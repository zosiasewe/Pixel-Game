extends Area2D

@export var required_hearts: int = 6

func _ready():
	# Hide the surprise initially
	visible = false
	# Check every frame if player has enough hearts
	set_process(true)

func _process(_delta):
	# Find the player and check their hearts
	var player = get_tree().get_first_node_in_group("player")
	if player and player.has_method("get_hearts"):
		if player.get_hearts() >= required_hearts:
			visible = true
		else:
			visible = false

func _on_body_entered(body: Node) -> void:
	if body.has_method("collect_surprise"):
		body.collect_surprise()
	queue_free()
