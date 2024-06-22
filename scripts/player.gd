extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const ANGULAR_ACCELERATION = 10

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var mouse_sensitivity := 0.001
var twist_input := 0.0
var pitch_input := 0.0

@onready var twist_pivot := get_node("%TwistPivot")
@onready var pitch_pivot := get_node("%TwistPivot/PitchPivot")
@onready var animation_tree = $Skeleton3D/Pete/AnimationTree

func _ready() -> void:
	animation_tree.active = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#animation_tree.
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (twist_pivot.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED      
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	$Skeleton3D.rotation.y = lerp_angle($Skeleton3D.rotation.y, atan2(velocity.x,velocity.z), delta * ANGULAR_ACCELERATION)
		
	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x,
		deg_to_rad(-30),
		deg_to_rad(30),
	)
	twist_input = 0
	pitch_input = 0
	update_animation_parameters()
	move_and_slide()	
	
func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = - event.relative.x * mouse_sensitivity
			pitch_input = - event.relative.y * mouse_sensitivity

func _on_music_area_body_entered(body):
	if body.name.contains("Rat"):
		body.is_inside_music_area = true

func _on_music_area_body_exited(body):
	if body.name.contains("Rat"):
		body.is_inside_music_area = false
		
func update_animation_parameters():
	if(velocity == Vector3.ZERO):
		animation_tree["parameters/conditions/is_idle"] = true
		animation_tree["parameters/conditions/is_running"] = false
	else:
		animation_tree["parameters/conditions/is_idle"] = false
		animation_tree["parameters/conditions/is_running"] = true

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		animation_tree["parameters/conditions/jump_pressed"] = true
	else:
		animation_tree["parameters/conditions/jump_pressed"] = false			
