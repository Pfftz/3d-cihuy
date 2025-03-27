extends Control



func _process(delta):
	get_node("stats_label").text = "
	Player Health: %s
	\nPlayer Attack: %s
	\nPlayer Defense: %s
	\nPlayer Level: %s
	\nPlayer Exp: %s / %s" % [Game.player_health,Game.right_hand_equipped.item_damage,Game.right_hand_equipped.item_defense,Game.player_level, Game.current_exp, Game.exp_to_next_level]
	
