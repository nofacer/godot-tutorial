extends TileMap

onready var cellSize = get_parent().cellSize
onready var horCellNum = get_parent().horCellNum
onready var verCellNum = get_parent().verCellNum
onready var width = get_parent().width
onready var height = get_parent().height

enum Topography { WATER, LAND }
var topographyMap = {Topography.WATER: "water", Topography.LAND: "land"}
var threshold = {Topography.WATER: 0.5, Topography.LAND: 1}


func getTopography(value):
	for key in threshold:
		if value <= threshold[key]:
			return topographyMap[key]


func getnx(xValue):
	xValue += xValue * cellSize + (self.cellSize / 2)
	return float(2 * xValue) / self.width - 1


func getny(yValue):
	yValue += yValue * cellSize + (self.cellSize / 2)
	return float(2 * yValue) / self.height - 1


func calDistance(nx, ny):
	var d = min(1, (nx * nx + ny * ny) / sqrt(2))
	return d


func getIslandNoise(noise, x, y):
	var noiseValue = (noise.get_noise_2d(x, y) + 1) / 2
	var nx = getnx(x)
	var ny = getny(y)
	var d = self.calDistance(nx, ny)
	noiseValue = (noiseValue + (1 - d)) / 2
	return noiseValue


func _ready():
	randomize()
	var noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.octaves = 4
	noise.period = 20.0
	noise.persistence = 0.8

	for y in range(verCellNum):
		for x in range(horCellNum):
			var curNoiseValue = getIslandNoise(noise, x, y)
			var topography = getTopography(curNoiseValue)
			if topography == "land":
				set_cell(x, y, 0)
	update_bitmask_region()
