;; ========================================================
;; REQUERIMIENTO 5: PLANIFICACIÓN TEMPORAL
;; ========================================================

;; IMPORTANTE:
;; Este requerimiento utiliza la función DURACION-CICLO,
;; definida en el archivo del Requerimiento 4.


;; ========================================================
;; FUNCIÓN: ciclos-por-tiempo
;; NATURALEZA: Pura
;; ESTRATEGIA DE CONTROL: Composición funcional
;; IMPACTO EN MEMORIA: No destructiva
;; PROPÓSITO:
;; Calcular cuántos ciclos semafóricos completos entran en
;; una determinada cantidad de minutos.
;; ========================================================
(defun ciclos-por-tiempo (minutos)
  (cond
    ((not (realp minutos))
     'error-minutos-no-numericos)

    ((< minutos 0)
     'error-minutos-negativos)

    (t
     (floor
       (/ (* minutos 60)
          (duracion-ciclo))))))


;; ========================================================
;; EJEMPLOS DE USO DEL REQUERIMIENTO 5
;; ========================================================

;; Caso normal solicitado en el enunciado:
;; (ciclos-por-tiempo 15)
;; Resultado esperado: 4

;; Camino alternativo: una hora:
;; (ciclos-por-tiempo 60)
;; Resultado esperado: 16

;; Camino alternativo: tiempo insuficiente para un ciclo:
;; (ciclos-por-tiempo 3)
;; Resultado esperado: 0

;; Caso límite:
;; (ciclos-por-tiempo 0)
;; Resultado esperado: 0

;; Camino alternativo con minutos decimales:
;; (ciclos-por-tiempo 7.2)
;; Resultado esperado: 2

;; Ejemplo que genera error controlado: minutos no numéricos:
;; (ciclos-por-tiempo 'quince)
;; Resultado esperado: ERROR-MINUTOS-NO-NUMERICOS

;; Ejemplo que genera error controlado: minutos negativos:
;; (ciclos-por-tiempo -15)
;; Resultado esperado: ERROR-MINUTOS-NEGATIVOS
