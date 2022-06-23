extends TileMap

onready var cellSize = get_parent().cellSize
onready var horCellNum = get_parent().horCellNum
onready var verCellNum = get_parent().verCellNum


func _ready():
	for x in range(horCellNum):
		for y in range(verCellNum):
			set_cell(x, y, self.tile_set.find_tile_by_name("sea"))
