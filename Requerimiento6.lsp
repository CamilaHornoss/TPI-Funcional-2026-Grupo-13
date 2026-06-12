;; ========================================================
;; REQUERIMIENTO 6:  Informe de Distribución Temporal
;; ========================================================

;; ========================================================
;;	DATOS NUMERICOS
;;90seg Rojo - Porcentaje en una hora: 41,66%
;;6seg Amarillo - Porcentaje en una hora: 2,77%
;;120seg Verde - Porcentaje en una hora: 55,55%
;;Total = 216seg(3:36min)
;;1 hora = 60 min = 3600 seg
;; ========================================================



;; ========================================================
;; FUNCIÓN: sumaTiempo
;; NATURALEZA: Pura 
;; ESTRATEGIA: Suma los parametros temporales
;; IMPACTO: No destructiva
;; PROPOSITO: Su funcion es sumar el tiempo en segundos de cada color de semaforo
			;;para asi saber cuanto dura un ciclo entero. 
;; ========================================================

(defun sumaTiempo (t_rojo t_amarillo t_verde)
	(+ t_rojo t_amarillo t_verde)
)

;; ========================================================
;; FUNCIÓN: porcentajeColores
;; NATURALEZA: Pura 
;; ESTRATEGIA: Realiza operaciones que se mostraran en las sublistas de la lista
;; IMPACTO: No destructiva
;; PROPOSITO: Su funcion es obtener el porcentaje de duracion de cada uno de los 
			;;colores del semaforo. 
			;;Para ello se requiere la funcion sumaTiempo que posee la duracion total del ciclo
			;;Se divide el tiempo total con el de cada color y se multiplica para obtener el porcentaje
			;;El float se encarga de devolvernos numeros decimales y no fraccionarios
			;;Por ultimo se devuelven una lista para cada color de semaforo que incluye el color y el porcentaje que representa
;; ========================================================

(defun porcentajeColores (t_rojo t_amarillo t_verde)
	(list 
		(list 'Rojo (float(* (/ t_rojo (sumaTiempo t_rojo t_amarillo t_verde)) 100)))
		(list 'Amarillo (float(* (/ t_amarillo (sumaTiempo t_rojo t_amarillo t_verde)) 100)))
		(list 'Verde (float(* (/ t_verde (sumaTiempo t_rojo t_amarillo t_verde)) 100)))
	)
)


;; ========================================================
;; FUNCIÓN: verificaciones
;; NATURALEZA: Pura 
;; ESTRATEGIA: Determina que pasos llevar a cabo mediante el condicional Cond
;; IMPACTO: No destructiva
;; PROPOSITO: En base a los posibles errores que puedan presentarse con el tiempo de los semaforos,
			;;como que el tiempo no sea numerico o que la suma del tiempo no sea exacta, se devolveran
			;;determinados mensajes. Y en caso de que se cumplan las condiciones para llevar a cabo el 
			;;procedimiento, se ejecutara la funcion porcentajeColores. 
;; ========================================================

(defun verificaciones(t_rojo t_amarillo t_verde)
	(cond
		((or (not (numberp t_rojo)) (not (numberp t_amarillo)) (not (numberp t_verde))) 
			'Error-Duracion-No-Numerica)
		((/= (sumaTiempo t_rojo t_amarillo t_verde) 216) 'Ciclos-Desincronizados)
		((and (numberp t_rojo) (numberp t_amarillo) (numberp t_verde)) 
			(porcentajeColores t_rojo t_amarillo t_verde))
	)
)
