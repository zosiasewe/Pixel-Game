extends Area2D

func _ready():
	print(" Shake spawned at: ", global_position)
	
	monitoring = true
	monitorable = true
	
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)
	
	print("Shake collision_layer: ", collision_layer)
	print("Shake collision_mask: ", collision_mask)

func _on_body_entered(body: Node) -> void:
	print(" Shake touched by BODY: ", body.name)
	
	if body.has_method("add_shake"):
		print(" Calling add_shake!")
		body.add_shake(1)
		queue_free()
	else:
		print(" Body doesn't have add_shake method")

func _on_area_entered(area: Node) -> void:
	print(" Shake touched by AREA: ", area.name)
