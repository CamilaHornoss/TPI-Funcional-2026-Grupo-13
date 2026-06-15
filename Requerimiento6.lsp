;; ========================================================
;; REQUERIMIENTO 6: INFORME DE DISTRIBUCIÓN TEMPORAL
;; ========================================================


;; ========================================================
;; FUNCIÓN: suma-tiempo
;; NATURALEZA: Pura
;; ESTRATEGIA DE CONTROL: Función simple
;; IMPACTO EN MEMORIA: No destructiva
;; PROPÓSITO:
;; Sumar los tiempos en segundos correspondientes a rojo,
;; verde y amarillo para obtener la duración total del ciclo.
;; ========================================================

(defun suma-tiempo (tiempo-rojo tiempo-verde tiempo-amarillo)
  (+ tiempo-rojo tiempo-verde tiempo-amarillo))


;; ========================================================
;; FUNCIÓN: distribucion-una-hora
;; NATURALEZA: Pura
;; ESTRATEGIA DE CONTROL: Función no recursiva con LET*
;; IMPACTO EN MEMORIA: No destructiva
;; PROPÓSITO:
;; Calcular la cantidad total de segundos que corresponde a
;; cada color durante una hora, considerando los ciclos
;; completos y el tiempo restante.
;; ========================================================

(defun distribucion-una-hora
       (tiempo-rojo tiempo-verde tiempo-amarillo)

  (let* ((duracion-total
           (suma-tiempo
            tiempo-rojo
            tiempo-verde
            tiempo-amarillo))

         (cantidad-ciclos
           (floor (/ 3600 duracion-total)))

         (tiempo-restante
           (mod 3600 duracion-total))

         (rojo-extra
           (min tiempo-restante tiempo-rojo))

         (restante-despues-rojo
           (max 0 (- tiempo-restante tiempo-rojo)))

         (verde-extra
           (min restante-despues-rojo tiempo-verde))

         (restante-despues-verde
           (max 0
                (- restante-despues-rojo tiempo-verde)))

         (amarillo-extra
           (min restante-despues-verde tiempo-amarillo))

         (total-rojo
           (+ (* cantidad-ciclos tiempo-rojo)
              rojo-extra))

         (total-verde
           (+ (* cantidad-ciclos tiempo-verde)
              verde-extra))

         (total-amarillo
           (+ (* cantidad-ciclos tiempo-amarillo)
              amarillo-extra)))

    (list total-rojo
          total-verde
          total-amarillo)))


;; ========================================================
;; FUNCIÓN: porcentaje-colores
;; NATURALEZA: Pura
;; ESTRATEGIA DE CONTROL: Composición funcional
;; IMPACTO EN MEMORIA: No destructiva
;; PROPÓSITO:
;; Calcular el porcentaje exacto que representa cada color
;; dentro de un período de una hora.
;; ========================================================

(defun porcentaje-colores
       (tiempo-rojo tiempo-verde tiempo-amarillo)

  (let ((distribucion
          (distribucion-una-hora
           tiempo-rojo
           tiempo-verde
           tiempo-amarillo)))

    (list
     (list 'rojo
           (* (/ (first distribucion) 3600.0) 100))

     (list 'verde
           (* (/ (second distribucion) 3600.0) 100))

     (list 'amarillo
           (* (/ (third distribucion) 3600.0) 100)))))


;; ========================================================
;; FUNCIÓN: verificaciones
;; NATURALEZA: Pura
;; ESTRATEGIA DE CONTROL: Función no recursiva con COND
;; IMPACTO EN MEMORIA: No destructiva
;; PROPÓSITO:
;; Validar los tiempos ingresados y, si son correctos,
;; calcular la distribución porcentual de los colores
;; durante una hora.
;; ========================================================

(defun verificaciones
       (tiempo-rojo tiempo-verde tiempo-amarillo)

  (cond
    ((or (not (realp tiempo-rojo))
         (not (realp tiempo-verde))
         (not (realp tiempo-amarillo)))
     'error-duracion-no-numerica)

    ((or (<= tiempo-rojo 0)
         (<= tiempo-verde 0)
         (<= tiempo-amarillo 0))
     'error-duracion-no-positiva)

    (t
     (porcentaje-colores
      tiempo-rojo
      tiempo-verde
      tiempo-amarillo))))


;; ========================================================
;; EJEMPLOS DE USO DEL REQUERIMIENTO 6
;; ========================================================

;; Caso normal con las reglas actuales:
;; (verificaciones 90 120 6)
;;
;; Resultado aproximado esperado:
;; ((ROJO 42.5)
;;  (VERDE 54.833332)
;;  (AMARILLO 2.6666667))


;; Distribución en segundos durante una hora:
;; (distribucion-una-hora 90 120 6)
;;
;; Resultado esperado:
;; (1530 1974 96)


;; Ejemplo de entrada no numérica:
;; (verificaciones 90 'verde 6)
;;
;; Resultado esperado:
;; ERROR-DURACION-NO-NUMERICA


;; Ejemplo de tiempo no positivo:
;; (verificaciones 90 120 0)
;;
;; Resultado esperado:
;; ERROR-DURACION-NO-POSITIVA
