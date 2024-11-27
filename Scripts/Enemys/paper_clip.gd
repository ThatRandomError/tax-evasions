extends Node2D

var health = 10
var velocity = Vector2.ZERO
var knockback_speed = 300  # Speed of knockback
var knockback_duration = 0.2  # Duration of knockback effect in seconds
var is_knocked_back = false
var knockback_timer = 0.0

func _ready():
	$Enemy.play("idle")

# Damage function with shader effect and time scale slowdown
func damage(amount: int):
	health -= amount
	print(health)
	
	# Apply white flash shader effect
	var shader = Shader.new()
	shader.code = """
		shader_type canvas_item;
		void fragment() {
			COLOR = vec4(1.0, 1.0, 1.0, texture(TEXTURE, UV).a);  // Sets RGB to white, keeps original alpha
		}
	"""
	var shader_material = ShaderMaterial.new()
	shader_material.shader = shader
	$Enemy.material = shader_material
	
	# Slow down time temporarily
	Engine.time_scale = 0.1
	await get_tree().create_timer(0.025).timeout
	Engine.time_scale = 1.0
	$Enemy.material = null  # Remove shader effect
	
# Apply knockback in a specific direction
func knockback(direction: Vector2, strength: float):
	is_knocked_back = true
	knockback_timer = knockback_duration
	velocity = direction * knockback_speed * strength
