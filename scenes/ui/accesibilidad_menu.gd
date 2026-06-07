extends MenuBar

@onready var check_button: CheckButton = $multi/CheckButton

func _ready() -> void:
	check_button.disabled = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
