extends KinematicBody2D

var velocity = Vector2()#colocando velocidade vetorial
var moveSpeed = 480#velocidade de movimento do personagem
var gravity = 1000#força da gravidade
var jumpForce = -720#força do pulo(gavidade-forçapulo=pulo)
var isGrounded#variavel que verifica se ta no chão
const jumpEfect = preload("res://Assets/Prefabs/jumEfect.tscn")#instanciando a cena do efeito do pulo
onready var timer := $Timer as Timer#instanciando um timer
onready var raycasts = $raycasts#acessando o nó raycast(no que checa o chão)

func _physics_process(delta):#função que ocorre o tempo todo
	_get_input()#chamada da função que pega os inputs
	_set_animation()#chamada da função que escolhe as animções
	isGrounded = _check_is_grounded()#chamada da função que verifica o chão
	
	velocity.y += gravity*delta#calculo da gravidade(gravidade X tempo decorrido)
	move_and_slide(velocity)#função necessária para o movimento 


func _get_input():#função que pega os imputs do teclado
	velocity.x = 0#setando velocidade 0 para a escolha de animações
	#pegando a direção de movimento como um inteiro e segundo o plano cartesiano, positivo direita, negativo esquerda
	var moveDirection = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	velocity.x = lerp(velocity.x, moveSpeed*moveDirection/2, 0.2)#
	#Se a velocidade for diferente de zero ele vira o sprite, positivo vira pra direta, negativo pra esquerda
	if (moveDirection !=0):
		$Sprite.scale.x = moveDirection#flipando o sprite de acordo com a direção do player


func _input(event):#função de pulo
	if(event.is_action_pressed("ui_up")and isGrounded):#se foi pressionada e está no chão
		var pulinho = jumpEfect.instance()#chamando a cena instanciada pra dentro da função
		get_parent().add_child(pulinho)#adicionando a cena toda como um filho
		pulinho.position = $Position2D.global_position#setando a posição onde o nó está
		timer.connect("timeout", pulinho, "queue_free")#setando o timer para deletar o nó
		timer.set_wait_time(0.6)#tempo de espera para que o nó seja deletado(usando tempo da animação como parametro)
		velocity.y = jumpForce/2#calculo do pulo

func _check_is_grounded():#função de checagem do pulo
	for raycast in raycasts.get_children():#acessando os nós do raycast
		if raycast.is_colliding():#se estiver tocando o chão retorna verdade, possibilitando o pulo
			return true
	return false#Se não estiver tocando o chão(ar) retorna falso impossibilitando o pulo


func _set_animation(): #função que seta as animações
	var anim = "idleAnim"
	#var jumpEfect = "jumpEfect"
	if !isGrounded:#se estiver no ar(diferente de no chão) seta a animação de pulo
		anim = "jumpAnim"
	elif velocity.x != 0:#se a velocidade for diferente de 0 seta a animação de corrida
		anim = "runAnim"
	elif Input.is_action_pressed("attack"):#setando animação de ataque
		anim = "attkAnim"
	elif Input.is_action_pressed("ui_up"):#setando input pra animação do efeito
		anim = "jumpEfect"
	if $AnimationPlayer.assigned_animation != anim:#?
		$AnimationPlayer.play(anim)#toca a animação

