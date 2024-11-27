extends CharacterBody2D


const SPEED = 100.0

const dashSpeed = 200
var dashing = false
var canDash = true

var mousePosition = get_global_mouse_position()
var meleeAttackDirection = mousePosition - global_position
var attacking = false


func ready():
	print("test123")

func _physics_process(delta):
	
	var direction = Input.get_vector("left" , "right", "up", "down")
	
	direction[0] *= 1.2
	direction[1] /= 1.2 
	
	if Input.is_action_just_pressed("dash") and canDash:
		$DashParticals.emitting = true
		$Dashing.start()
		$DashReset.start()
		dashing = true
		canDash = false
		
	if dashing:
		velocity = direction * dashSpeed
	
	if direction and not dashing:
		if direction[0] > 0:
			$Player.flip_h = true
			$Player.rotation = 10 * PI / 180
			
			
			$Wheel.flip_h = true
			$Wheel.rotation = 10 * PI / 180
			$Wheel.position.x = -3
			
			
			$DashParticals.scale.x = -1
			
		elif direction[0] < 0:
			$Player.flip_h = false
			$Player.rotation = -10 * PI / 180
			
			
			$Wheel.flip_h = false
			$Wheel.rotation = -10 * PI / 180
			$Wheel.position.x = 3
			
			$DashParticals.scale.x = 1
			
			
		velocity = direction * SPEED
		$Wheel.position.y = 11
		
	elif not dashing:
		$Player.rotation = 0 * PI / 180
		
		$Wheel.rotation = 0 * PI / 180
		$Wheel.position.x = 0
		$Wheel.position.y = 12
		
		velocity = Vector2.ZERO
		
	if Input.is_action_just_pressed("attack") and not attacking:
		attacking = true
		$Attacking.start()
		$Melee.visible = true
		$Melee/Hitbox/CollisionShape2D.disabled = false
		$Melee.play("attack")
		
	if attacking:
		mousePosition = get_global_mouse_position()
		meleeAttackDirection = mousePosition - $Melee.global_position
		$Melee.rotation = meleeAttackDirection.angle() + PI / 2
	
	move_and_slide()

func _on_dashing_timeout():
	dashing = false
	$DashParticals.emitting = false

func _on_dash_reset_timeout():
	canDash = true

func _on_attacking_timeout():
	$Melee.visible = false
	$Melee/Hitbox/CollisionShape2D.disabled = true
	attacking = false
	
