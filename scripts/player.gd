extends CharacterBody2D
# Movement variables
@export var speed = 200.0
@export var jump_force = -400.0
@export var gravity_force = 800.0
var facing_right = true

# Collectible counters
var hearts: int = 0
var surprise_unlocked: bool = false
var pors: int = 0
var por_surprise_unlocked: bool = false
var shake: int = 0
var shake_surprise_unlocked: bool = false
var snacks: int = 0
var door_unlocked: bool = false

# Wardrobe system
var unlocked_outfits: Array = [1]
var current_outfit: int = 1

# World travel system
var unlocked_worlds: Array = [1]  # World 1 always unlocked
var current_world: int = 1

# References
@onready var animated_sprite = $AnimatedSprite2D
@export var surprise_scene: PackedScene = preload("uid://dn330188tqfha")
@export var por_surprise_scene: PackedScene = preload("uid://bnd6ymevje81q")
@export var shake_surprise_scene: PackedScene = preload("uid://3svwssocyp56")

func _ready() -> void:
	add_to_group("player")
	
	# Check date and auto-unlock outfits/worlds
	check_date_unlocks()
	
	if animated_sprite:
		animated_sprite.play("stand")
	
	print("🎨 Controls:")
	print("  1, 2, 3, 4 - Switch outfits")
	print("  Q, W, E - Travel to World 1, 2, 3")
	print("🎨 Unlocked outfits: ", unlocked_outfits)
	print("🌍 Unlocked worlds: ", unlocked_worlds)

# ===== DATE-BASED AUTO-UNLOCKING =====
func check_date_unlocks():
	var date = Time.get_datetime_dict_from_system()
	var day = date["day"]
	var month = date["month"]
	
	# Only unlock in December
	if month != 12:
		return
	
	print("📅 Checking date unlocks for December ", day)
	
	# Auto-unlock outfits and worlds based on date
	if day >= 1:  # Dec 1+ - World 1
		auto_unlock_outfit(1)
		auto_unlock_outfit(2)
		unlock_world(1)
	
	if day >= 7:  # Dec 7+ - World 2
		auto_unlock_outfit(3)
		unlock_world(2)
	
	if day >= 11:  # Dec 11+ - World 3
		#auto_unlock_outfit(4)
		unlock_world(3)
	
	if day >= 15:  # Dec 15+ - Future content
		# Add more outfits/worlds here later
		pass

func auto_unlock_outfit(outfit_number: int):
	if outfit_number not in unlocked_outfits:
		unlocked_outfits.append(outfit_number)
		print("🎁 Outfit ", outfit_number, " auto-unlocked (date-based)!")

func unlock_world(world_number: int):
	if world_number not in unlocked_worlds:
		unlocked_worlds.append(world_number)
		print("🌍 World ", world_number, " unlocked!")

# ===== WARDROBE SYSTEM =====
func unlock_outfit(outfit_number: int):
	if outfit_number not in unlocked_outfits:
		unlocked_outfits.append(outfit_number)
		print("🎉 OUTFIT ", outfit_number, " UNLOCKED! Press ", outfit_number, " to wear it!")
		print("🎨 Unlocked outfits: ", unlocked_outfits)

func switch_outfit(outfit_number: int):
	if outfit_number in unlocked_outfits:
		current_outfit = outfit_number
		print("👕 Changed to outfit ", outfit_number)
	else:
		print("🔒 Outfit ", outfit_number, " is locked!")

func get_animation_suffix() -> String:
	match current_outfit:
		1: return ""
		2: return "_2"
		3: return "_3"
		4: return "_4"
		_: return ""

# ===== WORLD TRAVEL SYSTEM =====
func travel_to_world(world_number: int):
	if world_number not in unlocked_worlds:
		print("🔒 World ", world_number, " is locked!")
		return
	
	var world_paths = {
		1: "res://scenes/world_1.tscn",
		2: "res://scenes/world_2.tscn",
		3: "res://scenes/world_3.tscn"
	}
	
	if world_number in world_paths:
		print("🌍 Traveling to World ", world_number, "...")
		get_tree().change_scene_to_file(world_paths[world_number])
	else:
		print("❌ World ", world_number, " doesn't exist!")

# ===== HEART SYSTEM (Unlocks Outfit 2) =====
func add_heart(amount: int):
	hearts += amount
	print("💗 Hearts: ", hearts, "/6")
	
	if hearts == 6 and !surprise_unlocked:
		unlock_surprise()

