;; ========================================================
;; REQUERIMIENTO 2: TEMPORIZADOR AUTOMÁTICO
;; ITERACIÓN 2: INTERMITENCIA DE SEGURIDAD
;; ========================================================

;; ========================================================
;; FUNCIÓN: timer
;; NATURALEZA: Pura
;; ESTRATEGIA DE CONTROL: Selección múltiple mediante COND
;; IMPACTO EN MEMORIA: No destructiva
;; PROPÓSITO:
;; Determinar el estado en el que se encuentra el semáforo
;; para un tiempo dado.
;; La función calcula el estado dentro de un ciclo de
;; 225 segundos, incluyendo tres intervalos de amarillo
;; intermitente de 3 segundos cada uno.
;; El cálculo se realiza mediante la operación módulo.
;; ========================================================

(defun timer (tiempo)
  (cond
    ;; Control de entrada inválida o tiempo negativo.
    ((not (and (integerp tiempo)
               (>= tiempo 0)))
     'error)

    ;; Segundos 0 a 89: rojo.
    ((< (mod tiempo 225) 90)
     'en-rojo)

    ;; Segundos 90 a 92: primera intermitencia.
    ((< (mod tiempo 225) 93)
     'amarillo-intermitente)

    ;; Segundos 93 a 212: verde.
    ((< (mod tiempo 225) 213)
     'en-verde)

    ;; Segundos 213 a 215: segunda intermitencia.
    ((< (mod tiempo 225) 216)
     'amarillo-intermitente)

    ;; Segundos 216 a 221: amarillo.
    ((< (mod tiempo 225) 222)
     'en-amarillo)

    ;; Segundos 222 a 224: tercera intermitencia.
    (t
     'amarillo-intermitente)))


;; ========================================================
;; EJEMPLOS DE USO DE TIMER
;; ========================================================

;; Tiempo dentro del intervalo rojo:
;; (timer 35)
;; Resultado esperado: EN-ROJO

;; Último valor del intervalo rojo:
;; (timer 89)
;; Resultado esperado: EN-ROJO

;; Primer valor de la primera intermitencia:
;; (timer 90)
;; Resultado esperado: AMARILLO-INTERMITENTE

;; Último valor de la primera intermitencia:
;; (timer 92)
;; Resultado esperado: AMARILLO-INTERMITENTE

;; Primer valor del intervalo verde:
;; (timer 93)
;; Resultado esperado: EN-VERDE

;; Tiempo dentro del intervalo verde:
;; (timer 145)
;; Resultado esperado: EN-VERDE

;; Último valor del intervalo verde:
;; (timer 212)
;; Resultado esperado: EN-VERDE

;; Primer valor de la segunda intermitencia:
;; (timer 213)
;; Resultado esperado: AMARILLO-INTERMITENTE

;; Último valor de la segunda intermitencia:
;; (timer 215)
;; Resultado esperado: AMARILLO-INTERMITENTE

;; Primer valor del intervalo amarillo:
;; (timer 216)
;; Resultado esperado: EN-AMARILLO

;; Último valor del intervalo amarillo:
;; (timer 221)
;; Resultado esperado: EN-AMARILLO

;; Primer valor de la tercera intermitencia:
;; (timer 222)
;; Resultado esperado: AMARILLO-INTERMITENTE

;; Último valor de la tercera intermitencia:
;; (timer 224)
;; Resultado esperado: AMARILLO-INTERMITENTE

;; Inicio de un nuevo ciclo:
;; (timer 225)
;; Resultado esperado: EN-ROJO

;; Varios ciclos después:
;; (timer 543)
;; 543 MOD 225 = 93
;; Resultado esperado: EN-VERDE

;; Ejemplo que genera error controlado:
;; (timer 'rojo)
;; Resultado esperado: ERROR

;; Ejemplo que genera error controlado por tiempo negativo:
;; (timer -1)
;; Resultado esperado: ERROR
