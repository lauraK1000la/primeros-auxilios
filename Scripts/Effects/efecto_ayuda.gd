class_name EfectoAyuda
extends Node2D
# Equivale a FV_death_effect.gd: se instancia al lado del personaje, se anima
# y se elimina solo con queue_free().

# Cuadro de efectos.png para cada tipo de ayuda
const TIPOS := {
	"cono": 0,
	"llamar": 1,
	"presion": 2,
	"agua": 3,
	"heimlich": 4,
	"hablar": 5,
}
const FRAME_MAL := 6

@onready var sprite_2d: Sprite2D = $Sprite2D


func iniciar(tipo: String, ok: bool) -> void:
	if ok:
		sprite_2d.frame = TIPOS.get(tipo, 0)
	else:
		sprite_2d.frame = FRAME_MAL

	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "position:y", position.y - 10.0, 1.4)
	tween.tween_property(self, "modulate:a", 0.0, 0.4).set_delay(1.1)
	tween.chain().tween_callback(queue_free)
