extends KinematicBody2D

var velocity = Vector2()
var moveSpeed = 400

func _physics_process(delta):
	
	_get_inputs()
	
	move_and_slide(velocity)

func _get_inputs():
	velocity.x = 0
	
	var moveDirection = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	
	velocity.x = lerp(velocity.x, moveDirection*moveSpeed,0.2)
	
	if moveDirection !=0:
		$Sprite.scale.x = moveDirection
