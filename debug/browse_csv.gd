extends Control

@onready var file_list_control:OptionButton=%OptionButton as OptionButton
@onready var csv_view:CSVView=%CSVView as CSVView

var dir:String="user://"

func _ready()->void:
	_reset_file_list()

func _reset_file_list()->void:
	file_list_control.clear()
	var files:=DirAccess.get_files_at(dir)
	for f in files:
		if f.get_extension()=="csv":
			file_list_control.add_item(f)
	file_list_control.disabled=file_list_control.item_count==0
	_OptionButton_item_selected(0)

func _OptionButton_item_selected(index:int)->void:
	var fname:String=file_list_control.get_item_text(index)
	csv_view.path=dir+fname

func _Directory_text_submitted(new_text:String)->void:
	dir=new_text
	_reset_file_list()
