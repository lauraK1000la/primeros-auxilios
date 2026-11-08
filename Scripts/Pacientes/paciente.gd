class_name Paciente
extends CharacterBody2D
# Equivale a FV_octorok.gd / zola.gd: un personaje que vive en el grupo
# PACIENTES (como los enemigos viven en ENEMIES). En vez de take_damage()
# recibe atender(), que la mano de ayuda del brigadista llama al tocarlo.

signal atencion_solicitada(paciente: Paciente)

# Cual de los casos de casos.gd representa este personaje
@export var caso_id: String = "ciclista"
# Efecto visual que aparece al ayudar (se asigna en el Inspector, como death_effect_scene)
@export var efecto_scene: PackedScene

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var zona_atencion: Area2D = $ZonaAtencion
@onready var marca: Sprite2D = $Marca

# Pregunta por la que va (el ciclista tiene 2)
var paso: int = 0
# Bandera para que no se atienda dos veces (igual que is_dead en los enemigos)
var atendido: bool = false
var resultados: Array = []


func _ready() -> void:
	animated_sprite_2d.play("emergencia")
	# Marca: 0 = "!", 1 = correcto, 2 = incorrecto, 3 = "?"
	if caso_id == "esceptico":
		marca.frame = 3
	else:
		marca.frame = 0


func _process(_delta: float) -> void:
	# La marca sube y baja mientras la persona espera ayuda
	if not atendido:
		marca.position.y = -14.0 + sin(Time.get_ticks_msec() / 160.0) * 1.5


func pregunta_actual() -> Dictionary:
	return Casos.CASOS[caso_id]["preguntas"][paso]


# La mano de ayuda del Brigadista llama a esta funcion
func atender(_quien) -> void:
	if atendido:
		return
	atencion_solicitada.emit(self)


# Se llama cuando el jugador elige una respuesta
func reaccionar(ok: bool, tipo_anim: String) -> void:
	resultados.append(ok)

	if efecto_scene != null:
		var efecto: EfectoAyuda = efecto_scene.instantiate()
		get_parent().add_child(efecto)
		efecto.global_position = global_position + Vector2(0, -24)
		efecto.iniciar(tipo_anim, ok)

	if not ok:
		animated_sprite_2d.modulate = Color(1.0, 0.45, 0.45)
		var tween := create_tween()
		tween.tween_property(animated_sprite_2d, "modulate", Color.WHITE, 0.8)


# Se llama cuando el jugador pulsa "continuar" despues del resultado
func terminar_pregunta() -> void:
	paso += 1
	if paso >= Casos.CASOS[caso_id]["preguntas"].size():
		atendido = true
		var bien: bool = not resultados.has(false)
		if bien:
			animated_sprite_2d.play("bien")
			marca.frame = 1
		else:
			animated_sprite_2d.play("mal")
			marca.frame = 2
		marca.position.y = -14.0
		zona_atencion.set_deferred("monitorable", false)
