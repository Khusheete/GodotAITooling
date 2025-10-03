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


class_name Agent
extends Node


enum TickMode {
	## The tick function is called during godot's process frame.
	TICK_MODE_PROCESS_FRAME,
	## The tick function is called during godot's physics frame.
	## /!\ some agents may be very expensive to run, so it might be better to
	## run their tick function during the process frame.
	TICK_MODE_PHYSICS_FRAME,
	## The tick function is never internally called.
	TICK_MODE_MANUAL,
}

@export var tick_mode: TickMode = TickMode.TICK_MODE_PROCESS_FRAME:
	set(p_value):
		tick_mode = p_value
		match tick_mode:
			TickMode.TICK_MODE_PROCESS_FRAME:
				set_process(true)
				set_physics_process(false)
			TickMode.TICK_MODE_PHYSICS_FRAME:
				set_process(false)
				set_physics_process(true)
			TickMode.TICK_MODE_MANUAL:
				set_process(false)
				set_physics_process(false)

## The frame bucket in which this agent ticks (see [TODO]).
## When equal to -1, the process bucket will be automatically assigned to
## [AIT.get_next_bucket] when ready.
## When equal to -2, it is processed every frame.
@export var process_bucket: int = -1


func _ready() -> void:
	if process_bucket < -1:
		process_bucket = AIT.get_next_bucket()


func _process(_delta: float) -> void:
	if AIT.can_agent_process(process_bucket):
		return
	
	if tick_mode != TickMode.TICK_MODE_PROCESS_FRAME:
		push_warning("Agent process is active when the tick mode is not TICK_MODE_PROCESS_FRAME")
		return
	
	tick()


func _physics_process(_delta: float) -> void:
	if AIT.can_agent_process(process_bucket):
		return
	
	if tick_mode != TickMode.TICK_MODE_PHYSICS_FRAME:
		push_warning("Agent physics_process is active when the tick mode is not TICK_MODE_PHYSICS_FRAME")
		return
	
	tick()


func tick() -> void:
	pass
