class_name CSV

## CSV
##
## This class can be used to read and write CSV files (RFC4180).
## Data is stored as strings in PackedStringArrays.

signal updated

## Path to the .csv file.
var path:String
var _rows:Array[PackedStringArray]

## Construct with optional file path.
func _init(p_path:String="")->void:
	path=p_path

## Get number of columns.
## Return 0 if there's no data.
func columns()->int:
	return _rows[0].size() if _rows else 0

## Output content to the console.
func print()->void:
	var i:int=0
	print(path," content:")
	for r in _rows:
		print(i,":",",".join(r))
		i+=1

## Get data as [Array][[PackedStringArray]].
func rows()->Array[PackedStringArray]:
	return _rows

## Save to disk. Leave path unspecified to use current path.
func save(save_path:String=path)->void:
	var file:FileAccess=FileAccess.open(save_path,FileAccess.WRITE)
	print_debug("Saving CSV file: ",file.get_path_absolute())
	for row in _rows:
		file.store_csv_line(row)
	file.close()

## Append a row. First row written becomes the header.
func write_row(row:PackedStringArray)->void:
	if not _rows.is_empty():
		row.resize(columns())
	_rows.append(row)

## Write a row using a dictionary where keys match header fields.[br]
## If this is the first row, it will create the header from keys.
## Unknown fields are ignored, unspecified fields are assigned an empty string.
func write_fields(fields:Dictionary)->void:
	if _rows.is_empty():
		write_row(fields.keys())
	var header:=_rows[0]
	var row:PackedStringArray
	for k in header:
		row.append(str(fields.get(k,"")))
	if row:
		write_row(row)

## Static method to load a CSV file. Return a new CSV object if successful, null on failure.
static func load_csv(load_path:String)->CSV:
	var csv:CSV=CSV.new(load_path)
	var file:FileAccess=FileAccess.open(load_path,FileAccess.READ)
	if not file:
		printerr((CSV as GDScript).resource_path.get_file(),"@load: Can't open \"",load_path,"\".")
		return null
	print_debug("Loading CSV file: ",file.get_path_absolute())
	if file.get_length()==0:
		push_warning(file.get_path()," has zero size.")
		return csv
	var i:int=0
	while not file.eof_reached():
		var line:=file.get_csv_line()
		if file.eof_reached():
			break
		if i>0 and line.size()!=csv.columns():
			push_warning(file.get_path(),": line ",i+1," has wrong number of fields.")
		csv.write_row(line)
		i+=1
	file.close()
	return csv
