extends MenuBar
@onready var video_menu: MenuBar = $video_menu
@onready var sonido_menu: MenuBar = $sonido_menu
@onready var controles_menu: MenuBar = $controles_menu
@onready var accecibilidad_menu: MenuBar = $accecibilidad_menu
@onready var opciones: MenuBar = $"."

func _ready() -> void:
	esconder_todo()

	pass
func esconder_todo() -> void:
	video_menu.visible=false
	sonido_menu.visible=false
	controles_menu.visible=false
	accecibilidad_menu.visible=false
	
	pass
	
func _on_sonido_pressed() -> void:
	esconder_todo()
	sonido_menu.visible=true
	
	pass

func _on_boton_video_pressed() -> void:
	esconder_todo()
	video_menu.visible=true
	pass


func _on_boton_accecibilidad_pressed() -> void:
	esconder_todo()
	accecibilidad_menu.visible=true
	pass # Replace with function body.


func _on_volver_pressed() -> void:
	esconder_todo()
	opciones.visible=false
	
	pass # Replace with function body.


func _on_boton_controles_pressed() -> void:
	esconder_todo()
	controles_menu.visible=true
	pass # Replace with function body.
