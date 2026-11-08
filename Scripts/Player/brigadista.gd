class_name Brigadista
extends CharacterBody2D
# Basado en FV_player.gd: mismo movimiento (Input.get_vector), mismas animaciones
# por direccion y mismo sistema de hitbox. La "espada" ahora es la mano de ayuda.

@export var speed := 60.0
var can_move : bool = true

var is_helping : bool = false
# Direccion hacia donde esta mirando el brigadista
var facing_direction := Vector2.DOWN
@onready var ayuda_hitbox: Area2D = $AyudaHitbox

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	add_to_group("player")
	ayuda_hitbox.monitoring = false


func _physics_process(delta: float) -> void:

	if not can_move:
		velocity = Vector2.ZERO
		return

	# Ayudar (equivale a ATACAR en el proyecto de Zelda)
	if Input.is_action_just_pressed("AYUDAR"):
		ayudar()

	if is_helping:
		return

	var direction := Input.get_vector(
		"IZQUIERDA",
		"DERECHA",
		"ARRIBA",
		"ABAJO"
		)

	velocity = direction * speed

	# Aplicar animaciones al personaje
	if direction == Vector2.ZERO:
		if facing_direction == Vector2.DOWN:
			animated_sprite_2d.play("walk_down")
		elif facing_direction == Vector2.UP:
			animated_sprite_2d.play("walk_up")
		elif facing_direction == Vector2.RIGHT:
			animated_sprite_2d.play("walk_right")
		elif facing_direction == Vector2.LEFT:
			animated_sprite_2d.play("walk_left")
		animated_sprite_2d.pause()
		return

	if direction.x > 0:
		facing_direction = Vector2.RIGHT
		animated_sprite_2d.play("walk_right")

	elif direction.x < 0:
		facing_direction = Vector2.LEFT
		animated_sprite_2d.play("walk_left")

	elif direction.y > 0:
		facing_direction = Vector2.DOWN
		animated_sprite_2d.play("walk_down")

	elif direction.y < 0:
		facing_direction = Vector2.UP
		animated_sprite_2d.play("walk_up")

	move_and_slide()


# Igual que en el proyecto de Zelda: la camara llama a esta funcion
# para que el personaje camine solo mientras cambia la pantalla.
func move_screen_transition(direction: Vector2, distance: float) -> void:

	can_move = false

	# Animacion durante la transicion
	if direction.x > 0:
		animated_sprite_2d.play("walk_right")

	elif direction.x < 0:
		animated_sprite_2d.play("walk_left")

	elif direction.y > 0:
		animated_sprite_2d.play("walk_down")

	elif direction.y < 0:
		animated_sprite_2d.play("walk_up")

	var tween = create_tween()
	tween.tween_property(self, "position", position + direction * distance, 0.5)
	await tween.finished


func ayudar() -> void:
	is_helping = true
	# Ya tenemos guardada la direccion hacia donde mira el jugador y hacia esa
	# direccion ejecutamos la animacion correspondiente.
	if facing_direction == Vector2.RIGHT:
		ayuda_hitbox.position = Vector2(12, 0)
		animated_sprite_2d.play("Ayuda_Right")

	elif facing_direction == Vector2.LEFT:
		ayuda_hitbox.position = Vector2(-12, 0)
		animated_sprite_2d.play("Ayuda_Left")

	elif facing_direction == Vector2.UP:
		ayuda_hitbox.position = Vector2(0, -12)
		animated_sprite_2d.play("Ayuda_Up")

	elif facing_direction == Vector2.DOWN:
		ayuda_hitbox.position = Vector2(0, 12)
		animated_sprite_2d.play("Ayuda_Down")

	ayuda_hitbox.monitoring = true

	await animated_sprite_2d.animation_finished
	ayuda_hitbox.monitoring = false

	is_helping = false


# Igual que _on_sword_hitbox_area_entered, pero con el grupo PACIENTES
func _on_ayuda_hitbox_area_entered(area: Area2D) -> void:
	var paciente = area.get_parent()

	if paciente.is_in_group("PACIENTES"):
		paciente.atender(self)
