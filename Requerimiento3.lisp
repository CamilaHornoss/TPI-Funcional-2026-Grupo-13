
;; ============================================================================
;; FASE 1: GESTIÓN DE DEPENDENCIAS EXTERNAS (Quicklisp)
;; ============================================================================
(ql:quickload "local-time")
(use-package :local-time)

;; ============================================================================
;; REQUERIMIENTO 3: MÓDULO DE AUDITORÍA FORENSE (Totalmente Aislado)
;; CLASIFICACIÓN SEMÁNTICA: Módulo Impuro / Orientado a Efectos Colaterales de I/O
;; ESTRATEGIA: Inyección de Dependencias dinámica por Funciones de Orden Superior
;; INMUTABILIDAD: Alta (Persistencia de estados mediante transferencia en la pila)
;; ============================================================================

;; ----------------------------------------------------------------------------
;; FUNCIÓN: log-auditoria
;; CLASIFICACIÓN: Impura (Efecto colateral: Escritura en flujo de salida estándar)
;; PROPÓSITO: Formatea e imprime el mensaje en consola utilizando Unix Epoch.
;; ----------------------------------------------------------------------------
(defun log-auditoria (timestamp color-anterior color-nuevo)
  ;; let* garantiza la evaluación secuencial (en fila) de las variables locales
  (let* ((ts-obj (unix-to-timestamp timestamp))
         (fecha-hora (format-timestring nil ts-obj 
                       :format '((:year 4) "-" (:month 2) "-" (:day 2) " " 
                                 (:hour 2) ":" (:min 2) ":" (:sec 2)))))
    (format t "~%[~A] La luz ha cambiado de ~A a ~A" 
            fecha-hora 
            color-anterior 
            color-nuevo)))

;; ----------------------------------------------------------------------------
;; FUNCIÓN: procesar-cambios-auditoria
;; CLASIFICACIÓN: Impura (Orquesta componentes con efectos de Entrada/Salida)
;; PROPÓSITO: Evalúa la transición inyectando el algoritmo temporal desde afuera.
;; ----------------------------------------------------------------------------
(defun procesar-cambios-auditoria (tiempo-actual color-previo funcion-temporizador)
  ;; funcall ejecuta la función externa (timer) abstrayendo el cálculo matemático
  (let ((color-actual (funcall funcion-temporizador tiempo-actual)))
    
    ;; Evaluamos si existió una transición real de estados
    (if (not (eq color-previo color-actual))
        (log-auditoria tiempo-actual color-previo color-actual))
    ;; RETORNO: Se devuelve el color actual para mantener la cadena inmutable
    color-actual)) 


;; ----------------------------------------------------------------------------
;; CASO DE PRUEBA 1: Transición válida (Cambio de Rojo a Verde)
;; Entrada: Un timestamp que al pasar por el timer del R2 devuelva 'en-verde
;; Estado Previo: 'en-rojo
;; Salida Esperada: Impresión en consola [Fecha] La luz ha cambiado de EN-ROJO a EN-VERDE
;; ----------------------------------------------------------------------------


;; ----------------------------------------------------------------------------
;; CASO DE PRUEBA 2: Estabilidad de Estado (Mismo color, sin cambios)
;; Entrada: Un timestamp que mantenga el mismo color que el estado previo
;; Estado Previo: 'en-verde
;; Salida Esperada: Retorna 'en-verde en silencio (Sin logs en consola)
;; ----------------------------------------------------------------------------


;; ----------------------------------------------------------------------------
;; CASO DE PRUEBA 3: Transición a Amarillo
;; Entrada: Un timestamp que represente el tramo final del ciclo (Amarillo)
;; Estado Previo: 'en-verde
;; Salida Esperada: Impresión en consola mostrando cambio de EN-VERDE a EN-AMARILLO
;; ----------------------------------------------------------------------------
