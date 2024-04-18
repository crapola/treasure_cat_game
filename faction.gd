class_name Faction
## Faction
##
## Units belong to a faction. The faction holds the treasury.

## Emitted when gold was changed.
signal updated
## Current gold amount.
var gold:int=25:
	set(value):
		if value>gold:
			gold_total_collected+=value-gold
		gold=value
		updated.emit()
## Gold collected over lifetime. Used for statistics.
var gold_total_collected:int=0
## Name of the faction.
var name:StringName
