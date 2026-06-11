;; ========================================================
;; REQUERIMIENTO 1: TRANSICIÓN DE ESTADOS DEL SEMÁFORO
;; ========================================================

;; ========================================================
;; FUNCIÓN: transicion
;; NATURALEZA: Pura
;; ESTRATEGIA DE CONTROL: Eleccion multiple mediante el uso del condicional COND
;; IMPACTO EN MEMORIA: No destructiva
;; PROPÓSITO:
;;La funcion tiene como proposito determinar la accion a realizar
;;en base a su estado actual y al estado al que se quiere cambiar.
;;La misma, nos devuelve una lista con el estado actual y la accion a realizar,
;;si dicha accion no esta definida dentro de las opciones disponible en el 
;;COND devuelve una lista con el estado actual y la accion por defecto.
;; ========================================================

(defun transicion (color-Actual cambiar-a) 

     (cond  

           ((and(equal color-Actual 'en-Rojo)(equal cambiar-A 'Amarillo)) 

                 (list color-Actual "cambiar-a-Amarillo")) 

            ((and (equal color-Actual 'en-Amarillo)(equal cambiar-A 'Verde)) 

                  (list color-Actual "cambiar-a-Verde")) 

             ((and (equal color-Actual 'en-Verde)(equal cambiar-A 'Rojo)) 

                   (list color-Actual "cambiar-a-Rojo")) 

             (t(list color-actual 'accion-por-defecto))) 
     )
;; ========================================================
;; EJEMPLOS DE USO DE LA FUNCION TRANSICION
;; ========================================================

;; Cambio normal de rojo a amarillo:
;; (transicion 'en-rojo 'amarillo)
;; Resultado esperado: (EN-ROJO CAMBIAR-A-AMARILLO)

;; Cambio normal de amarillo a verde:
;; (transicion 'en-amarillo 'verde)
;; Resultado esperado: (EN-AMARILLO CAMBIAR-A-VERDE)

;; Cambio normal de verde a rojo:
;; (transicion 'en-verde 'rojo)
;; Resultado esperado: (EN-VERDE CAMBIAR-A-ROJO)

;; Cambio no permitido:
;; (transicion 'en-rojo 'verde)
;; Resultado esperado: (EN-ROJO ACCION-POR-DEFECTO)

;; Estado no reconocido:
;; (transicion 'celeste 'rojo)
;; Resultado esperado: (CELESTE ACCION-POR-DEFECTO)

    

