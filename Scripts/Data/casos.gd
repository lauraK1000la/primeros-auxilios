class_name Casos
extends RefCounted
# Cada caso es una persona (Paciente) con una o mas preguntas de decision.
# "anim" indica que efecto visual aparece cuando respondes bien:
# cono, llamar, presion, agua, heimlich, hablar

const CASOS := {
	"ciclista": {
		"preguntas": [
			{
				"npc": "Profe Andrés",
				"anim": "cono",
				"texto": "Un compañero se cayó de la bicicleta y está en el suelo, quejándose. ¿Qué haces primero?",
				"opciones": [
					{"texto": "Verificar que el lugar sea seguro y luego revisarlo.", "puntos": 15,
						"feedback": "Correcto. Primero Proteger: si tú te lesionas, no puedes ayudar a nadie."},
					{"texto": "Levantarlo ya para llevarlo a la sombra.", "puntos": -10,
						"feedback": "Moverlo sin revisar puede empeorar una lesión de cuello o espalda."},
					{"texto": "Quedarme mirando a ver si se levanta solo.", "puntos": -5,
						"feedback": "Perder tiempo puede ser grave. Actúa con calma y con orden."},
				],
			},
			{
				"npc": "Compañera Laura",
				"anim": "llamar",
				"texto": "Se golpeó la cabeza y está muy mareado. ¿Cómo pides ayuda?",
				"opciones": [
					{"texto": "Llamar al 123, decir dónde estamos y qué pasó.", "puntos": 15,
						"feedback": "Correcto. Avisar: da la ubicación, qué ocurrió y cuántos heridos hay."},
					{"texto": "Publicar un video en redes para que alguien ayude.", "puntos": -10,
						"feedback": "Las redes no son un servicio de emergencia y se pierde tiempo."},
					{"texto": "Esperar un rato a ver si mejora.", "puntos": -5,
						"feedback": "Un golpe en la cabeza con mareo debe ser valorado por personal de salud."},
				],
			},
		],
	},
	"corte": {
		"preguntas": [
			{
				"npc": "Juan (herido)",
				"anim": "presion",
				"texto": "Juan se cortó el brazo con una lámina y sangra bastante. ¿Qué haces?",
				"opciones": [
					{"texto": "Presionar la herida con gasa o tela limpia y mantener la presión.", "puntos": 15,
						"feedback": "Correcto. La presión directa y continua es la mejor forma de frenar el sangrado."},
					{"texto": "Echarle café o pasta de dientes para que cierre.", "puntos": -10,
						"feedback": "Son mitos: no ayudan y aumentan el riesgo de infección."},
					{"texto": "Quitar la tela cada pocos segundos para ver si paró.", "puntos": -5,
						"feedback": "Al retirarla se interrumpe la coagulación. Mantén la presión."},
				],
			},
		],
	},
	"quemadura": {
		"preguntas": [
			{
				"npc": "Doña Rosa (cafetería)",
				"anim": "agua",
				"texto": "Me quemé la mano con agua caliente haciendo el tinto. ¡Me arde mucho!",
				"opciones": [
					{"texto": "Ponerla bajo agua fría corriente de 10 a 20 minutos y cubrirla con gasa limpia.", "puntos": 15,
						"feedback": "Correcto. El agua fría corriente reduce el daño y el dolor en quemaduras leves."},
					{"texto": "Ponerle hielo directo sobre la piel.", "puntos": -10,
						"feedback": "El hielo directo puede dañar más el tejido. Usa agua fría, no helada."},
					{"texto": "Aplicarle mantequilla o pasta de dientes.", "puntos": -10,
						"feedback": "Atrapan el calor y pueden infectar la quemadura. No se recomiendan."},
				],
			},
		],
	},
	"atragantado": {
		"preguntas": [
			{
				"npc": "Mateo (atragantado)",
				"anim": "heimlich",
				"texto": "Mateo se atraganta: no puede toser, hablar ni respirar y se agarra el cuello. ¿Qué haces?",
				"opciones": [
					{"texto": "Pedir que llamen al 123 y hacerle la maniobra de Heimlich.", "puntos": 15,
						"feedback": "Correcto. Si no puede toser ni respirar, hay que actuar ya. Si tose fuerte, anímalo a seguir."},
					{"texto": "Darle agua para que pase la comida.", "puntos": -10,
						"feedback": "Con la vía aérea bloqueada, el agua no pasa y empeora la situación."},
					{"texto": "Acostarlo y esperar a que se le pase.", "puntos": -10,
						"feedback": "Sin aire se pierde el conocimiento en pocos minutos. Hay que actuar ya."},
				],
			},
		],
	},
	"esceptico": {
		"preguntas": [
			{
				"npc": "Camilo (compañero)",
				"anim": "hablar",
				"texto": "¿Para qué aprender primeros auxilios si para eso están los médicos y las ambulancias?",
				"opciones": [
					{"texto": "Explicarle que la ayuda tarda y que lo que hagamos antes puede salvar una vida.", "puntos": 15,
						"feedback": "Muy bien: los primeros minutos son clave y cualquiera puede ayudar si sabe qué hacer."},
					{"texto": "Burlarme de él delante de todos.", "puntos": -10,
						"feedback": "Burlarse aleja a la gente. Un líder motiva a aprender."},
					{"texto": "Ignorarlo y seguir con mi tarea.", "puntos": 0,
						"feedback": "No es grave, pero perdiste la oportunidad de sumar a un compañero a la brigada."},
				],
			},
		],
	},
}
