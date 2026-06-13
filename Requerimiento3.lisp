
;; ============================================================================
;; FASE 1: GESTIÓN DE DEPENDENCIAS EXTERNAS (Quicklisp)
;; ============================================================================
(ql:quickload "local-time")
(use-package :local-time)

;; ============================================================================
;; REQUERIMIENTO 3: MÓDULO DE AUDITORÍA FORENSE (Totalmente Aislado)
;; NATURALEZA: Impura (Centraliza las operaciones de Entrada/Salida - I/O)
;; ============================================================================
;; ----------------------------------------------------------------------------
;; FUNCIÓN: log-auditoria
;; PROPÓSITO: Formatea e imprime el mensaje en consola usando 'local-time'
;; ----------------------------------------------------------------------------
(defun log-auditoria (timestamp color-anterior color-nuevo)
  (let* ((ts-obj (universal-to-timestamp timestamp))
         (fecha-hora (format-timestring nil ts-obj 
                       :format '((:year 4) "-" (:month 2) "-" (:day 2) " " 
                                 (:hour 2) ":" (:min 2) ":" (:sec 2)))))
    (format t "~%[~A] La luz ha cambiado de ~A a ~A" 
            fecha-hora 
            color-anterior 
            color-nuevo)))

;; ----------------------------------------------------------------------------
;; FUNCIÓN: procesar-cambios-auditoria
;; PROPÓSITO: Evalúa la transición inyectando el algoritmo temporal desde afuera
;; NOTA: No contiene la lógica del Punto 2; la recibe por parámetro.
;; ----------------------------------------------------------------------------
(defun procesar-cambios-auditoria (tiempo-actual color-previo funcion-temporizador)
  ;; funcall ejecuta la función externa que le pasemos, abstrayendo el cálculo
  (let ((color-actual (funcall funcion-temporizador tiempo-actual)))
    
    ;; Si el resultado de esa función externa difiere del estado previo, auditamos
    (if (not (eq color-previo color-actual))
        (log-auditoria tiempo-actual color-previo color-actual))
    
    ;; Retornamos el color actual para mantener la inmutabilidad de la pila
    color-actual

;; ----------------------------------------------------------------------------
;; CASO DE PRUEBA 1: Transición válida (Cambio de Rojo a Amarillo)
;; Entrada: Timestamp 3748990090 (Da residuo 90, debería ser Amarillo)
;; Estado Previo: 'en-rojo
;; Salida Esperada: Impresión en consola y retorno de 'en-amarillo
;; ----------------------------------------------------------------------------

;; ----------------------------------------------------------------------------
;; CASO DE PRUEBA 2: Estabilidad de Estado (No hay cambio de luces)
;; Entrada: Timestamp 3748990091 (Sigue dando residuo dentro de la zona Amarilla)
;; Estado Previo: 'en-amarillo
;; Salida Esperada: NO debe imprimir nada en consola (silencio). Retorna 'en-amarillo
;; ----------------------------------------------------------------------------

;; ----------------------------------------------------------------------------
;; CASO DE PRUEBA 3: Condición Límite (Último segundo del Amarillo antes del Verde)
;; Entrada: Timestamp 3748990095 (Residuo 95, límite superior de Amarillo)
;; Estado Previo: 'en-rojo (Forzamos rojo para obligar a que imprima)
;; Salida Esperada: Impresión en consola mostrando cambio de ROJO a AMARILLO
;; ----------------------------------------------------------------------------

;; ----------------------------------------------------------------------------
;; CASO DE PRUEBA 4: Transición al Verde (Corte exacto en residuo 96)
;; Entrada: Timestamp 3748990096 (Residuo 96, arranca el Verde)
;; Estado Previo: 'en-amarillo
;; Salida Esperada: Impresión en consola mostrando cambio de AMARILLO a VERDE
;; ----------------------------------------------------------------------------