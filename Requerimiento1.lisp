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
;; EJEMPLOS DE USO DE LA FUNCION TRANSICION
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
;; Resultado esperado: (EN-ROJO ACCION-POR-DEFECTO)

;; Estado no reconocido:
;; (transicion 'celeste 'Rojo)
;; Resultado esperado: (CELESTE ACCION-POR-DEFECTO)

    

