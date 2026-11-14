extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if is_on_floor():
			var player_pos = position
			var mouse_pos = get_global_mouse_position()
			var direction = (mouse_pos - player_pos) * 4
			var a = clamp(direction.x,-1000,1000)
			var b = clamp(direction.y,-500,500)
			direction = Vector2(a,b)
			velocity += direction


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
