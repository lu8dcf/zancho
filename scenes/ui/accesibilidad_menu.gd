extends MenuBar

@onready var check_button: CheckButton = $multi/CheckButton

func _ready() -> void:
	check_button.disabled = true
