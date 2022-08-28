extends KinematicBody2D#extendendo kinematic body

var velocity = Vector2()#Variavel que vai colocar a velociadade em plano cartesianno
var moveSpeed = 400#Velocidade de movimento
var gravity = 3000#Gravidade

func _physics_process(delta):#função que ocorre o tempo todo
	velocity.y = gravity*delta#Calculo da velocidade em y(gravidade)
	_get_input()#chamada da função que pega os inputs
	move_and_slide(velocity)#função necessária para o movimento 


func _get_input():#função que pega os imputs do teclado
	velocity.x = 0#setando velocidade 0 para a escolha de animações
	#pegando a direção de movimento como um inteiro e segundo o plano cartesiano, positivo direita, negativo esquerda
	var moveDirection = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	velocity.x = lerp(velocity.x, moveSpeed*moveDirection/2, 0.2)#
	#Se a velocidade for diferente de zero ele vira o sprite, positivo vira pra direta, negativo pra esquerda
	if (moveDirection !=0):
		$Sprite.scale.x = moveDirection
