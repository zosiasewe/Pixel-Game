extends Area2D

func _ready():
	print(" Snack spawned at: ", global_position)
	
	# Enable monitoring
	monitoring = true
	monitorable = true
	
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)
	
	print("Snack collision_layer: ", collision_layer)
	print("Snack collision_mask: ", collision_mask)

func _on_body_entered(body: Node) -> void:
	print(" Snack touched by BODY: ", body.name)
	
	if body.has_method("add_snack"):
		print(" Calling add_snack!")
		body.add_snack(1)
		queue_free()
	else:
		print(" Body doesn't have add_snack method")

func _on_area_entered(area: Node) -> void:
	print("🍿 Snack touched by AREA: ", area.name)
