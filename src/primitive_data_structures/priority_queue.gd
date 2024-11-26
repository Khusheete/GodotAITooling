# Copyright (c) 2024 Souchet Ferdinand (@Khusheete)
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


class_name AITPriorityQueue
extends RefCounted

const MIN_OBJECT_ID: int = -(1 << 31)

var _next_object_id = MIN_OBJECT_ID
var _heap := PackedInt32Array()
var _ids_to_objects: Dictionary = {}
var _objects_to_ids: Dictionary = {}
var _size: int = 0
var _min_queue: bool = false

func _init(min_queue: bool = false) -> void:
	_min_queue = min_queue


## Insert a new object inside the priority queue, and returns it's object identifier
func insert(object: Variant, priority: int) -> void:
	if _min_queue: # Invert the priority for a min queue
		priority = -priority
	
	# Insert object at the end of the heap
	var obj_id: int = _next_object_id
	_next_object_id += 1
	
	var obj_heap_index: int = _size
	_size += 1
	
	_heap.push_back(obj_id)
	_heap.push_back(priority)
	
	# Push object metadata to the heap
	_ids_to_objects[obj_id] = object
	_objects_to_ids[object] = obj_id
	
	_heap_pull_up(obj_heap_index)


## Returns the object identifier with the highest priority
func peek() -> Variant:
	return _ids_to_objects[_heap_get_object_identifier(0)]


## Removes the object with the highest priority and returns it's id
func pop() -> Variant:
	var head_id := _heap_get_object_identifier(0)
	var object: Variant = _ids_to_objects[head_id]
	
	if _size == 1:
		clear()
		return object
	
	# Swap with the remove last object
	var last_index := _size - 1
	_heap_swap_objects(0, last_index)
	_heap.remove_at(_heap.size() - 1)
	_heap.remove_at(_heap.size() - 1)
	_ids_to_objects.erase(head_id)
	_objects_to_ids.erase(object)
	_size -= 1
	
	# Push root down until the heap property is verified
	_heap_pull_down(0)
	
	return object


func erase(object: Variant) -> void:
	if not contains(object):
		push_error("There is no object %s in priority queue" % object)
		return
	
	var object_id: int = _find_object_identifier(object)
	
	if _size == 1:
		clear()
		return
	
	var swapped_index := _get_heap_index(object_id)
	var last_index := _size - 1
	_heap_swap_objects(swapped_index, last_index)
	_heap.remove_at(_heap.size() - 1)
	_heap.remove_at(_heap.size() - 1)
	_ids_to_objects.erase(object_id)
	_objects_to_ids.erase(object)
	_size -= 1
	
	if swapped_index == last_index:
		return
	
	var swapped_object_priority := _heap_get_object_priority(swapped_index)
	
	if not _heap_is_root(swapped_index) \
			and _heap_get_object_priority(_heap_get_parent_index(swapped_index)) < swapped_object_priority:
		_heap_pull_up(swapped_index)
	else:
		_heap_pull_down(swapped_index)


func set_priority(object: Variant, new_priority: int) -> void:
	if not contains(object):
		push_error("There is no object %s in priority queue" % object)
		return
	
	if _min_queue:
		new_priority = -new_priority
	
	var object_id: int = _find_object_identifier(object)
	var heap_index := _get_heap_index(object_id)
	var prev_priority := _heap_get_object_priority(heap_index)
	_heap_set_object_priority(heap_index, new_priority)
	
	if new_priority > prev_priority:
		_heap_pull_up(heap_index)
	elif new_priority < prev_priority:
		_heap_pull_down(heap_index)


func clear() -> void:
	_heap.clear()
	_ids_to_objects.clear()
	_objects_to_ids.clear()
	_size = 0
	_next_object_id = MIN_OBJECT_ID


func size() -> int:
	return _size


func is_empty() -> bool:
	return _size == 0


func is_min_queue() -> bool:
	return _min_queue


func contains(object: Variant) -> bool:
	return object in _objects_to_ids


func _find_object_identifier(object: Variant) -> int:
	return _objects_to_ids[object]


func _has_object(object_identifier: int) -> bool:
	return object_identifier in _ids_to_objects


func _get_heap_index(object_identifier: int) -> int:
	for i: int in _size:
		if _heap_get_object_identifier(i) == object_identifier:
			return i
	return -1


