var time = 0
var max_time = 0

# warning-ignore:shadowed_variable
func _init(max_time):
	self.max_time = max_time
	self.time = 0
	
func tick(delta):
	time = max(time - delta, 0)
	return time

func is_ready():
	if time > 0:
		return false
	time = max_time
	return true
