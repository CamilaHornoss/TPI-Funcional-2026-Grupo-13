;; ========================================================
;; REQUERIMIENTO 4: ANÁLISIS DE CICLOS SEMAFÓRICOS
;; ========================================================


;; ========================================================
;; FUNCIÓN: duracion-ciclo
;; NATURALEZA: Pura
;; ESTRATEGIA DE CONTROL: Función no recursiva con COND
;; IMPACTO EN MEMORIA: No destructiva
;; PROPÓSITO:
;; Calcular la duración total de un ciclo completo:
;; rojo → verde → amarillo.
;; El ciclo finaliza al terminar el estado amarillo.
;; ========================================================

(defun duracion-ciclo (&optional
                       (tiempo-rojo 90)
                       (tiempo-verde 120)
                       (tiempo-amarillo 6))
  (cond
    ((or (not (realp tiempo-rojo))
         (not (realp tiempo-verde))
         (not (realp tiempo-amarillo)))
     'error-tiempos-no-numericos)

    ((or (<= tiempo-rojo 0)
         (<= tiempo-verde 0)
         (<= tiempo-amarillo 0))
     'error-tiempos-no-positivos)

    (t
     (+ tiempo-rojo
        tiempo-verde
        tiempo-amarillo))))


;; ========================================================
;; FUNCIÓN: recomendacion-ciclo
;; NATURALEZA: Pura
;; ESTRATEGIA DE CONTROL: Función no recursiva con COND
;; IMPACTO EN MEMORIA: No destructiva
;; PROPÓSITO:
;; Evaluar la duración de un ciclo según el rango recomendado
;; de 35 a 150 segundos.
;; ========================================================

(defun recomendacion-ciclo (duracion)
  (cond
    ((not (realp duracion))
     'error-duracion-no-numerica)

    ((<= duracion 0)
     'error-duracion-no-positiva)

    ((< duracion 35)
     'aumentar-duracion-del-ciclo)

    ((> duracion 150)
     'reducir-duracion-del-ciclo)

    (t
     'duracion-optima)))


;; ========================================================
;; EJEMPLOS DE USO DEL REQUERIMIENTO 4
;; ========================================================

;; Caso normal con las reglas actuales:
;; (duracion-ciclo)
;; Resultado esperado: 216

;; Evaluación del ciclo actual:
;; (recomendacion-ciclo (duracion-ciclo))
;; Resultado esperado: REDUCIR-DURACION-DEL-CICLO

;; Camino alternativo: ciclo dentro del rango recomendado:
;; (duracion-ciclo 50 60 5)
;; Resultado esperado: 115
;;
;; (recomendacion-ciclo (duracion-ciclo 50 60 5))
;; Resultado esperado: DURACION-OPTIMA

;; Camino alternativo: ciclo demasiado corto:
;; (recomendacion-ciclo 30)
;; Resultado esperado: AUMENTAR-DURACION-DEL-CICLO

;; Valores límite:
;; (recomendacion-ciclo 35)
;; Resultado esperado: DURACION-OPTIMA
;;
;; (recomendacion-ciclo 150)
;; Resultado esperado: DURACION-OPTIMA

;; Ejemplo que genera error controlado: duración no numérica:
;; (recomendacion-ciclo 'largo)
;; Resultado esperado: ERROR-DURACION-NO-NUMERICA

;; Ejemplo que genera error controlado: duración negativa:
;; (recomendacion-ciclo -20)
;; Resultado esperado: ERROR-DURACION-NO-POSITIVA

;; Ejemplo que genera error controlado: tiempo no numérico:
;; (duracion-ciclo 90 'ciento-veinte 6)
;; Resultado esperado: ERROR-TIEMPOS-NO-NUMERICOS

;; Ejemplo que genera error controlado: tiempo igual a cero:
;; (duracion-ciclo 90 0 6)
;; Resultado esperado: ERROR-TIEMPOS-NO-POSITIVOS
