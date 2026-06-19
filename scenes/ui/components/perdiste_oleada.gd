extends Control

func _on_reintentar_pressed() -> void:
	#GlobalJuego.perder_fe(5)
	$AnimationPlayer.play_backwards("ganaste la oldeada")
	
