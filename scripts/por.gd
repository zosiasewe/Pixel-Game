extends Area2D

func _ready():
	print(" Por spawned at: ", global_position)
	
	# Enable monitoring
	monitoring = true
	monitorable = true
	
	# Connect BOTH signals for CharacterBody2D detection
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)
	
	# Debug collision setup
	print("Por collision_layer: ", collision_layer)
	print("Por collision_mask: ", collision_mask)

func _on_body_entered(body: Node) -> void:
	print(" Por touched by BODY: ", body.name)
	
	if body.has_method("add_por"):
		print(" Calling add_por!")
		body.add_por(1)
		queue_free()
	else:
		print(" Body doesn't have add_por method")

func _on_area_entered(area: Node) -> void:
	print(" Por touched by AREA: ", area.name)
