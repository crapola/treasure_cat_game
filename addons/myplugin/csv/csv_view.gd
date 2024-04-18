@tool
class_name CSVView
extends ItemList

## CSV view
##
## This [ItemList] can display [CSV] data.

## Path to [b].csv[/b] file.
@export var path:String="user://":
	set(value):
		path=value
		csv=CSV.load_csv(path)
	get:
		return path

var csv:CSV:
	set(value):
		csv=value
		update()

func _init()->void:
	same_column_width=true

func _ready()->void:
	update()

func set_data(data:PackedStringArray)->void:
	for s in data:
		var id:=add_item(s,null,false)

func update()->void:
	clear()
	if csv:
		max_columns=csv.columns()
		#print_debug(max_columns," columns.")
		for r in csv.rows():
			for s in r:
				add_item(s,null,false)
	else:
		add_item("No data")

