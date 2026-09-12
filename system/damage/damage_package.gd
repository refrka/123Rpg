class_name DamagePackage extends RefCounted




var attack_entry: AttackEntry

var source_entity: EntityNode

var damage_entries: Array[DamageEntry]



static func from_attack_entry(_attack_entry: AttackEntry) -> DamagePackage:

	var damage_package = DamagePackage.new()

	damage_package.attack_entry = _attack_entry

	var damage_entry = DamageEntry.new()

	damage_entry.amount = randf_range(_attack_entry.damage_range.x, _attack_entry.damage_range.y)

	damage_package.damage_entries.append(damage_entry)

	return damage_package