# scripts/UnitConverter.gd
extends RefCounted
class_name UnitConverter

static func km_to_m(km: float) -> float:
    return km * 1000.0

static func m_to_km(m: float) -> float:
    return m / 1000.0
