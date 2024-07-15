class_name AITPriorityArray
extends Object


const MIN_OBJECT_ID: int = -(1 << 31)


var _next_object_id = MIN_OBJECT_ID
var _array := PackedInt32Array()
var _size: int = 0


func insert(priority: int) -> int:
	var obj_id: int = _next_object_id
	_next_object_id += 1
	
	if _size == 0:
		_size = 1
		_array.append_array([obj_id, priority])
		return obj_id
	
	var lower_bound: int = 0
	var higher_bound: int = _size
	var current_index: int
	
	while lower_bound != higher_bound:
		@warning_ignore("integer_division")
		current_index = (lower_bound + higher_bound) / 2
		
		var current_priority: int = get_priority(current_index)
		
		if current_priority < priority:
			lower_bound = current_index + 1
			current_index = lower_bound
		elif current_priority > priority:
			higher_bound = current_index
		else: # current_priority == priority
			break
	
	_array.insert(2 * current_index, priority)
	_array.insert(2 * current_index, obj_id)
	_size += 1
	
	return obj_id


func peek() -> int:
	if is_empty():
		push_error("Cannot peek into empty AITPriorityArray")
	return get_identifier(_size - 1)


func pop() -> int:
	if is_empty():
		push_error("Cannot pop empty AITPriorityArray")
	var index: int = _size - 1
	var id: int = get_identifier(index)
	_array.remove_at(2 * index)
	_array.remove_at(2 * index)
	_size -= 1
	return id


func find(identifier: int) -> int:
	for i in size():
		if get_identifier(i) == identifier:
			return i
	return -1


func erase(identifier: int) -> void:
	var index: int = find(identifier)
	if index == -1:
		return
	_array.remove_at(2 * index)
	_array.remove_at(2 * index)
	_size -= 1


func get_identifier(index: int) -> int:
	if index >= _size:
		push_error("AITPriorityArray index out of range")
	return _array[2 * index]


func get_priority(index: int) -> int:
	if index >= _size:
		push_error("AITPriorityArray index out of range")
	return _array[2 * index + 1]


func size() -> int:
	return _size


func is_empty() -> bool:
	return _size == 0
