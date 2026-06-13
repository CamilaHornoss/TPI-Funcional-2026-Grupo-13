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
    ((and (equal color-Actual 'en-Rojo) (equal cambiar-a 'Amarillo-Intermitente)) 
     (list color-Actual "cambiar-a-Amarillo-Intermitente")) 

    ((and (equal color-Actual 'Amarillo-Intermitente) (equal cambiar-a 'Verde)) 
     (list color-Actual "cambiar-a-Verde")) 

    ((and (equal color-Actual 'en-Verde) (equal cambiar-a 'Amarillo-Intermitente)) 
     (list color-Actual "cambiar-a-Amarillo-Intermitente")) 

    ((and (equal color-Actual 'Amarillo-Intermitente) (equal cambiar-a 'Amarillo)) 
     (list color-Actual "cambiar-a-Amarillo")) 

    ((and (equal color-Actual 'en-Amarillo) (equal cambiar-a 'Amarillo-Intermitente)) 
     (list color-Actual "cambiar-a-Amarillo-Intermitente")) 

    ((and (equal color-Actual 'Amarillo-Intermitente) (equal cambiar-a 'Rojo)) 
     (list color-Actual "cambiar-a-Rojo")) 

    (t (list color-actual 'accion-por-defecto))))