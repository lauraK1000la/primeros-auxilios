extends Node2D
# Script de la escena principal (scene_game). Conecta a los pacientes (grupo
# PACIENTES) con la interfaz y lleva el puntaje, igual que el proyecto de Zelda
# conecta a los enemigos (grupo ENEMIES) con el jugador.

const GANAR_CON := 75

var medidor: int = 40
var atendidos: int = 0
var total_pacientes: int = 0

var caso_actual: Paciente = null
var pregunta_actual: Dictionary = {}

@onready var brigadista: Brigadista = $Brigadista
@onready var ui: UIJuego = $UIJuego
@onready var musica: AudioStreamPlayer = $MusicaAmbiental
@onready var sfx_ok: AudioStreamPlayer = $SfxOk
@onready var sfx_mal: AudioStreamPlayer = $SfxMal
@onready var sfx_fin_ok: AudioStreamPlayer = $SfxFinOk
@onready var sfx_fin_mal: AudioStreamPlayer = $SfxFinMal


func _ready() -> void:
	# La musica ambiental se repite siempre
	musica.finished.connect(musica.play)

	var pacientes := get_tree().get_nodes_in_group("PACIENTES")
	total_pacientes = pacientes.size()
	for p in pacientes:
		var paciente: Paciente = p
		paciente.atencion_solicitada.connect(_on_atencion_solicitada)

	ui.opcion_elegida.connect(_on_opcion_elegida)
	ui.continuar.connect(_on_continuar)
	ui.reiniciar.connect(_on_reiniciar)
	_actualizar_hud()


func _actualizar_hud() -> void:
	ui.actualizar_hud(medidor, atendidos, total_pacientes)


# El brigadista toco a un paciente con la mano de ayuda
func _on_atencion_solicitada(paciente: Paciente) -> void:
	if caso_actual != null or paciente.atendido:
		return
	caso_actual = paciente
	brigadista.can_move = false
	pregunta_actual = paciente.pregunta_actual()
	ui.mostrar_pregunta(pregunta_actual["npc"], pregunta_actual["texto"], pregunta_actual["opciones"])


func _on_opcion_elegida(indice: int) -> void:
	var op: Dictionary = pregunta_actual["opciones"][indice]
	var pts: int = op["puntos"]
	medidor = clampi(medidor + pts, 0, 100)

	var texto: String = op["feedback"]
	if pts == 0:
		texto = "Ojo: " + texto
	elif pts < 0:
		texto = "Incorrecto: " + texto
	var signo := "+" if pts > 0 else ""
	texto += "  (%s%d)" % [signo, pts]

	# El paciente muestra el efecto de ayuda (o de error)
	caso_actual.reaccionar(pts > 0, pregunta_actual["anim"])

	if pts > 0:
		sfx_ok.play()
	else:
		sfx_mal.play()

	ui.mostrar_feedback(texto, pts > 0)
	_actualizar_hud()


func _on_continuar() -> void:
	var paciente := caso_actual
	caso_actual = null
	paciente.terminar_pregunta()
	if paciente.atendido:
		atendidos += 1
	ui.ocultar_panel()
	_actualizar_hud()

	if medidor <= 0 or atendidos >= total_pacientes:
		await get_tree().create_timer(0.8).timeout
		_mostrar_final()
		return

	# Pequena pausa para que la misma pulsacion no active otra ayuda
	await get_tree().create_timer(0.2).timeout
	brigadista.can_move = true


func _mostrar_final() -> void:
	musica.stop()
	var resumen := "Atendiste %d de %d personas.\nNivel de seguridad: %d / 100." % [atendidos, total_pacientes, medidor]
	var nota := "\n\nRecuerda: Proteger, Avisar y Socorrer. Este juego es educativo y no reemplaza un curso de primeros auxilios."

	if medidor <= 0:
		sfx_fin_mal.play()
		ui.mostrar_final("Intenta de nuevo", "Las decisiones fueron peligrosas.\n" + resumen + nota, Color(1.0, 0.45, 0.4))
	elif medidor >= GANAR_CON:
		sfx_fin_ok.play()
		ui.mostrar_final("¡Héroe de primeros auxilios!", "Actuaste con calma y tomaste buenas decisiones.\n" + resumen + nota, Color(0.5, 1.0, 0.6))
	elif medidor >= 50:
		sfx_fin_ok.play()
		ui.mostrar_final("Buen intento", "Sabes lo básico, pero aún hay decisiones por afinar.\n" + resumen + nota, Color(1.0, 0.85, 0.3))
	else:
		sfx_fin_mal.play()
		ui.mostrar_final("Te falta práctica", "Repasa el orden correcto y vuelve a jugar.\n" + resumen + nota, Color(1.0, 0.6, 0.4))


func _on_reiniciar() -> void:
	get_tree().reload_current_scene()
