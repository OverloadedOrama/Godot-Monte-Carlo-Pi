extends Node2D

var r := 280 #Radius of the circle
var points : PoolVector2Array = []
var rect := Rect2(450, 25, 2 * r, 2 * r)
var rect_center : Vector2 #Center of the rectangle, circle's position
var points_inside_circle := 0
var pi_approx := 3.14

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#I'm not sure if it's necessary to include randomize(), as the simulation
	#seems to work and without it
	randomize()
	rect_center = rect.position + (rect.end - rect.position) / 2

func _draw() -> void:
	draw_rect(rect, Color.black)
	draw_circle(rect_center, r, Color(0.1, 0.1, 0.1, 1))
	for point in points:
		if point.distance_to(rect_center) < r:
			draw_primitive([point], [Color.orangered], [point])
		else:
			draw_primitive([point], [Color.white], [point])
	
	$VBoxContainer/TotalPoints.text = "Total points: %s" % points.size()
	$VBoxContainer/PointsInCircle.text = "Points in circle: %s" % points_inside_circle
	$VBoxContainer/PiApproximation.text = "Pi approximation: 4 * %s/%s = %s" % [points_inside_circle, points.size(), pi_approx]

#Generate random point
func _on_Timer_timeout() -> void:
	#If you want the simulation to generate more than 1 point at a time, ...
	#... you can always include this piece of code in a for loop
	var point := Vector2()
	point.x = rand_range(rect.position.x, rect.end.x)
	point.y = rand_range(rect.position.y, rect.end.y)
	if point.distance_to(rect_center) < r:
		points_inside_circle += 1
	points.append(point)
	
	pi_approx = 4.0 * points_inside_circle / points.size()
	update()

#Start and stop the simulation
func _on_Button_toggled(button_pressed) -> void:
	if button_pressed:
		$Timer.stop()
		$VBoxContainer/Button.text = "Start"
	else:
		$Timer.start()
		$VBoxContainer/Button.text = "Stop"