## Does not update meta data
func _heap_swap_objects(heap_index_a: int, heap_index_b: int) -> void:
	# Swap index metadata
	var obj_a_id := _heap_get_object_identifier(heap_index_a)
	var obj_b_id := _heap_get_object_identifier(heap_index_b)
	
	# Swap heap position
	var tmp_obj_id: int = _heap_get_object_identifier(heap_index_a)
	var tmp_obj_priority: int = _heap_get_object_priority(heap_index_a)
	_heap_set_object_identifier(heap_index_a, _heap_get_object_identifier(heap_index_b))
	_heap_set_object_priority(heap_index_a, _heap_get_object_priority(heap_index_b))
	_heap_set_object_identifier(heap_index_b, tmp_obj_id)
	_heap_set_object_priority(heap_index_b, tmp_obj_priority)


func _heap_get_object_identifier(heap_index: int) -> int:
	return _heap[2 * heap_index]


func _heap_get_object_priority(heap_index: int) -> int:
	return _heap[2 * heap_index + 1]


func _heap_set_object_identifier(heap_index: int, value: int) -> void:
	_heap[2 * heap_index] = value


func _heap_set_object_priority(heap_index: int, value: int) -> void:
	_heap[2 * heap_index + 1] = value


func _heap_get_parent_index(heap_index: int) -> int:
	return (heap_index - 1) >> 1


func _heap_get_first_child_index(heap_index: int) -> int:
	return 2 * heap_index + 1


func _heap_get_second_child_index(heap_index: int) -> int:
	return 2 * heap_index + 2


func _heap_is_root(heap_index: int) -> bool:
	return heap_index == 0


func _heap_has_first_child(heap_index: int) -> bool:
	return _heap_get_first_child_index(heap_index) < _size


func _heap_has_both_childs(heap_index: int) -> bool:
	return _heap_get_second_child_index(heap_index) < _size


## Pulls down the object at `heap_index` until the heap property is verified
func _heap_pull_down(heap_index: int) -> void:
	var object_priority := _heap_get_object_priority(heap_index)
	
	while _heap_has_first_child(heap_index):
		var first_child_index := _heap_get_first_child_index(heap_index)
		var first_child_priority := _heap_get_object_priority(first_child_index)
		
		var swapper_index: int = heap_index
		var swapper_priority: int = object_priority
		
		if first_child_priority > swapper_priority:
			swapper_index = first_child_index
			swapper_priority = first_child_priority
		
		if _heap_has_both_childs(heap_index):
			var second_child_index := _heap_get_second_child_index(heap_index)
			var second_child_priority := _heap_get_object_priority(second_child_index)
			if second_child_priority > swapper_priority:
				swapper_index = second_child_index
				swapper_priority = second_child_priority
		
		if heap_index == swapper_index:
			break
		
		_heap_swap_objects(heap_index, swapper_index)
		heap_index = swapper_index


## Pulls up the object at `heap_index` until the heap property is verified
func _heap_pull_up(heap_index: int) -> void:
	var object_priority := _heap_get_object_priority(heap_index)
	
	while not _heap_is_root(heap_index):
		var parent_index := _heap_get_parent_index(heap_index)
		var parent_priority := _heap_get_object_priority(parent_index)
		
		if object_priority > parent_priority:
			# Swap with parent
			var parent_id := _heap_get_object_identifier(parent_index)
			# Swap objects
			_heap_swap_objects(parent_index, heap_index)
			heap_index = parent_index
		else:
			break


func _debug_check_heap_integrity() -> bool:
	print_rich("[color=gray] --- Priority debug integrity check start ---[/color]")
	var errored: bool = false
	
	if 2 * _size != _heap.size():
		printerr(
			"Priority queue size and heap size do not match: 2 * %d != %d"
			% [_size, _heap.size()]
		)
		errored = true
	
	if _size != _ids_to_objects.size():
		printerr(
			"Priority queue size and heap metadata size do not match: %d != %d"
			% [_size, _ids_to_objects.size()]
		)
		errored = true
	
	if not errored:
		for object: int in range(1, _size):
			var parent_object   := _heap_get_parent_index(object)
			var parent_priority := _heap_get_object_priority(parent_object)
			var priority        := _heap_get_object_priority(object)
			if parent_priority < priority:
				printerr(
					"Object at heap index %d has a lower priority than it's child at %d (%d < %d)"
					% [parent_object, object, parent_priority, priority]
				)
				errored = true
	
	if errored:
		printerr("Priority queue debug check ended in error")
	else:
		print_rich("[color=green]-> Priority queue debug check ended without errors[/color]")
	print_rich("[color=gray] --- Priority debug integrity check end ---[/color]")
	
	return not errored
