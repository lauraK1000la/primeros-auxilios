class_name UIJuego
extends CanvasLayer
# Toda la interfaz se crea por codigo (HUD, panel de preguntas y pantalla final).
# La resolucion del proyecto es 256x176, igual que en el Zelda.

signal opcion_elegida(indice: int)
signal continuar
signal reiniciar

enum Estado { OCULTO, PREGUNTA, FEEDBACK_ANIM, FEEDBACK_LISTO, FINAL }

const ANCHO := 256.0
const ALTO := 176.0
const COLOR_PANEL := Color(0.05, 0.08, 0.18, 0.95)

var estado: Estado = Estado.OCULTO
var final_listo: bool = false
var n_opciones: int = 0

var barra_relleno: ColorRect
var lbl_seguridad: Label
var lbl_atendidos: Label

var panel: ColorRect
var caja: VBoxContainer
var lbl_npc: Label
var lbl_texto: Label
var opciones_box: VBoxContainer
var lbl_feedback: Label
var lbl_continuar: Label

var panel_final: ColorRect
var lbl_final_titulo: Label
var lbl_final_texto: Label
var lbl_final_reiniciar: Label


func _ready() -> void:
	layer = 10
	_crear_hud()
	_crear_panel()
	_crear_final()
	panel.hide()
	panel_final.hide()


# ------------------------------------------------------------ CONSTRUCCION

func _crear_label(padre: Node, tam: int, ancho: float = 0.0) -> Label:
	var l := Label.new()
	l.add_theme_font_size_override("font_size", tam)
	if ancho > 0.0:
		l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		l.custom_minimum_size = Vector2(ancho, 0.0)
	padre.add_child(l)
	return l


func _crear_hud() -> void:
	var fondo := ColorRect.new()
	fondo.color = Color(0, 0, 0, 0.55)
	fondo.position = Vector2(0, 0)
	fondo.size = Vector2(ANCHO, 12)
	add_child(fondo)

	var barra_fondo := ColorRect.new()
	barra_fondo.color = Color(0.3, 0.12, 0.12)
	barra_fondo.position = Vector2(4, 3)
	barra_fondo.size = Vector2(60, 6)
	add_child(barra_fondo)

	barra_relleno = ColorRect.new()
	barra_relleno.color = Color(0.3, 0.8, 0.4)
	barra_relleno.position = Vector2(4, 3)
	barra_relleno.size = Vector2(24, 6)
	add_child(barra_relleno)

	lbl_seguridad = _crear_label(self, 8)
	lbl_seguridad.position = Vector2(68, 0)
	lbl_atendidos = _crear_label(self, 8)
	lbl_atendidos.position = Vector2(160, 0)


func _crear_panel() -> void:
	panel = ColorRect.new()
	panel.color = COLOR_PANEL
	add_child(panel)

	caja = VBoxContainer.new()
	caja.add_theme_constant_override("separation", 3)
	panel.add_child(caja)

	lbl_npc = _crear_label(caja, 9, 236.0)
	lbl_npc.add_theme_color_override("font_color", Color(1.0, 0.85, 0.3))

	lbl_texto = _crear_label(caja, 8, 236.0)

	opciones_box = VBoxContainer.new()
	opciones_box.add_theme_constant_override("separation", 2)
	caja.add_child(opciones_box)

	lbl_feedback = _crear_label(caja, 8, 236.0)

	lbl_continuar = _crear_label(caja, 8, 236.0)
	lbl_continuar.text = "[Espacio / clic] Continuar"
	lbl_continuar.add_theme_color_override("font_color", Color(1.0, 0.9, 0.5))


func _crear_final() -> void:
	panel_final = ColorRect.new()
	panel_final.color = Color(0.04, 0.06, 0.14, 0.97)
	panel_final.position = Vector2(0, 0)
	panel_final.size = Vector2(ANCHO, ALTO)
	add_child(panel_final)

	var caja_final := VBoxContainer.new()
	caja_final.add_theme_constant_override("separation", 8)
	caja_final.position = Vector2(14, 20)
	caja_final.size = Vector2(ANCHO - 28.0, 10.0)
	panel_final.add_child(caja_final)

	lbl_final_titulo = _crear_label(caja_final, 14, ANCHO - 28.0)
	lbl_final_texto = _crear_label(caja_final, 8, ANCHO - 28.0)
	lbl_final_reiniciar = _crear_label(caja_final, 8, ANCHO - 28.0)
	lbl_final_reiniciar.text = "[Espacio / clic] Jugar de nuevo"
	lbl_final_reiniciar.add_theme_color_override("font_color", Color(1.0, 0.9, 0.5))


