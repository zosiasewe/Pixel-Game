extends Area2D

@export var target_scene: PackedScene  # Drag world_3.tscn here in Inspector
@export var unlock_day: int = 8 # Change to 11 for December 11
@export var door_label: String = "World 3"
@onready var sprite = $AnimatedSprite2D

var player_nearby = false
var snacks_collected: bool = false
var original_modulate: Color

func _ready():
	add_to_group("world3_door")
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	print("🚪 World 3 Door ready!")
	
	# Make door look locked initially
	if sprite:
		original_modulate = sprite.modulate
		sprite.modulate = Color(0.5, 0.5, 0.5, 1.0)  # Gray = locked

func is_date_unlocked() -> bool:
	var date = Time.get_datetime_dict_from_system()
	return date["month"] == 12 and date["day"] >= unlock_day

func is_fully_unlocked() -> bool:
	# Need BOTH snacks AND correct date
	return snacks_collected and is_date_unlocked()

func unlock():
	# Called by player when 4 snacks collected
	snacks_collected = true
	print("🍿 Snacks requirement met!")
	update_door_appearance()

func update_door_appearance():
	if !sprite:
		return
	
	if is_fully_unlocked():
		# Fully unlocked - restore color
		sprite.modulate = original_modulate
		print("🚪 Door is now FULLY UNLOCKED!")
	elif snacks_collected:
		# Has snacks but wrong date
		sprite.modulate = Color(0.7, 0.7, 0.7, 1.0)
		print("🔒 Door waiting for December ", unlock_day)
	else:
		# Still locked
		sprite.modulate = Color(0.5, 0.5, 0.5, 1.0)

func _on_body_entered(body):
	if body.name == "Player" or body.is_in_group("player") or body is CharacterBody2D:
		player_nearby = true
		
		if is_fully_unlocked():
			print("✓ Press Enter to open ", door_label)
		else:
			show_lock_reason()

func _on_body_exited(body):
	if body.name == "Player" or body.is_in_group("player") or body is CharacterBody2D:
		player_nearby = false

func _input(event):
	if event.is_action_pressed("ui_accept") and player_nearby:
		if !is_fully_unlocked():
			show_lock_reason()
			return
		
		if target_scene == null:
			print("❌ No target scene assigned!")
			return
		
		# Door is unlocked - change scene
		print("Opening ", door_label, "...")
		get_tree().change_scene_to_packed(target_scene)

func show_lock_reason():
	var reasons = []
	
	if !snacks_collected:
		reasons.append("Need 4 snacks")
	
	if !is_date_unlocked():
		reasons.append("Available from Dec " + str(unlock_day))
	
	if reasons.size() > 0:
		print("🔒 Door locked! ", " & ".join(reasons))
