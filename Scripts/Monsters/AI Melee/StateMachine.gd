extends Node

var state = {
	"Idle": preload("res://Scripts/Monsters/AI Melee/IdleState.gd"),
	"Death": preload("res://Scripts/Monsters/AI Melee/DeathState.gd"),
	"Attack": preload("res://Scripts/Monsters/AI Melee/AttackState.gd"),
	"Run": preload("res://Scripts/Monsters/AI Melee/RunState.gd"),
}

func change_state(new_state: String):
	if get_child_count() != 0:
		if !("Death" in get_child(0).name):
			get_child(0).queue_free()
	if state.has(new_state):
		var state_temp = state[new_state].new()
		state_temp.name = new_state
		add_child(state_temp)
