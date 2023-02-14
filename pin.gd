extends Area2D

var mouseEntered:bool
@export var id:int=0
var num:int=0
@onready var Rope=get_parent().get_node("Rope")

func _ready():
	match (id):
		0:
			num=0
		2:
			num=ceil(Rope.RopeLenght/Rope.Restric)-1
		

func _on_mouse_entered():
	mouseEntered=true


func _on_mouse_exited():
	mouseEntered=false

func _unhandled_input(event:InputEvent)->void:
	if event is InputEventMouseMotion and mouseEntered:
		if Input.is_action_pressed("click"):
			position=get_global_mouse_position()
			Rope.setPoint(get_global_mouse_position(),num)
			


