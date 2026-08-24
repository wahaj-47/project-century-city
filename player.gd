extends CharacterBody3D

var WALK: float = 15
var SPRINT: float = 25
var CROUCH: float = 8
#@export var JUMP_VELOCITY = 4.5

var SPEED: float

@onready var interaction_zone = $InteractionZone

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	## Handle jump.
	#if Input.is_action_just_pressed("jump") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
	
	### Check if sprinting
	if Input.is_action_pressed("crouch"):
		SPEED = CROUCH
		$Pivot/Character.scale.y = 0.5
		$Pivot/Character.position.y = -2.0
	elif Input.is_action_just_released("crouch"):
		$Pivot/Character.scale.y = 1.0
		$Pivot/Character.position.y = 0
		#SPEED = WALK
	elif Input.is_action_pressed("sprint"):
		SPEED = SPRINT
	else:
		SPEED = WALK

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		var overlapping_bodies = interaction_zone.get_overlapping_bodies()
		for body in overlapping_bodies:
			if body.has_method("interact"):
				body.interact()
				break
