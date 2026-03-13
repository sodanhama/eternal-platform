extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 10


var xform : Transform3D	


func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	
	#Play robot animations
	if Input.is_action_just_pressed('ui_accept') and is_on_floor():
		$AnimationPlayer.play('jump')
	elif input_dir!=Vector2(0,0) and is_on_floor():
		$AnimationPlayer.play('run')
	elif is_on_floor() and input_dir==Vector2(0,0):
		$AnimationPlayer.play('idle')
	
	
	#Rotate the camera left or right
	if Input.is_action_pressed('move_left'):
		$Camera_Controller.rotate_y(deg_to_rad(5))
		
	elif Input.is_action_pressed('move_right'):
		$Camera_Controller.rotate_y(deg_to_rad(-5))

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY


	

	#Move camera	
	var direction : Vector3 = ($Camera_Controller.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	#Rotate the character mesh towards the opposite direction of camera
	if input_dir != Vector2(0,0):
		$Armature.rotation_degrees.y = $Camera_Controller.rotation_degrees.y - rad_to_deg(input_dir.angle()) -90
	
	# Rotate the character in order for it to be aligned with the floor
	if is_on_floor() and input_dir!=Vector2(0,0):
		align_with_floor($RayCast3D.get_collision_normal())
		global_transform = global_transform.interpolate_with(xform, 0.3)
	elif not is_on_floor():
		align_with_floor(Vector3.UP)
		global_transform = global_transform.interpolate_with(xform, 0.3)
			
	
	# update the velocity and move the character
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	#Mak	e camera controller match the position of myself
	$Camera_Controller.position = lerp($Camera_Controller.position,position,0.1)
	
func align_with_floor(floor_normal):
	xform = global_transform	
	xform.basis.y = floor_normal
	xform.basis.x = -xform.basis.z.cross(floor_normal)
	xform.basis = xform.basis.orthonormalized()
	
	


func _on_fall_zone_body_entered(body: Node3D) -> void:
	get_tree().change_scene_to_file('res://level_1.tscn')

func bounce():
	velocity.y = JUMP_VELOCITY*0.7
	
