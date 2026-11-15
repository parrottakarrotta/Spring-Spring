extends CharacterBody2D
@onready var sprite: AnimatedSprite2D= $Animating

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	
	if is_on_floor():
		var number = [-1, 1].pick_random()
		velocity.y = JUMP_VELOCITY
		velocity.x = number * randf_range(100,400)
		
		if sprite.animation != "landed":
			sprite.play("landed")
	else:
		if sprite.animation != "bouncin":
			await get_tree().create_timer(0.1).timeout
			if velocity.x > 0:
				sprite.flip_h = false
			elif velocity.x < 0:
				sprite.flip_h = true
			sprite.play("bouncin")

	move_and_slide()
	
