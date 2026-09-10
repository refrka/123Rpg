class_name CharacterNode extends EntityNode








func consume(consumable_def: ConsumableDef) -> void:

	var effects_component = get_component(EffectsComponent)

	for effect in consumable_def.effects_on_consume:

		effects_component.add_effect(effect)