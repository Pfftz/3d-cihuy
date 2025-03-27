extends Node

var items: Dictionary = {
	"Long Sword": preload("res://Scenes/player/GUI/Inventory/long_sword.tres"),
	"Iron Sword": preload("res://Scenes/player/GUI/Inventory/iron_sword.tres"),
	"Small Potion": preload("res://Scenes/player/GUI/Inventory/small_potion.tres"),
}

signal health_changed(damage)
var right_hand_equipped: ItemData = items["default"]

var player_health: int = 10
var player_max_health: int = 10

var player_damage:int = 2
var player_defense: int = 0

var current_exp: int = 0
var exp_to_next_level: int = 100
var player_level: int = 1

func _ready():
	gain_exp(1000)

func gain_exp(experience):
	current_exp += experience
	while current_exp >= exp_to_next_level:
		#level up
		player_level += 1
		current_exp -= exp_to_next_level
		exp_to_next_level = round(exp_to_next_level * 1.3)
		exp_to_next_level = exp_to_next_level * pow(1.2, player_level - 1)

func damage_player(damage):
	self.emit_signal("health_changed", damage)
	player_health -= damage

func heal_player(amount):
	self.emit_signal("health_changed", -amount)
	player_health += amount