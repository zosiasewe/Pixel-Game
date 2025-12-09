extends RigidBody2D

@export var jump_force = -400.0
@export var jump_cooldown = 0.5
@export var unlock_day = 11  # December 11th
@export var unlock_month = 12  # December

var can_jump = true
var jump_timer = 0.0
var is_on_ground = false

@onready var animated_sprite = $AnimatedSprite2D

func _ready() -> void:
	print("🐊 ALLIGATOR SPAWNED")
	check_unlock_status()
	
	contact_monitor = true
	max_contacts_reported = 4
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	if animated_sprite:
		animated_sprite.play("aligator")

func check_unlock_status():
	var current_date = Time.get_date_dict_from_system()
	var current_day = current_date["day"]
	var current_month = current_date["month"]
	var current_year = current_date["year"]
	
	print("📅 TODAY: ", current_year, "-", current_month, "-", current_day)
	print("🔓 UNLOCK DATE: 2025-", unlock_month, "-", unlock_day)
	
	var is_unlocked = false
	
	# Check if current date is >= unlock date
	if current_month > unlock_month:
		print("✅ Month is past unlock month")
		is_unlocked = true
	elif current_month == unlock_month and current_day >= unlock_day:
		print("✅ Same month, day >= unlock day")
		is_unlocked = true
	else:
		print("🔒 NOT UNLOCKED YET")
		print("   Current: month=", current_month, " day=", current_day)
		print("   Need: month=", unlock_month, " day=", unlock_day)
	
	print("🐊 Final result: is_unlocked = ", is_unlocked)
	print("🐊 Setting visible = ", is_unlocked)
	
	visible = is_unlocked
	set_process(is_unlocked)
	set_physics_process(is_unlocked)
	
	# FORCE hide if locked
	if not is_unlocked:
		hide()
		print("🐊 FORCE HIDDEN!")

func _process(delta: float) -> void:
	if not can_jump:
		jump_timer += delta
		if jump_timer >= jump_cooldown:
			can_jump = true
			jump_timer = 0.0
	
	if is_on_ground and can_jump:
		if randf() < 0.01:
			perform_jump()

func perform_jump():
	if is_on_ground and can_jump:
		apply_central_impulse(Vector2(0, jump_force))
		can_jump = false
		is_on_ground = false

func _on_body_entered(body):
	if body.is_in_group("ground") or body.name == "Ground":
		is_on_ground = true

func _on_body_exited(body):
	if body.is_in_group("ground") or body.name == "Ground":
		is_on_ground = false
