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


extends Node


## To avoid processing agents each and every frame, they can be processed only
## some of the frame by "buckets".
var frame_bucket_count: int = 1

var _current_bucket: int = -1


func can_agent_process(frame_bucket: int) -> bool:
	if frame_bucket < 0:
		return true
	if Engine.is_in_physics_frame():
		return frame_bucket == Engine.get_physics_frames() % frame_bucket_count
	else:
		return frame_bucket == Engine.get_process_frames() % frame_bucket_count


func get_next_bucket() -> int:
	_current_bucket = (1 + _current_bucket) % frame_bucket_count
	return _current_bucket
