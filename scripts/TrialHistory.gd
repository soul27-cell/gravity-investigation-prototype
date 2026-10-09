# scripts/TrialHistory.gd
extends RefCounted
class_name TrialHistory

var trials: Array = []

func add_trial(record: TrialRecord) -> void:
    trials.append(record)

func clear_trials() -> void:
    trials.clear()

func get_count() -> int:
    return trials.size()