func _estilo_boton(b: Button) -> void:
	for nombre in ["normal", "hover", "pressed", "focus"]:
		var sb := StyleBoxFlat.new()
		if nombre == "hover":
			sb.bg_color = Color(0.28, 0.34, 0.6)
		else:
			sb.bg_color = Color(0.16, 0.2, 0.38)
		sb.content_margin_left = 3
		sb.content_margin_right = 3
		sb.content_margin_top = 2
		sb.content_margin_bottom = 2
		b.add_theme_stylebox_override(nombre, sb)


func _ajustar_panel(arriba: float) -> void:
	panel.position = Vector2(0.0, arriba)
	panel.size = Vector2(ANCHO, ALTO - arriba)
	caja.position = Vector2(10.0, 4.0)
	caja.size = Vector2(ANCHO - 20.0, 10.0)


func _limpiar_opciones() -> void:
	for h in opciones_box.get_children():
		opciones_box.remove_child(h)
		h.queue_free()


# ------------------------------------------------------------ API PUBLICA

func actualizar_hud(medidor: int, atendidos: int, total: int) -> void:
	lbl_seguridad.text = "Seguridad %d/100" % medidor
	lbl_atendidos.text = "Atendidos %d/%d" % [atendidos, total]
	barra_relleno.size.x = 60.0 * medidor / 100.0
	if medidor < 35:
		barra_relleno.color = Color(0.9, 0.25, 0.25)
	elif medidor < 60:
		barra_relleno.color = Color(0.95, 0.7, 0.2)
	else:
		barra_relleno.color = Color(0.3, 0.8, 0.4)


func mostrar_pregunta(npc: String, texto: String, opciones: Array) -> void:
	estado = Estado.PREGUNTA
	n_opciones = opciones.size()
	lbl_npc.text = npc
	lbl_texto.text = texto
	lbl_texto.show()
	lbl_feedback.hide()
	lbl_continuar.hide()

	_limpiar_opciones()
	for i in opciones.size():
		var b := Button.new()
		b.text = "%d. %s" % [i + 1, opciones[i]["texto"]]
		b.alignment = HORIZONTAL_ALIGNMENT_LEFT
		b.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		b.focus_mode = Control.FOCUS_NONE
		b.custom_minimum_size = Vector2(236.0, 0.0)
		b.add_theme_font_size_override("font_size", 8)
		_estilo_boton(b)
		b.pressed.connect(_elegir.bind(i))
		opciones_box.add_child(b)
	opciones_box.show()

	_ajustar_panel(54.0)
	panel.show()


func mostrar_feedback(texto: String, ok: bool) -> void:
	estado = Estado.FEEDBACK_ANIM
	_limpiar_opciones()
	opciones_box.hide()
	lbl_texto.hide()
	lbl_feedback.text = texto
	if ok:
		lbl_feedback.add_theme_color_override("font_color", Color(0.6, 1.0, 0.7))
	else:
		lbl_feedback.add_theme_color_override("font_color", Color(1.0, 0.72, 0.62))
	lbl_feedback.show()
	lbl_continuar.hide()
	_ajustar_panel(92.0)

	# Esperamos a que termine el efecto antes de dejar continuar
	await get_tree().create_timer(1.4).timeout
	if estado == Estado.FEEDBACK_ANIM:
		estado = Estado.FEEDBACK_LISTO
		lbl_continuar.show()


func ocultar_panel() -> void:
	estado = Estado.OCULTO
	panel.hide()


func mostrar_final(titulo: String, texto: String, color: Color) -> void:
	estado = Estado.FINAL
	final_listo = false
	panel.hide()
	lbl_final_titulo.text = titulo
	lbl_final_titulo.add_theme_color_override("font_color", color)
	lbl_final_texto.text = texto
	panel_final.show()
	await get_tree().create_timer(0.8).timeout
	final_listo = true


# ------------------------------------------------------------ ENTRADA

func _elegir(indice: int) -> void:
	if estado != Estado.PREGUNTA:
		return
	estado = Estado.FEEDBACK_ANIM
	opcion_elegida.emit(indice)


func _input(event: InputEvent) -> void:
	if estado == Estado.PREGUNTA:
		var tecla := event as InputEventKey
		if tecla != null and tecla.pressed and not tecla.echo:
			var idx := -1
			if tecla.keycode == KEY_1 or tecla.keycode == KEY_KP_1:
				idx = 0
			elif tecla.keycode == KEY_2 or tecla.keycode == KEY_KP_2:
				idx = 1
			elif tecla.keycode == KEY_3 or tecla.keycode == KEY_KP_3:
				idx = 2
			if idx >= 0 and idx < n_opciones:
				_elegir(idx)
	elif estado == Estado.FEEDBACK_LISTO:
		if event.is_action_pressed("AYUDAR"):
			estado = Estado.OCULTO
			continuar.emit()
	elif estado == Estado.FINAL:
		if final_listo and event.is_action_pressed("AYUDAR"):
			final_listo = false
			reiniciar.emit()
