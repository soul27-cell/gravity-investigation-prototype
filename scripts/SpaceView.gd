# scripts/SpaceView.gd
extends Control

var mass_1: float = 10000000.0
var mass_2: float = 25000000.0
var distance_km: float = 100000.0

func update_visuals(p_mass_1: float, p_mass_2: float, p_distance_km: float) -> void:
    mass_1 = p_mass_1
    mass_2 = p_mass_2
    distance_km = p_distance_km
    queue_redraw()

func _draw() -> void:
    draw_rect(Rect2(Vector2.ZERO, size), Color(0.05, 0.08, 0.15), true)

    var left_x := 80.0
    var right_x := size.x - 80.0
    var center_y := size.y / 2.0

    var radius_a := clamp(log(mass_1 + 1.0) / 18.0, 16.0, 42.0)
    var radius_b := clamp(log(mass_2 + 1.0) / 18.0, 16.0, 42.0)

    draw_line(Vector2(left_x, center_y), Vector2(right_x, center_y), Color(0.55, 0.75, 1.0), 2.0)
    draw_circle(Vector2(left_x, center_y), radius_a, Color(0.3, 0.6, 1.0))
    draw_circle(Vector2(right_x, center_y), radius_b, Color(1.0, 0.7, 0.3))

    draw_string(get_theme_default_font(), Vector2(40, 30), "Object A", Color(1, 1, 1))
    draw_string(get_theme_default_font(), Vector2(size.x - 160, 30), "Object B", Color(1, 1, 1))
    draw_string(get_theme_default_font(), Vector2(20, size.y - 20), "Distance: %d km" % int(distance_km), Color(1, 1, 1))
