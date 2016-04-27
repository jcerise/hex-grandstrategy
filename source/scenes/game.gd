
extends Node

const HEX_SIZE = 64

var TerrainHex = preload("hex.scn")

class Cube:
	var x
	var y
	var z
	
	func _init(x_value, y_value, z_value):
		x = x_value
		y = y_value
		z = z_value
	

func _ready():
	generate_hexes()
	set_process_input(true)
	
func generate_hexes():
	###
	# This function will create a board filled with hexes using an odd-1 vertical layout
	###
	var sprite_image = load("res://assets/Terrain/Grass.png")
	var viewport_width = get_viewport().get_rect().size[0]
	var viewport_height = get_viewport().get_rect().size[1]
	
	var hex_width = viewport_width / ((HEX_SIZE / 4) * 3)
	var hex_height = viewport_height / HEX_SIZE
	
	var x = HEX_SIZE / 2
	var y = HEX_SIZE / 2
	
	# Build an odd-q vertical layout for our hexes
	var odd = false
	for i in range(hex_height):
		# First, set up the y coordinates. The offset_y value is for each odd hex, that will be half a hex
		# height lower than its neighbors
		var row_y = y
		var offset_y = y + (HEX_SIZE / 2)
		for j in range(hex_width):	
			# Create a new hex instance
			var hex = TerrainHex.instance()
			# If this is an odd hex, set its height to a half hex lower than the previous hex, so the edges
			# align properly
			if odd:
				hex.initialize_hex(sprite_image, x, offset_y)
			else:
				hex.initialize_hex(sprite_image, x, row_y)
				
			# Set the coordinates for this hex
			hex.set_x_coord(j)
			hex.set_y_coord(i)
				
			# Finally, add the hex to the node so it will be displayed
			add_child(hex)
			
			# Increment the x value for the next hex to 3/4 of the hex width, so it will sit snugly against
			# its neighbor
			x += (HEX_SIZE / 4) * 3
			odd = !odd
		# Move down one row, and reset x
		x = HEX_SIZE / 2
		y += HEX_SIZE
		odd = false
		
func pixel_to_hex(x, y):
	var q = ((x / 3) * 2) / (HEX_SIZE / 2)
	var r = (-x/ 3 + sqrt(3) / 3 * y) / (HEX_SIZE / 2)
	var hex = hex_round(q, r)
	print("(" + str(hex.q) + ", " + str(hex.r) + ")")
	
func hex_to_cube(q, r):
    var x = q
    var z = r
    var y = -x-z
    return Cube.new(x, y, z)

func cube_to_hex(h):
    var q = h.x
    var r = h.y
    return {"q": q, "r": r}

func cube_round(h):
    var rx = round(h.x)
    var ry = round(h.y)
    var rz = round(h.z)

    var x_diff = abs(rx - h.x)
    var y_diff = abs(ry - h.y)
    var z_diff = abs(rz - h.z)

    if x_diff > y_diff and x_diff > z_diff:
        rx = -ry-rz
    elif y_diff > z_diff:
        ry = -rx-rz
    else:
        rz = -rx-ry

    return Cube.new(rx, ry, rz)

func hex_round(q, r):
    return cube_to_hex(cube_round(hex_to_cube(q, r)))
	
func _input(event):
	if (event.type == InputEvent.MOUSE_BUTTON and event.pressed):
		pixel_to_hex(event.x, event.y)
	
	


