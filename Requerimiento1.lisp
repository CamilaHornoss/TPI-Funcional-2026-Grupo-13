;; ========================================================
;; REQUERIMIENTO 1: TRANSICIÓN DE ESTADOS DEL SEMÁFORO
;; ========================================================

;; ========================================================
;; FUNCIÓN: transicion
;; NATURALEZA: Pura
;; ESTRATEGIA DE CONTROL: Elección múltiple mediante el uso del condicional COND
;; IMPACTO EN MEMORIA: No destructiva
;; PROPÓSITO:
;;La función tiene como propósito determinar la acción a realizar
;;en base a su estado actual y al estado al que se quiere cambiar.
;;La misma nos devuelve una lista con el estado actual y la acción a realizar,
;;si dicha acción no está definida dentro de las opciones disponibles en el 
;;COND devuelve una lista con el estado actual y la acción por defecto.
;; ========================================================

(defun transicion (color-Actual cambiar-A) 

     (cond  

           ((and(equal color-Actual 'en-Rojo)(equal cambiar-A 'Verde)) 

                 (list color-Actual "cambiar-a-Verde")) 

            ((and (equal color-Actual 'en-Verde)(equal cambiar-A 'Amarillo)) 

                  (list color-Actual "cambiar-a-Amarillo")) 

             ((and (equal color-Actual 'en-Amarillo)(equal cambiar-A 'Rojo)) 

                   (list color-Actual "cambiar-a-Rojo")) 

             (t(list color-Actual "accion-por-defecto"))) 
     )
;; ========================================================
;; EJEMPLOS DE USO DE LA FUNCIÓN TRANSICION
;; ========================================================

;; Cambio normal de rojo a verde:
;; (transicion 'en-rojo 'Verde)
;; Resultado esperado: (EN-ROJO "cambiar-a-Verde")

;; Cambio normal de verde a amarillo:
;; (transicion 'en-Verde 'Amarillo)
;; Resultado esperado: (EN-VERDE "cambiar-a-Amarillo")

;; Cambio normal de amarillo a rojo:
;; (transicion 'en-amarillo 'Rojo)
;; Resultado esperado: (EN-AMARILLO "cambiar-a-Rojo")

;; Cambio no permitido:
;; (transicion 'en-rojo 'amarillo)
;; Resultado esperado: (EN-ROJO "accion-por-defecto")

;; Estado no reconocido:
;; (transicion 'celeste 'Rojo)
;; Resultado esperado: (CELESTE "accion-por-defecto")

    

