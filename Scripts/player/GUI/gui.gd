extends CanvasLayer


func _ready():
	$Container.visible = get_tree().paused
	get_node("hp_bar").max_value = Game.player_health
	$Container/Profile.hide()
	var GameNode = get_node(Game.get_path())
	GameNode.health_changed.connect(Callable(self, "_on_node_health_changed"))
	
func _physics_process(delta):
	if Input.is_action_just_pressed("Pause"):
		get_tree().paused = !get_tree().paused
		$Container.visible = get_tree().paused
		match get_tree().paused:
			true:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			false:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_inventory_button_pressed():
	$Container/VBoxContainer/InventoryButton.disabled = true
	$Container/VBoxContainer/Profile.disabled = false
	$Container/Inventory.show()
	$Container/Profile.hide()

func _on_profile_pressed():
	$Container/VBoxContainer/InventoryButton.disabled = false
	$Container/VBoxContainer/Profile.disabled = true
	$Container/Inventory.hide()
	$Container/Profile.show()


func _on_node_health_changed(damage: Variant) -> void:
	var tween = create_tween()
	tween.tween_property(get_node("hp_bar"), "value", get_node("hp_bar").value - damage, 0.2)
