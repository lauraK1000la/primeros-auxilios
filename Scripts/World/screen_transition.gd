class_name Screen_Transition
extends Node2D
# Reciclado de screen_transition.gd del proyecto de Zelda.
# Cuando el jugador toca un borde de la camara, el personaje camina solo un poco
# y la camara se desplaza una pantalla completa (256 x 176).

#Create references
@onready var camera_2d: Camera2D = $".."
@onready var brigadista: Brigadista = $"../../Brigadista"

var moving_camera: bool = false

@onready var area_2d_up: Area2D = $Area2D_UP
@onready var area_2d_down: Area2D = $Area2D_DOWN
@onready var area_2d_left: Area2D = $Area2D_LEFT
@onready var area_2d_right: Area2D = $Area2D_RIGHT

func disable_borders()->void:
	area_2d_up.set_deferred("monitoring" ,false)
	area_2d_down.set_deferred("monitoring" ,false)
	area_2d_left.set_deferred("monitoring" ,false)
	area_2d_right.set_deferred("monitoring" ,false)

func enable_borders()->void:
	area_2d_up.set_deferred("monitoring" ,true)
	area_2d_down.set_deferred("monitoring" ,true)
	area_2d_left.set_deferred("monitoring" ,true)
	area_2d_right.set_deferred("monitoring" ,true)


# Los 4 bordes hacen exactamente lo mismo, solo cambia la direccion.
func _change_screen(body: Node2D, direction: Vector2, camera_offset: Vector2) -> void:
	#1. Verificar el ingreso del jugador (el nodo se llama Brigadista)
	if body.name == "Brigadista" and not moving_camera:
		moving_camera = true

		#2. Deshabilitar los bordes
		disable_borders()

		#3. Llamar la funcion del personaje para que se mueva automaticamente
		await brigadista.move_screen_transition(direction , 20)

		#4. Crear la nueva posicion de la camara
		var new_position_camera = camera_2d.position + camera_offset

		#5. Crear transicion, utilizando tween
		var tween = create_tween()
		tween.tween_property(camera_2d,"position" , new_position_camera , 0.8)
		await tween.finished

		#6. Habilitar de nuevo los bordes
		enable_borders()

		moving_camera = false

		#El jugador ya puede moverse de nuevo
		brigadista.can_move = true


func _on_area_2d_up_body_entered(body: Node2D) -> void:
	await _change_screen(body, Vector2.UP, Vector2(0, -176))

func _on_area_2d_down_body_entered(body: Node2D) -> void:
	await _change_screen(body, Vector2.DOWN, Vector2(0, 176))

func _on_area_2d_left_body_entered(body: Node2D) -> void:
	await _change_screen(body, Vector2.LEFT, Vector2(-256, 0))

func _on_area_2d_right_body_entered(body: Node2D) -> void:
	await _change_screen(body, Vector2.RIGHT, Vector2(256, 0))
