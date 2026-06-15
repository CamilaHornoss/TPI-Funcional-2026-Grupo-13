;; ========================================================
;; REQUERIMIENTO 6: INFORME DE DISTRIBUCIÓN TEMPORAL
;; ITERACIÓN 2: INTERMITENCIA DE SEGURIDAD
;; ========================================================

;; Con las reglas actuales:
;; Rojo: 90 segundos
;; Verde: 120 segundos
;; Amarillo: 6 segundos
;; Amarillo intermitente: 3 intervalos de 3 segundos
;; Duración total: 225 segundos
;;
;; En una hora se completan exactamente 16 ciclos:
;; 3600 / 225 = 16


;; ========================================================
;; FUNCIÓN: suma-tiempo
;; NATURALEZA: Pura
;; ESTRATEGIA DE CONTROL: Función simple
;; IMPACTO EN MEMORIA: No destructiva
;; PROPÓSITO:
;; Calcular la duración total del ciclo, incluyendo los tres
;; intervalos de amarillo intermitente.
;; ========================================================

(defun suma-tiempo
       (tiempo-rojo
        tiempo-verde
        tiempo-amarillo
        tiempo-intermitencia)

  (+ tiempo-rojo
     tiempo-verde
     tiempo-amarillo
     (* 3 tiempo-intermitencia)))


;; ========================================================
;; FUNCIÓN: distribucion-una-hora
;; NATURALEZA: Pura
;; ESTRATEGIA DE CONTROL: Función no recursiva con LET*
;; IMPACTO EN MEMORIA: No destructiva
;; PROPÓSITO:
;; Calcular los segundos correspondientes a cada estado
;; durante una hora, incluyendo los ciclos completos y el
;; posible tiempo restante.
;; El período comienza en el estado rojo.
;; ========================================================

(defun distribucion-una-hora
       (tiempo-rojo
        tiempo-verde
        tiempo-amarillo
        tiempo-intermitencia)

  (let* ((duracion-total
           (suma-tiempo
            tiempo-rojo
            tiempo-verde
            tiempo-amarillo
            tiempo-intermitencia))

         (cantidad-ciclos
           (floor (/ 3600 duracion-total)))

         (tiempo-restante
           (mod 3600 duracion-total))

         ;; Rojo.
         (extra-rojo
           (min tiempo-restante tiempo-rojo))

         (resto-1
           (max 0
                (- tiempo-restante tiempo-rojo)))

         ;; Primera intermitencia.
         (extra-intermitente-1
           (min resto-1 tiempo-intermitencia))

         (resto-2
           (max 0
                (- resto-1 tiempo-intermitencia)))

         ;; Verde.
         (extra-verde
           (min resto-2 tiempo-verde))

         (resto-3
           (max 0
                (- resto-2 tiempo-verde)))

         ;; Segunda intermitencia.
         (extra-intermitente-2
           (min resto-3 tiempo-intermitencia))

         (resto-4
           (max 0
                (- resto-3 tiempo-intermitencia)))

         ;; Amarillo.
         (extra-amarillo
           (min resto-4 tiempo-amarillo))

         (resto-5
           (max 0
                (- resto-4 tiempo-amarillo)))

         ;; Tercera intermitencia.
         (extra-intermitente-3
           (min resto-5 tiempo-intermitencia))

         (total-rojo
           (+ (* cantidad-ciclos tiempo-rojo)
              extra-rojo))

         (total-verde
           (+ (* cantidad-ciclos tiempo-verde)
              extra-verde))

         (total-amarillo
           (+ (* cantidad-ciclos tiempo-amarillo)
              extra-amarillo))

         (total-intermitente
           (+ (* cantidad-ciclos
                 (* 3 tiempo-intermitencia))
              extra-intermitente-1
              extra-intermitente-2
              extra-intermitente-3)))

    (list total-rojo
          total-verde
          total-amarillo
          total-intermitente)))


;; ========================================================
;; FUNCIÓN: porcentaje-colores
;; NATURALEZA: Pura
;; ESTRATEGIA DE CONTROL: Composición funcional
;; IMPACTO EN MEMORIA: No destructiva
;; PROPÓSITO:
;; Calcular el porcentaje exacto que representa cada estado
;; del semáforo durante una hora.
;; ========================================================

(defun porcentaje-colores
       (tiempo-rojo
        tiempo-verde
        tiempo-amarillo
        tiempo-intermitencia)

  (let ((distribucion
          (distribucion-una-hora
           tiempo-rojo
           tiempo-verde
           tiempo-amarillo
           tiempo-intermitencia)))

    (list
     (list 'rojo
           (* (/ (first distribucion) 3600.0)
              100))

     (list 'verde
           (* (/ (second distribucion) 3600.0)
              100))

     (list 'amarillo
           (* (/ (third distribucion) 3600.0)
              100))

     (list 'amarillo-intermitente
           (* (/ (fourth distribucion) 3600.0)
              100)))))


;; ========================================================
;; FUNCIÓN: verificaciones
;; NATURALEZA: Pura
;; ESTRATEGIA DE CONTROL: Función no recursiva con COND
;; IMPACTO EN MEMORIA: No destructiva
;; PROPÓSITO:
;; Validar los tiempos ingresados y calcular la distribución
;; porcentual durante una hora.
;; ========================================================

(defun verificaciones
       (tiempo-rojo
        tiempo-verde
        tiempo-amarillo
        &optional
        (tiempo-intermitencia 3))

  (cond
    ((or (not (realp tiempo-rojo))
         (not (realp tiempo-verde))
         (not (realp tiempo-amarillo))
         (not (realp tiempo-intermitencia)))
     'error-duracion-no-numerica)

    ((or (<= tiempo-rojo 0)
         (<= tiempo-verde 0)
         (<= tiempo-amarillo 0)
         (<= tiempo-intermitencia 0))
     'error-duracion-no-positiva)

    (t
     (porcentaje-colores
      tiempo-rojo
      tiempo-verde
      tiempo-amarillo
      tiempo-intermitencia))))


;; ========================================================
;; EJEMPLOS DE USO DEL REQUERIMIENTO 6
;; ========================================================

;; Distribución en segundos con las reglas actuales:
;;
;; (distribucion-una-hora 90 120 6 3)
;;
;; Resultado esperado:
;; (1440 1920 96 144)


;; Porcentajes durante una hora:
;;
;; (verificaciones 90 120 6)
;;
;; Resultado aproximado esperado:
;; ((ROJO 40.0)
;;  (VERDE 53.333336)
;;  (AMARILLO 2.6666667)
;;  (AMARILLO-INTERMITENTE 4.0))


;; Entrada no numérica:
;;
;; (verificaciones 90 'verde 6)
;;
;; Resultado esperado:
;; ERROR-DURACION-NO-NUMERICA


;; Tiempo de intermitencia igual a cero:
;;
;; (verificaciones 90 120 6 0)
;;
;; Resultado esperado:
;; ERROR-DURACION-NO-POSITIVA
