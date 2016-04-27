extends Node2D

const TERRAIN_TYPES = {
	"Grasslands": 0,
	"Swamp": 1,
	"Snow": 2,
	"Water": 3
}

var x_coord setget set_x_coord, get_x_coord
var y_coord setget set_y_coord, get_y_coord
	
func _ready():
	pass
	
func initialize_hex(sprite_image, center_x, center_y):
	var sprite = Sprite.new()
	sprite.set_texture(sprite_image)
	sprite.set_pos(Vector2(center_x, center_y))
	sprite.set_scale(Vector2(2, 2))
	add_child(sprite)
	
func set_x_coord(x):
	x_coord = x
	
func set_y_coord(y):
	y_coord = y
	
func get_x_coord():
	return x_coord
	
func get_y_coord():
	return y_coord
	
func _on_area_input_event(viewport, event, shape_idx):
	if (event.type == InputEvent.MOUSE_BUTTON and event.pressed):
		self.get_tree().set_input_as_handled()
		print("You clicked the hex at (" + str(get_x_coord()) + ", " + str(get_y_coord()) + ")")
	
	
	



