extends AnimatableBody3D

@export var a = Vector3()
@export var b = Vector3()
@export var time: float = 2.0
@export var pause: float = 0.7

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	move()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func move():
	var move_tween = create_tween()
	move_tween.tween_property(self, "position",b,time).set_delay(pause)
	move_tween.tween_property(self, "position",a,time).set_delay(pause)
	await get_tree().create_timer((time+pause)*2).timeout	
	move()
	
