extends Node2D



@export var RopeLenght:float=30
#Quanto maior for menor a elasticidade
@export var Restric:float=1 #Restringir a distancia maxima de afastamento entre os dois pontos
@export var gravity:Vector2=Vector2(0,9.8)
#Quanto menor o valor maior serar a perda de força que um ponto exerce sobre o outro
@export var amortecimento:float =0.9


@onready var line2d=$Line2D



var pos:PackedVector2Array
var posPrev:PackedVector2Array
var PointCount:int

func _ready()->void:
	##Quantos pontos terão a corda dependo do seu tamanho
	PointCount = ceil(RopeLenght/Restric)
	
	#Definir o tamanho dos array para o tamanho d pontos
	pos.resize(PointCount)
	posPrev.resize(PointCount)
	print("START")
	start()



func start()->void:
	for i in range(PointCount):
		pos[i]= position + Vector2(Restric*i,0)
		posPrev[i] = position + Vector2(Restric*i,0)
	position=Vector2.ZERO


func _process(delta)->void:
	updatePoints(delta)
	
	UpdateRestric()
	
	line2d.points=pos




func updatePoints(delta)->void:
	#Basicamente a função responsavel pela fisica da corda
	for i in range (PointCount):
		#ignorar o primeiro e o ultimo pontos
		if (i!=0 && i!=PointCount-1):
			#a velocidade é igual ao vetor dos dois pontos * o amortecimento
			var velocity = (pos[i] -posPrev[i]) * amortecimento
			posPrev[i] = pos[i]
			#add ao Pos atual a velocidade + gravidade
			pos[i] += velocity + (gravity * delta)

func setPoint(p:Vector2,value:int)->void:
	pos[value] = p
	posPrev[value] = p



func UpdateRestric()->void:
	#Basicamente a função que vai juntar os joints e dar o aspector de corda
	
	for i in range(PointCount):
		##Se for o ultimo ponto ele da para o loop
		if i == PointCount-1:
			return
		
		#Calcula a distancia entre o ponto e o proximo
		var distance = pos[i].distance_to(pos[i+1])
		
		#Ver a diferença da restrição e a distancia
		var difference = Restric - distance
		#Calcula o a % da da diferença pela distancia
		var percent = difference / distance
		#Calcula um vetor entre os dois pontos e o proximo
		var vec2 = pos[i+1] - pos[i]
		
		# Se for o Primeiro Ponto //Definir o FirtsPoint com um peso maior para que a corda não vire uma mola
		if i == 0:
			pos[i+1] += vec2 * percent
		else:
			##Definir o lastPoint com um peso maior para que a corda não vire uma mola
			if i+1 == PointCount-1 :
				pos[i] -= vec2 * percent
			
			#A função que junta os pontos
			else:
				pos[i] -= vec2 * (percent/2)
				pos[i+1] += vec2 * (percent/2)

