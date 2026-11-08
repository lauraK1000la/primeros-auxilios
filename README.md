# Primeros Auxilios (Godot 4.7)

Juego de decisiones con movimiento estilo Zelda, hecho reciclando el codigo de **Zelda-1986**.

## Como abrirlo
1. Abre Godot 4.7 y en el Administrador de proyectos pulsa **Importar**.
2. Elige el archivo `project.godot` de esta carpeta.
3. Espera a que Godot importe las imagenes y sonidos (la primera vez tarda unos segundos).
4. Pulsa **F5** (o el boton de play). La escena principal ya es `Scenes/World/scene_game.tscn`.

## Controles
- **Flechas o W A S D**: caminar (igual que en el Zelda).
- **E, Espacio o clic**: extender la mano de ayuda (equivale a ATACAR) y atender a una persona.
- **1, 2, 3 o clic**: elegir una respuesta.
- **Espacio / clic**: continuar despues de ver el resultado.

## Que se reciclo de tu proyecto
| Zelda-1986 | Primeros Auxilios |
|---|---|
| `FV_player.gd` (movimiento, animaciones, `can_move`, `move_screen_transition`) | `Scripts/Player/brigadista.gd` |
| `SwordHitbox` + `_on_sword_hitbox_area_entered` + `take_damage()` | `AyudaHitbox` + `_on_ayuda_hitbox_area_entered` + `atender()` |
| Grupo `ENEMIES` (global group) | Grupo `PACIENTES` |
| `FV_octorok.gd` / `zola.gd` (CharacterBody2D con AnimatedSprite2D, `ZoneDamagebox`) | `Scripts/Pacientes/paciente.gd` (`ZonaAtencion`) |
| `FV_death_effect` (efecto que se instancia y hace `queue_free`) | `Scripts/Effects/efecto_ayuda.gd` |
| `screen_transition.gd` (camara 256x176 + 4 Area2D en los bordes) | `Scripts/World/screen_transition.gd` |
| `scene_game.tscn` (Tiles_Group, TileMapLayer con fisica, Camera2D, instancias) | `Scenes/World/scene_game.tscn` |
| Capas de colision (jugador 2, tiles 1, espada 4/8, borde 524288) | Se mantienen igual |
| Musica `exploration.wav` y sonidos | `Assets/Audio/` |
| `project.godot`: resolucion 256x176, entradas IZQUIERDA/DERECHA/ARRIBA/ABAJO | Igual, con `AYUDAR` en lugar de `ATACAR` |

## Como agregar otra persona (igual que instanciar otro Octorok)
1. Duplica una escena de `Scenes/Pacientes/` y cambia su imagen en `Assets/Pacientes/`.
2. En el Inspector cambia `caso_id`.
3. Agrega el caso con sus preguntas en `Scripts/Data/casos.gd`.
4. Arrastra la escena a `scene_game.tscn` y colocala en el mapa.
