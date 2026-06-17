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
;;
;; El orden del ciclo es:
;; rojo → amarillo-intermitente → verde →
;; amarillo-intermitente → amarillo →
;; amarillo-intermitente → rojo.
;;
;; Cualquier cambio diferente devuelve ACCION-POR-DEFECTO.
;; ========================================================

(defun transicion (color-actual cambiar-a)
  (cond
    ;; Rojo → amarillo intermitente
    ((and (equal color-actual 'en-rojo)
          (equal cambiar-a 'amarillo-intermitente))
     (list color-actual
           "cambiar-a-amarillo-intermitente"))

    ;; Amarillo intermitente → verde
    ((and (equal color-actual 'amarillo-intermitente)
          (equal cambiar-a 'verde))
     (list color-actual
           "cambiar-a-verde"))

    ;; Verde → amarillo intermitente
    ((and (equal color-actual 'en-verde)
          (equal cambiar-a 'amarillo-intermitente))
     (list color-actual
           "cambiar-a-amarillo-intermitente"))

    ;; Amarillo intermitente → amarillo
    ((and (equal color-actual 'amarillo-intermitente)
          (equal cambiar-a 'amarillo))
     (list color-actual
           "cambiar-a-amarillo"))

    ;; Amarillo → amarillo intermitente
    ((and (equal color-actual 'en-amarillo)
          (equal cambiar-a 'amarillo-intermitente))
     (list color-actual
           "cambiar-a-amarillo-intermitente"))

    ;; Amarillo intermitente → rojo
    ((and (equal color-actual 'amarillo-intermitente)
          (equal cambiar-a 'rojo))
     (list color-actual
           "cambiar-a-rojo"))

    ;; Cualquier otra transición es inválida
    (t
     (list color-actual 'accion-por-defecto))))


;; ========================================================
;; CASOS DE PRUEBA: TRANSICIONES VÁLIDAS
;; ========================================================

;; Rojo → amarillo intermitente
;; (transicion 'en-rojo 'amarillo-intermitente)
;; Resultado esperado:
;; (EN-ROJO "cambiar-a-amarillo-intermitente")


;; Amarillo intermitente → verde
;; (transicion 'amarillo-intermitente 'verde)
;; Resultado esperado:
;; (AMARILLO-INTERMITENTE "cambiar-a-verde")


;; Verde → amarillo intermitente
;; (transicion 'en-verde 'amarillo-intermitente)
;; Resultado esperado:
;; (EN-VERDE "cambiar-a-amarillo-intermitente")


;; Amarillo intermitente → amarillo
;; (transicion 'amarillo-intermitente 'amarillo)
;; Resultado esperado:
;; (AMARILLO-INTERMITENTE "cambiar-a-amarillo")


;; Amarillo → amarillo intermitente
;; (transicion 'en-amarillo 'amarillo-intermitente)
;; Resultado esperado:
;; (EN-AMARILLO "cambiar-a-amarillo-intermitente")


;; Amarillo intermitente → rojo
;; Esta transición termina el ciclo actual e inicia el siguiente.
;; (transicion 'amarillo-intermitente 'rojo)
;; Resultado esperado:
;; (AMARILLO-INTERMITENTE "cambiar-a-rojo")


;; ========================================================
;; CASOS DE PRUEBA: TRANSICIONES NO PERMITIDAS
;; ========================================================

;; No se permite pasar directamente de rojo a verde.
;; (transicion 'en-rojo 'verde)
;; Resultado esperado:
;; (EN-ROJO ACCION-POR-DEFECTO)


;; No se permite pasar directamente de rojo a amarillo.
;; (transicion 'en-rojo 'amarillo)
;; Resultado esperado:
;; (EN-ROJO ACCION-POR-DEFECTO)


;; No se permite pasar directamente de verde a amarillo.
;; (transicion 'en-verde 'amarillo)
;; Resultado esperado:
;; (EN-VERDE ACCION-POR-DEFECTO)


;; No se permite pasar directamente de verde a rojo.
;; (transicion 'en-verde 'rojo)
;; Resultado esperado:
;; (EN-VERDE ACCION-POR-DEFECTO)


;; No se permite pasar directamente de amarillo a rojo.
;; Primero debe pasar por amarillo intermitente.
;; (transicion 'en-amarillo 'rojo)
;; Resultado esperado:
;; (EN-AMARILLO ACCION-POR-DEFECTO)


;; No se permite pasar de amarillo a verde.
;; (transicion 'en-amarillo 'verde)
;; Resultado esperado:
;; (EN-AMARILLO ACCION-POR-DEFECTO)


;; Estado no reconocido.
;; (transicion 'celeste 'verde)
;; Resultado esperado:
;; (CELESTE ACCION-POR-DEFECTO)


;; Destino no reconocido.
;; (transicion 'en-rojo 'azul)
;; Resultado esperado:
;; (EN-ROJO ACCION-POR-DEFECTO)


;; ========================================================
;; CASO QUE GENERA ERROR
;; ========================================================

;; Falta el argumento CAMBIAR-A.
;; (transicion 'en-rojo)
;; Resultado esperado:
;; error por cantidad incorrecta de argumentos
