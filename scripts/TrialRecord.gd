# scripts/TrialRecord.gd
extends RefCounted
class_name TrialRecord

var trial_number: int
var mass_1_kg: float
var mass_2_kg: float
var distance_km: float
var force_n: float
var predicted_force_n: float
var prediction_correct: bool

func _init(p_trial_number: int, p_mass_1_kg: float, p_mass_2_kg: float, p_distance_km: float, p_force_n: float, p_predicted_force_n: float, p_prediction_correct: bool) -> void:
    trial_number = p_trial_number
    mass_1_kg = p_mass_1_kg
    mass_2_kg = p_mass_2_kg
    distance_km = p_distance_km
    force_n = p_force_n
    predicted_force_n = p_predicted_force_n
    prediction_correct = p_prediction_correct
