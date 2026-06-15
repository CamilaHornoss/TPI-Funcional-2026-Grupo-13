;; ========================================================
;; REQUERIMIENTO 4: ANÁLISIS DE CICLOS SEMAFÓRICOS
;; ITERACIÓN 2: INTERMITENCIA DE SEGURIDAD
;; ========================================================


;; ========================================================
;; FUNCIÓN: duracion-ciclo
;; NATURALEZA: Pura
;; ESTRATEGIA DE CONTROL: Función no recursiva con COND
;; IMPACTO EN MEMORIA: No destructiva
;; PROPÓSITO:
;; Calcular la duración total de un ciclo completo,
;; incluyendo tres intervalos de amarillo intermitente
;; de 3 segundos cada uno.
;;
;; El ciclo sigue el orden:
;; rojo → amarillo-intermitente → verde →
;; amarillo-intermitente → amarillo →
;; amarillo-intermitente.
;;
;; El ciclo finaliza al terminar la tercera intermitencia.
;; ========================================================

(defun duracion-ciclo (&optional
                       (tiempo-rojo 90)
                       (tiempo-verde 120)
                       (tiempo-amarillo 6)
                       (tiempo-intermitencia 3))
  (cond
    ((or (not (realp tiempo-rojo))
         (not (realp tiempo-verde))
         (not (realp tiempo-amarillo))
         (not (realp tiempo-intermitencia)))
     'error-tiempos-no-numericos)

    ((or (<= tiempo-rojo 0)
         (<= tiempo-verde 0)
         (<= tiempo-amarillo 0)
         (<= tiempo-intermitencia 0))
     'error-tiempos-no-positivos)

    (t
     (+ tiempo-rojo
        tiempo-verde
        tiempo-amarillo
        (* 3 tiempo-intermitencia)))))


;; ========================================================
;; FUNCIÓN: recomendacion-ciclo
;; NATURALEZA: Pura
;; ESTRATEGIA DE CONTROL: Función no recursiva con COND
;; IMPACTO EN MEMORIA: No destructiva
;; PROPÓSITO:
;; Evaluar la duración total del ciclo según el rango
;; recomendado de 35 a 150 segundos.
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
;;
;; 90 segundos de rojo
;; 120 segundos de verde
;; 6 segundos de amarillo
;; 3 intermitencias de 3 segundos
;;
;; (duracion-ciclo)
;; Resultado esperado: 225


;; Evaluación del ciclo actual:
;;
;; (recomendacion-ciclo (duracion-ciclo))
;; Resultado esperado: REDUCIR-DURACION-DEL-CICLO


;; Camino alternativo dentro del rango recomendado:
;;
;; 50 + 60 + 5 + (3 × 3) = 124
;;
;; (duracion-ciclo 50 60 5 3)
;; Resultado esperado: 124
;;
;; (recomendacion-ciclo
;;  (duracion-ciclo 50 60 5 3))
;; Resultado esperado: DURACION-OPTIMA


;; Camino alternativo: ciclo demasiado corto:
;;
;; (recomendacion-ciclo 30)
;; Resultado esperado: AUMENTAR-DURACION-DEL-CICLO


;; Valores límite:
;;
;; (recomendacion-ciclo 35)
;; Resultado esperado: DURACION-OPTIMA
;;
;; (recomendacion-ciclo 150)
;; Resultado esperado: DURACION-OPTIMA


;; Ejemplo que genera error controlado:
;; duración no numérica.
;;
;; (recomendacion-ciclo 'largo)
;; Resultado esperado: ERROR-DURACION-NO-NUMERICA


;; Ejemplo que genera error controlado:
;; duración negativa.
;;
;; (recomendacion-ciclo -20)
;; Resultado esperado: ERROR-DURACION-NO-POSITIVA


;; Ejemplo que genera error controlado:
;; tiempo verde no numérico.
;;
;; (duracion-ciclo 90 'ciento-veinte 6 3)
;; Resultado esperado: ERROR-TIEMPOS-NO-NUMERICOS


;; Ejemplo que genera error controlado:
;; tiempo de intermitencia igual a cero.
;;
;; (duracion-ciclo 90 120 6 0)
;; Resultado esperado: ERROR-TIEMPOS-NO-POSITIVOS
