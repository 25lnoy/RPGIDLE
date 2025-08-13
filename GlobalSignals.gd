extends Node


signal UpdateInventory

var wood_item_data := preload("res://Inventory/Wood.tres") as ItemData
var stone_item_data := preload("res://Inventory/Stone.tres") as ItemData

var inventory_window: Node = null
