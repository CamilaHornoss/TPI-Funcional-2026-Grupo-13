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

  ((not (numberp tiempo)) 'Error)
    ((< (mod tiempo 225) 90) 'en-Rojo) 
    ((< (mod tiempo 225) 93) 'Amarillo-Intermitente) 
    ((< (mod tiempo 225) 213) 'en-Verde)
    ((< (mod tiempo 225) 216) 'Amarillo-Intermitente)
    ((< (mod tiempo 225) 222) 'en-Amarillo)
    (t 'Amarillo-Intermitente)))

    ;; ========================================================
;; EJEMPLOS DE USO DE TIMER
;; ========================================================

;; Tiempo dentro del intervalo rojo:
;; (timer 35)
;; Resultado esperado: EN-ROJO

;; Último valor del intervalo rojo:
;; (timer 89)
;; Resultado esperado: EN-ROJO

;; Primer valor del intervalo amarillo:
;; (timer 90)
;; Resultado esperado: EN-AMARILLO

;; Último valor del intervalo amarillo:
;; (timer 95)
;; Resultado esperado: EN-AMARILLO

;; Primer valor del intervalo verde:
;; (timer 96)
;; Resultado esperado: EN-VERDE

;; Tiempo dentro del intervalo verde:
;; (timer 145)
;; Resultado esperado: EN-VERDE

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
