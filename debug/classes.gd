extends Tree

## Custom class tree.
##
## This Control displays a hierarchy of custom classes defined in the project.

# Cached values from ProjectSettings.get_global_class_list().
var _custom_classes:Array[StringName]
var _custom_scripts:Dictionary

func _ready()->void:
	var root:TreeItem=create_item()
	root.set_text(0,"Object")
	set_column_title(0,"Class name")
	set_column_title(1,"Script")
	var d=_project_classes()
	_build(d,root)

func _build(d:Dictionary,tree_item:TreeItem)->void:
	for k:StringName in d:
		var ti:TreeItem=create_item(tree_item)
		ti.set_text(0,k)
		if k in _custom_classes:
			ti.set_custom_color(0,Color.WHITE)
			ti.set_text(1,_custom_scripts[k])
		_build(d[k],ti)

func _subtree(node,relationships)->Dictionary:
	var result={}
	for x in relationships:
		if x[1]==node:
			result[x[0]]=_subtree(x[0],relationships)
	return result

func _project_classes():
	var classes:Array=ProjectSettings.get_global_class_list()
	var flat:Array=[]
	for c:Dictionary in classes:
		_custom_classes.append(c["class"])
		_custom_scripts[c["class"]]=c["path"]
		flat.append([c["class"],c["base"]])
	flat.append([&"Node",&"Object"])
	flat.append([&"Resource",&"Object"])
	flat.append([&"RefCounted",&"Object"])
	flat.append([&"Node2D",&"Node"])
	flat.append([&"CollisionObject2D",&"Node2D"])
	flat.append([&"Area2D",&"CollisionObject2D"])
	return _subtree(&"Object",flat)
