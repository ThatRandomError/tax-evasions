class_name Hurtbox
extends Area2D

func _init():
	collision_layer = 0
	collision_mask = 2

func _ready():
	connect("area_entered", self._on_area_entered)
	
func _on_area_entered(hitbox: Hitbox):
	if hitbox == null:
		return
	
	if owner.has_method("damage"):
		owner.damage(hitbox.damage)

		var knockback_vector = (global_position - hitbox.global_position).normalized()
		
		if owner.has_method("knockback"):
			owner.knockback(knockback_vector, hitbox.knockback_strength)
