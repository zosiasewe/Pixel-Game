extends Area2D

@export var target_scene: PackedScene
@export var unlock_day: int = 7  # Day of December (1-31)
@export var door_label: String = "Level 2"  # Optional: for the message

var player_nearby = false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func is_unlocked() -> bool:
	var date = Time.get_datetime_dict_from_system()
	# Unlocks if it's December and the current day >= unlock_day
	return date["month"] == 12 and date["day"] >= unlock_day

func _on_body_entered(body):
	if body.name == "Player" or body.is_in_group("player") or body is CharacterBody2D:
		player_nearby = true
		if is_unlocked():
			print("✓ Press Enter to open ", door_label)
		else:
			print("🔒 This door unlocks on December ", unlock_day)

func _on_body_exited(body):
	if body.name == "Player" or body.is_in_group("player") or body is CharacterBody2D:
		player_nearby = false

func _input(event):
	if event.is_action_pressed("ui_accept") and player_nearby:
		if !is_unlocked():
			# Door is locked - just show message, don't change scene
			print("🔒 Come back on December ", unlock_day, "!")
			# Optional: play a "locked" sound here
			return
			
		if target_scene == null:
			print("❌ No target scene assigned!")
			return
		
		# Door is unlocked - change scene
		print("Opening door...")
		next_level()

func next_level():
	get_tree().change_scene_to_packed(target_scene)
