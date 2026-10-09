# scripts/MainScene.gd
extends Control

const PhysicsCalculator = preload("res://scripts/PhysicsCalculator.gd")
const UnitConverter = preload("res://scripts/UnitConverter.gd")
const TrialRecord = preload("res://scripts/TrialRecord.gd")
const TrialHistory = preload("res://scripts/TrialHistory.gd")

@onready var mass1_slider: HSlider = $VBoxContainer/MainRow/ControlPanel/Mass1Slider
@onready var mass2_slider: HSlider = $VBoxContainer/MainRow/ControlPanel/Mass2Slider
@onready var distance_slider: HSlider = $VBoxContainer/MainRow/ControlPanel/DistanceSlider

@onready var mass1_value: Label = $VBoxContainer/MainRow/ControlPanel/Mass1Value
@onready var mass2_value: Label = $VBoxContainer/MainRow/ControlPanel/Mass2Value
@onready var distance_value: Label = $VBoxContainer/MainRow/ControlPanel/DistanceValue
@onready var force_value: Label = $VBoxContainer/MainRow/ControlPanel/ForceValue

@onready var run_experiment_button: Button = $VBoxContainer/MainRow/ControlPanel/RunExperimentButton
@onready var set_baseline_button: Button = $VBoxContainer/MainRow/ControlPanel/SetBaselineButton

@onready var variable_option: OptionButton = $VBoxContainer/PredictionContainer/VariableOption
@onready var relation_option: OptionButton = $VBoxContainer/PredictionContainer/RelationOption
@onready var prediction_value_edit: LineEdit = $VBoxContainer/PredictionContainer/PredictionValueEdit
@onready var submit_prediction_button: Button = $VBoxContainer/PredictionContainer/SubmitPredictionButton
@onready var prediction_feedback_label: Label = $VBoxContainer/PredictionContainer/PredictionFeedbackLabel

@onready var add_trial_button: Button = $VBoxContainer/TrialButtonRow/AddTrialButton
@onready var clear_trials_button: Button = $VBoxContainer/TrialButtonRow/ClearTrialsButton

@onready var trial_table: Tree = $VBoxContainer/BottomRow/TrialTable
@onready var graph_panel: Control = $VBoxContainer/BottomRow/GraphPanel
@onready var space_view: Control = $VBoxContainer/MainRow/SpaceView

@onready var mission_label: Label = $VBoxContainer/TitleRow/MissionLabel

var baseline_force: float = 0.0
var current_force: float = 0.0
var trial_history: TrialHistory = TrialHistory.new()
var current_trial_number: int = 1

func _ready() -> void:
    setup_options()
    setup_signals()
    set_baseline()
    update_experiment()
    update_trial_table()
    update_graph()

func setup_options() -> void:
    variable_option.clear()
    variable_option.add_item("Mass 1")
    variable_option.add_item("Mass 2")
    variable_option.add_item("Distance")

    relation_option.clear()
    relation_option.add_item("Increase")
    relation_option.add_item("Decrease")
    relation_option.add_item("Stay the same")

func setup_signals() -> void:
    mass1_slider.value_changed.connect(_on_slider_changed)
    mass2_slider.value_changed.connect(_on_slider_changed)
    distance_slider.value_changed.connect(_on_slider_changed)

    run_experiment_button.pressed.connect(_on_run_experiment_pressed)
    set_baseline_button.pressed.connect(_on_set_baseline_pressed)
    submit_prediction_button.pressed.connect(_on_submit_prediction_pressed)
    add_trial_button.pressed.connect(_on_add_trial_pressed)
    clear_trials_button.pressed.connect(_on_clear_trials_pressed)

func _on_slider_changed(_value: float) -> void:
    update_experiment()

func _on_set_baseline_pressed() -> void:
    set_baseline()
    prediction_feedback_label.text = "Baseline saved. Change one variable and predict the effect."

func _on_run_experiment_pressed() -> void:
    var distance_m = UnitConverter.km_to_m(distance_slider.value)
    current_force = PhysicsCalculator.gravitational_force(mass1_slider.value, mass2_slider.value, distance_m)
    force_value.text = "Gravitational Force: %.4e N" % current_force

    if current_force > baseline_force:
        prediction_feedback_label.text = "The force increased compared with the baseline."
    elif current_force < baseline_force:
        prediction_feedback_label.text = "The force decreased compared with the baseline."
    else:
        prediction_feedback_label.text = "The force stayed the same."

