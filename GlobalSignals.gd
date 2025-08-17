extends Node


signal UpdateInventory

var wood_item_data := preload("res://Inventory/Wood.tres") as ItemData
var stone_item_data := preload("res://Inventory/Stone.tres") as ItemData
var wooden_sticks_data := preload("res://Inventory/Wooden_Stick.tres") as ItemData
var wooden_axe_data := preload("res://Inventory/Wooden_Axe.tres") as ItemData
var wooden_pickaxe_data :=preload("res://Inventory/Wooden_Pickaxe.tres") as ItemData

var inventory_window: Node = null
