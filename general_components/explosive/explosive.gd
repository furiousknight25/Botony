extends Node3D

@onready var test_explosion_particles: CPUParticles3D = $TestExplosionParticles



func explode():
	test_explosion_particles.emitting = true
	
