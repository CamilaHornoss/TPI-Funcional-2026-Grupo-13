;; ========================================================
;; FUNCIÓN: timer
;; NATURALEZA: Pura
;; ESTRATEGIA DE CONTROL: seleccion multiple mediante el condicional COND
;; IMPACTO EN MEMORIA: No destructiva
;; PROPÓSITO:
;; Determinar el estado en el que se encuentra el semáforo
;; para un tiempo dado. La función calcula el estado 
;; del semaforo dentro de un ciclo de 216 segundos.
;; El calculo se realiza mediante la operación módulo y,
;; según el intervalo correspondiente, devuelve EN-ROJO, 
;; EN-AMARILLO o EN-VERDE.Dicho ciclo se repite indefinidamente
;; cada 216 segundos.
;; ========================================================

(defun timer (tiempo) 

      (cond 
           ((not(numberp tiempo)) 'Error)
           ((< (mod tiempo 216) 90) 'en-rojo) 
           ((< (mod tiempo 216) 210) 'en-Verde) 
           (t 'en-Amarillo))
      )
;; ========================================================
;; EJEMPLOS DE USO DE TIMER
;; ========================================================

;; Tiempo dentro del intervalo rojo:
;; (timer 35)
;; Resultado esperado: EN-ROJO

;; Último valor del intervalo rojo:
;; (timer 89)
;; Resultado esperado: EN-ROJO

;; Primer valor del intervalo verde:
;; (timer 90)
;; Resultado esperado: EN-VERDE

;; Tiempo dentro del intervalo verde:
;; (timer 145)
;; Resultado esperado: EN-VERDE

;; Último valor del intervalo verde:
;; (timer 209)
;; Resultado esperado: EN-VERDE

;; Primer valor del intervalo  amarillo:
;; (timer 210)
;; Resultado esperado: EN-AMARILLO

;; Tiempo dentro del intervalo amarillo:
;; (timer 213)
;; Resultado esperado: EN-AMARILLO

;; Inicio de un nuevo ciclo:
;; (timer 216)
;; Resultado esperado: EN-ROJO

;; Tiempo mayor a un ciclo completo:
;; (timer 220)
;; Resultado esperado: EN-ROJO

;; Varios ciclos después:
;; (timer 543)
;; Resultado esperado: EN-VERDE

;; Ejemplo que genera error controlado:
;; (timer 'Rojo)
;;Resultado esperado: Error