func unlock_surprise():
	surprise_unlocked = true
	print("🎉 HEART SURPRISE! Drink spawned!")
	
	if surprise_scene:
		var surprise = surprise_scene.instantiate()
		surprise.global_position = global_position + Vector2(0, -50)
		get_parent().add_child(surprise)

func drink_potion():
	print("🍹 Drinking potion!")
	unlock_outfit(2)
	switch_outfit(2)

# ===== POR SYSTEM (Unlocks Outfit 3) =====
func add_por(amount: int):
	pors += amount
	print("🥕 Pors: ", pors, "/6")
	
	if pors == 6 and !por_surprise_unlocked:
		unlock_por_surprise()

func unlock_por_surprise():
	por_surprise_unlocked = true
	print("🎉 POR SURPRISE! Drink2 spawned!")
	
	if por_surprise_scene:
		var surprise = por_surprise_scene.instantiate()
		surprise.global_position = global_position + Vector2(0, -50)
		get_parent().add_child(surprise)

func drink_potion_2():
	print("🍹 Drinking potion 2!")
	unlock_outfit(3)
	switch_outfit(3)

# ===== SHAKE SYSTEM (Unlocks Outfit 4) =====
func add_shake(amount: int):
	shake += amount
	print("🥤 Shakes: ", shake, "/6")
	
	if shake == 6 and !shake_surprise_unlocked:
		unlock_shake_surprise()

func unlock_shake_surprise():
	shake_surprise_unlocked = true
	print("🎉 SHAKE SURPRISE! Drink3 spawned!")
	
	if shake_surprise_scene:
		var surprise = shake_surprise_scene.instantiate()
		surprise.global_position = global_position + Vector2(0, -50)
		get_parent().add_child(surprise)

func drink_potion_3():
	print("🍹 Drinking potion 3!")
	unlock_outfit(4)
	switch_outfit(4)

# ===== SNACK SYSTEM (Unlocks door to world_3) =====
func add_snack(amount: int):
	snacks += amount
	print("🍿 Snacks: ", snacks, "/4")
	
	if snacks == 4 and !door_unlocked:
		unlock_door()

func unlock_door():
	door_unlocked = true
	print("🚪 DOOR UNLOCKED! You can now enter world_3!")
	
	var door = get_node_or_null("../new_door")
	if !door:
		door = get_tree().get_first_node_in_group("world3_door")
	
	if door and door.has_method("unlock"):
		door.unlock()
		print("✅ Door unlock() method called successfully!")

# ===== INPUT HANDLING =====
func _input(event):
	if event is InputEventKey and event.pressed:
		match event.keycode:
			# Outfit switching
			KEY_1:
				switch_outfit(1)
			KEY_2:
				switch_outfit(2)
			KEY_3:
				switch_outfit(3)
			KEY_4:
				switch_outfit(4)
			
			# World travel
			KEY_Q:
				travel_to_world(1)
			KEY_W:
				travel_to_world(2)
			KEY_E:
				travel_to_world(3)

# ===== PHYSICS & MOVEMENT =====
func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity_force * delta
	
	# Drop through platform
	if Input.is_action_just_pressed("ui_down") and is_on_floor():
		position.y += 10
	
	# Get input
	var input_direction = Input.get_axis("ui_left", "ui_right")
	
	# Horizontal movement
	if input_direction != 0:
		velocity.x = input_direction * speed
		facing_right = input_direction > 0
	else:
		velocity.x = 0
	
	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_force
	
	# Move the player
	move_and_slide()
	
	# Update animations
	update_animation()

func update_animation():
	if not animated_sprite:
		return
	
	var suffix = get_animation_suffix()
	
	# Jumping/in air
	if not is_on_floor():
		animated_sprite.play("up" + suffix)
		if velocity.x > 0:
			animated_sprite.frame = 1
		elif velocity.x < 0:
			animated_sprite.frame = 2
		else:
			animated_sprite.frame = 0
	# Walking
	elif velocity.x != 0:
		animated_sprite.play("walk" + suffix)
		if not facing_right:
			if animated_sprite.frame < 3:
				animated_sprite.frame = 3
		else:
			if animated_sprite.frame >= 3:
				animated_sprite.frame = 0
	# Standing
	else:
		animated_sprite.play("stand" + suffix)
