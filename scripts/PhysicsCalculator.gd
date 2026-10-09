# scripts/PhysicsCalculator.gd
extends RefCounted
class_name PhysicsCalculator

const GRAVITATIONAL_CONSTANT := 6.67430e-11

static func gravitational_force(mass_1_kg: float, mass_2_kg: float, distance_m: float) -> float:
    if mass_1_kg <= 0.0:
        push_error("Mass 1 must be greater than zero.")
        return 0.0
    if mass_2_kg <= 0.0:
        push_error("Mass 2 must be greater than zero.")
        return 0.0
    if distance_m <= 0.0:
        push_error("Distance must be greater than zero.")
        return 0.0

    return (GRAVITATIONAL_CONSTANT * mass_1_kg * mass_2_kg) / (distance_m * distance_m)

static func gravitational_field_strength(mass_kg: float, radius_m: float) -> float:
    if mass_kg <= 0.0:
        push_error("Mass must be greater than zero.")
        return 0.0
    if radius_m <= 0.0:
        push_error("Radius must be greater than zero.")
        return 0.0

    return (GRAVITATIONAL_CONSTANT * mass_kg) / (radius_m * radius_m)
