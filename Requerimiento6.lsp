Requerimiento 6: Informe de Distribución Temporal
Por cuestiones de planificación logística, se necesita un informe que indique 
el porcentaje de cada color que se tendrá en 1 hora. Dadas ciertas reglas de 
negocios o según las actuales. 
Desarrolle una función que calcule la distribución porcentual de 
cada color en períodos de 1 hora:
Especificación:
Salida: Porcentajes de tiempo para rojo, amarillo y verde
Propósito: Optimización de flujo vehicular y análisis de congestión

90seg Rojo - Porcentaje en una hora: 41,66%
6seg Amarillo - Porcentaje en una hora: 2,77%
120seg Verde - Porcentaje en una hora: 55,55%
Total = 216seg(3:36min)
1 hora = 60 min = 3600 seg

Ingresamos como parametros el tiempo en segundos de cada color de semaforo
(defun sumaTiempo (t_rojo t_amarillo t_verde)
	(+ t_rojo t_amarillo t_verde)
)
Sumamos el tiempo en segundos de cada color de semaforo para determinar cuantos
segundos dura el ciclo entero. 

(defun distribucionTemp (t_rojo t_amarillo t_verde)
	(list 
		(list 'Rojo (float(* (/ t_rojo (sumaTiempo t_rojo t_amarillo t_verde)) 100)))
		(list 'Amarillo (float(* (/ t_amarillo (sumaTiempo t_rojo t_amarillo t_verde)) 100)))
		(list 'Verde (float(* (/ t_verde (sumaTiempo t_rojo t_amarillo t_verde)) 100)))
	)
)
Creamos una funcion que devuelva el porcentaje que ocupa cada color de semaforo
durante una hora. El float es necesario en este caso para que nos devuelva un numero
decimal y no uno fraccionario.