func _on_submit_prediction_pressed() -> void:
    var chosen_variable = variable_option.get_item_text(variable_option.selected)
    var relation = relation_option.get_item_text(relation_option.selected)
    var predicted_text = prediction_value_edit.text.strip_edges()
    if predicted_text == "":
        prediction_feedback_label.text = "Enter a predicted force value before checking your prediction."
        return

    var predicted_force = float(predicted_text)
    var new_force = PhysicsCalculator.gravitational_force(mass1_slider.value, mass2_slider.value, UnitConverter.km_to_m(distance_slider.value))

    var relation_correct = false
    if relation == "Increase":
        relation_correct = new_force > baseline_force
    elif relation == "Decrease":
        relation_correct = new_force < baseline_force
    else:
        relation_correct = abs(new_force - baseline_force) < 1e-9

    if relation_correct and is_force_close(predicted_force, new_force):
        prediction_feedback_label.text = "Good prediction! You correctly identified the effect of changing %s." % chosen_variable.to_lower()
    elif relation_correct:
        prediction_feedback_label.text = "You predicted the direction correctly, but the force estimate is still a bit far from the actual value. Try again using F = GMm / r²."
    else:
        if chosen_variable == "Distance":
            prediction_feedback_label.text = "Think about the denominator in the formula. Increasing distance makes r² larger, so the force decreases."
        else:
            prediction_feedback_label.text = "Think about the numerator in the formula. Increasing mass increases the gravitational force when distance stays the same."

func _on_add_trial_pressed() -> void:
    var distance_m = UnitConverter.km_to_m(distance_slider.value)
    var force = PhysicsCalculator.gravitational_force(mass1_slider.value, mass2_slider.value, distance_m)
    var predicted_force = 0.0
    var prediction_correct = false

    var text = prediction_value_edit.text.strip_edges()
    if text != "":
        predicted_force = float(text)
        prediction_correct = is_force_close(predicted_force, force)

    var record = TrialRecord.new(current_trial_number, mass1_slider.value, mass2_slider.value, distance_slider.value, force, predicted_force, prediction_correct)
    trial_history.add_trial(record)
    current_trial_number += 1

    update_trial_table()
    update_graph()
    prediction_feedback_label.text = "Trial recorded. Compare the pattern in the table and graph."

func _on_clear_trials_pressed() -> void:
    trial_history.clear_trials()
    current_trial_number = 1
    update_trial_table()
    update_graph()
    prediction_feedback_label.text = "All trials cleared. Start a new set of experiments."

func set_baseline() -> void:
    baseline_force = PhysicsCalculator.gravitational_force(mass1_slider.value, mass2_slider.value, UnitConverter.km_to_m(distance_slider.value))

func update_experiment() -> void:
    mass1_value.text = str(int(mass1_slider.value)) + " kg"
    mass2_value.text = str(int(mass2_slider.value)) + " kg"
    distance_value.text = str(int(distance_slider.value)) + " km"

    var distance_m = UnitConverter.km_to_m(distance_slider.value)
    current_force = PhysicsCalculator.gravitational_force(mass1_slider.value, mass2_slider.value, distance_m)
    force_value.text = "Gravitational Force: %.4e N" % current_force

    mission_label.text = "Mission 1: Gravity Explorer"
    if space_view:
        space_view.update_visuals(mass1_slider.value, mass2_slider.value, distance_slider.value)

func update_trial_table() -> void:
    trial_table.clear()
    trial_table.columns = 5
    trial_table.column_titles_visible = true

    var root = trial_table.create_item()
    trial_table.set_column_title(0, "Trial")
    trial_table.set_column_title(1, "Mass 1")
    trial_table.set_column_title(2, "Mass 2")
    trial_table.set_column_title(3, "Distance")
    trial_table.set_column_title(4, "Force")

    for trial in trial_history.trials:
        var item = trial_table.create_item(root)
        item.set_text(0, str(trial.trial_number))
        item.set_text(1, str(int(trial.mass_1_kg)) + " kg")
        item.set_text(2, str(int(trial.mass_2_kg)) + " kg")
        item.set_text(3, str(int(trial.distance_km)) + " km")
        item.set_text(4, "%.4e N" % trial.force_n)

func update_graph() -> void:
    var points: Array = []
    for trial in trial_history.trials:
        points.append(Vector2(trial.distance_km, trial.force_n))
    graph_panel.set_points(points)

func is_force_close(predicted: float, actual: float) -> bool:
    var tolerance = max(actual * 0.15, 1.0)
    return abs(predicted - actual) <= tolerance
