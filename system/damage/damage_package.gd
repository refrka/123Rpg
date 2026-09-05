class_name DamagePackage extends RefCounted



var source_entity: EntityNode

var damage_entries: Array[DamageEntry]




static func from_attack_entry(attack_entry: AttackEntry) -> DamagePackage:

	var damage_package = DamagePackage.new()

	var damage_entry = DamageEntry.new()

	damage_entry.amount = randf_range(attack_entry.damage_range.x, attack_entry.damage_range.y)

	damage_package.damage_entries.append(damage_entry)

	return damage_package