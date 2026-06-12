extends MenuBar
@onready var video_menu: MenuBar = $video_menu
@onready var sonido_menu: MenuBar = $sonido_menu
@onready var controles_menu: MenuBar = $controles_menu
@onready var accesibilidad_menu: MenuBar = $accesibilidad_menu
@onready var opciones: MenuBar = $"."

func _ready() -> void:
	esconder_todo()

	pass
func esconder_todo() -> void:
	video_menu.visible=false
	sonido_menu.visible=false
	controles_menu.visible=false
	accesibilidad_menu.visible=false
	
	
func _on_sonido_pressed() -> void:
	Sonidos.boton1()
	esconder_todo()
	sonido_menu.visible=true

func _on_video_pressed() -> void:
	Sonidos.boton1()
	esconder_todo()
	video_menu.visible=true

func _on_controles_pressed() -> void:
	Sonidos.boton1()
	esconder_todo()
	controles_menu.visible=true

func _on_accesibilidad_pressed() -> void:
	Sonidos.boton1()
	esconder_todo()
	accesibilidad_menu.visible=true

func _on_volver_pressed() -> void:
	Sonidos.boton1()
	esconder_todo()
	opciones.visible=false
	
