extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $Animating

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const INVINCIBILITY_TIME = 1.0

var in_water = false
var health = 100
var invincible = false


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if is_on_floor():
			var player_pos = position
			var mouse_pos = get_global_mouse_position()
			var direction = (mouse_pos - player_pos) * 4
			var a = clamp(direction.x, -600, 600)
			var b = clamp(direction.y, -650, 0)
			direction = Vector2(a, b)
			velocity += direction
			sprite.play("bouncin")

			if velocity.x > 0:
				sprite.flip_h = false
			elif velocity.x < 0:
				sprite.flip_h = true


func _physics_process(delta: float) -> void:
	print(health)

	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()

	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0, SPEED)

		if sprite.animation != "landed":
			sprite.play("landed")
	else:
		if sprite.animation != "bouncin":
			sprite.play("bouncin")

	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()

		if collider.name == "Enemy" and not invincible:
			take_damage(10)


func take_damage(amount: int) -> void:
	health -= amount
	invincible = true

	# Start the invincibility timer
	start_invincibility()


func start_invincibility() -> void:
	# Flash the sprite during invincibility
	for i in range(5):
		sprite.modulate.a = 0.3
		await get_tree().create_timer(INVINCIBILITY_TIME / 10.0).timeout

		sprite.modulate.a = 1.0
		await get_tree().create_timer(INVINCIBILITY_TIME / 10.0).timeout

	# Restore normal appearance
	sprite.modulate.a = 1.0
	invincible = false
