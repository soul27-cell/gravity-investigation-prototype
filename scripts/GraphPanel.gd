# scripts/GraphPanel.gd
extends Control

var points: Array = []

func set_points(new_points: Array) -> void:
    points = new_points
    queue_redraw()

func _draw() -> void:
    draw_rect(Rect2(Vector2.ZERO, size), Color(0.12, 0.12, 0.15), true)

    var plot_left := 40.0
    var plot_top := 20.0
    var plot_right := size.x - 20.0
    var plot_bottom := size.y - 30.0

    draw_rect(Rect2(Vector2(plot_left, plot_top), Vector2(plot_right - plot_left, plot_bottom - plot_top)), Color(0.25, 0.25, 0.25), false)

    if points.is_empty():
        return

    var min_x := 1e30
    var max_x := -1e30
    var min_y := 1e30
    var max_y := -1e30

    for p in points:
        if p.x < min_x:
            min_x = p.x
        if p.x > max_x:
            max_x = p.x
        if p.y < min_y:
            min_y = p.y
        if p.y > max_y:
            max_y = p.y

    if min_x == max_x:
        min_x -= 1.0
        max_x += 1.0
    if min_y == max_y:
        min_y -= 1.0
        max_y += 1.0

    for i in range(points.size() - 1):
        var p1: Vector2 = points[i]
        var p2: Vector2 = points[i + 1]

        var sx1 := remap_value(p1.x, min_x, max_x, plot_left, plot_right)
        var sy1 := remap_value(p1.y, min_y, max_y, plot_bottom, plot_top)
        var sx2 := remap_value(p2.x, min_x, max_x, plot_left, plot_right)
        var sy2 := remap_value(p2.y, min_y, max_y, plot_bottom, plot_top)

        draw_line(Vector2(sx1, sy1), Vector2(sx2, sy2), Color(0.2, 0.8, 1.0), 2.0)

    draw_string(get_theme_default_font(), Vector2(20, 18), "Force", Color(1, 1, 1))
    draw_string(get_theme_default_font(), Vector2(size.x - 90, size.y - 8), "Distance", Color(1, 1, 1))
