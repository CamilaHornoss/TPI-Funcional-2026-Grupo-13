;; ========================================================
;; REQUERIMIENTO 1: TRANSICIÓN DE ESTADOS DEL SEMÁFORO
;; ITERACIÓN 2: INTERMITENCIA DE SEGURIDAD
;; ========================================================

;; ========================================================
;; FUNCIÓN: transicion
;; NATURALEZA: Pura
;; ESTRATEGIA DE CONTROL: Elección múltiple mediante COND
;; IMPACTO EN MEMORIA: No destructiva
;; PROPÓSITO:
;; Determinar la acción correspondiente a una transición,
;; incluyendo el estado amarillo intermitente de seguridad.
;; El ciclo sigue el orden:
;; rojo → amarillo-intermitente → verde →
;; amarillo-intermitente → amarillo →
;; amarillo-intermitente.
;; ========================================================

(defun transicion (color-actual cambiar-a)
  (cond
    ((and (equal color-actual 'en-rojo)
          (equal cambiar-a 'amarillo-intermitente))
     (list color-actual
           "cambiar-a-amarillo-intermitente"))

    ((and (equal color-actual 'amarillo-intermitente)
          (equal cambiar-a 'verde))
     (list color-actual
           "cambiar-a-verde"))

    ((and (equal color-actual 'en-verde)
          (equal cambiar-a 'amarillo-intermitente))
     (list color-actual
           "cambiar-a-amarillo-intermitente"))

    ((and (equal color-actual 'amarillo-intermitente)
          (equal cambiar-a 'amarillo))
     (list color-actual
           "cambiar-a-amarillo"))

    ((and (equal color-actual 'en-amarillo)
          (equal cambiar-a 'amarillo-intermitente))
     (list color-actual
           "cambiar-a-amarillo-intermitente"))

    ((and (equal color-actual 'amarillo-intermitente)
          (equal cambiar-a 'rojo))
     (list color-actual
           "cambiar-a-rojo"))

    (t
     (list color-actual 'accion-por-defecto))))


;; ========================================================
;; EJEMPLOS DE USO DEL REQUERIMIENTO 1
;; ========================================================

;; De rojo a amarillo intermitente:
;; (transicion 'en-rojo 'amarillo-intermitente)
;; Resultado esperado:
;; (EN-ROJO "cambiar-a-amarillo-intermitente")

;; De amarillo intermitente a verde:
;; (transicion 'amarillo-intermitente 'verde)
;; Resultado esperado:
;; (AMARILLO-INTERMITENTE "cambiar-a-verde")

;; De verde a amarillo intermitente:
;; (transicion 'en-verde 'amarillo-intermitente)
;; Resultado esperado:
;; (EN-VERDE "cambiar-a-amarillo-intermitente")

;; De amarillo intermitente a amarillo:
;; (transicion 'amarillo-intermitente 'amarillo)
;; Resultado esperado:
;; (AMARILLO-INTERMITENTE "cambiar-a-amarillo")

;; De amarillo a amarillo intermitente:
;; (transicion 'en-amarillo 'amarillo-intermitente)
;; Resultado esperado:
;; (EN-AMARILLO "cambiar-a-amarillo-intermitente")

;; De amarillo intermitente a rojo:
;; Esta transición inicia el ciclo siguiente.
;; (transicion 'amarillo-intermitente 'rojo)
;; Resultado esperado:
;; (AMARILLO-INTERMITENTE "cambiar-a-rojo")

;; Camino no permitido:
;; (transicion 'en-rojo 'verde)
;; Resultado esperado:
;; (EN-ROJO ACCION-POR-DEFECTO)

;; Estado no reconocido:
;; (transicion 'celeste 'rojo)
;; Resultado esperado:
;; (CELESTE ACCION-POR-DEFECTO)

;; Ejemplo que genera error por falta de argumentos:
;; (transicion 'en-rojo)
;; Resultado esperado:
;; error por falta del argumento CAMBIAR-A
