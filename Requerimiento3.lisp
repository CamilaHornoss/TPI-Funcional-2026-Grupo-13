;; ============================================================================
;; FASE 2: GESTIÓN DE DEPENDENCIAS EXTERNAS (Quicklisp)
;; ============================================================================

(ql:quickload :local-time)
(use-package :local-time)


;; ============================================================================
;; REQUERIMIENTO 3: MÓDULO DE AUDITORÍA FORENSE
;; ============================================================================


;; ----------------------------------------------------------------------------
;; FUNCIÓN: log-auditoria
;; NATURALEZA: Impura
;; ESTRATEGIA DE CONTROL: Función simple
;; IMPACTO EN MEMORIA: No destructiva
;; PROPÓSITO:
;; Convertir un timestamp Unix a una fecha y hora legibles
;; e imprimir el cambio de estado del semáforo en la consola.
;; ----------------------------------------------------------------------------

(defun log-auditoria (timestamp color-anterior color-nuevo)
  ;; LET* garantiza la evaluación secuencial de las variables locales.
  (let* ((ts-obj (unix-to-timestamp timestamp))
         (fecha-hora
           (format-timestring
            nil
            ts-obj
            :format '((:year 4) "-"
                      (:month 2) "-"
                      (:day 2) " "
                      (:hour 2) ":"
                      (:min 2) ":"
                      (:sec 2)))))
    (format t
            "~%[~A] La luz ha cambiado de ~A a ~A"
            fecha-hora
            color-anterior
            color-nuevo)))


;; ----------------------------------------------------------------------------
;; FUNCIÓN: procesar-cambios-auditoria
;; NATURALEZA: Impura
;; ESTRATEGIA DE CONTROL: Función de orden superior
;; IMPACTO EN MEMORIA: No destructiva
;; PROPÓSITO:
;; Determinar el color actual utilizando una función temporizadora
;; recibida como parámetro y registrar el cambio cuando el nuevo
;; color es diferente del estado anterior.
;; ----------------------------------------------------------------------------

(defun procesar-cambios-auditoria
       (tiempo-actual color-previo funcion-temporizador)

  ;; FUNCALL ejecuta la función recibida como parámetro.
  (let ((color-actual
          (funcall funcion-temporizador tiempo-actual)))

    (cond
      ;; Si el temporizador informa una entrada inválida,
      ;; se devuelve ERROR sin registrar una transición.
      ((eq color-actual 'error)
       'error)

      ;; Si el color cambió, se registra la transición.
      ((not (eq color-previo color-actual))
       (log-auditoria
        tiempo-actual
        color-previo
        color-actual)
       color-actual)

      ;; Si no hubo cambio, se devuelve el color actual
      ;; sin generar una salida en consola.
      (t
       color-actual))))


;; ============================================================================
;; EJEMPLOS DE USO DEL REQUERIMIENTO 3
;; ============================================================================


;; ----------------------------------------------------------------------------
;; CASO DE PRUEBA 1: Transición válida de rojo a verde
;; ----------------------------------------------------------------------------
;;
;; (procesar-cambios-auditoria 90 'en-rojo #'timer)
;;
;; Resultado esperado:
;; imprime en consola:
;; [fecha y hora] La luz ha cambiado de EN-ROJO a EN-VERDE
;;
;; También devuelve:
;; EN-VERDE


;; ----------------------------------------------------------------------------
;; CASO DE PRUEBA 2: Estabilidad del estado
;; ----------------------------------------------------------------------------
;;
;; (procesar-cambios-auditoria 145 'en-verde #'timer)
;;
;; Resultado esperado:
;; no imprime ningún registro porque el color no cambió.
;;
;; Devuelve:
;; EN-VERDE


;; ----------------------------------------------------------------------------
;; CASO DE PRUEBA 3: Transición de verde a amarillo
;; ----------------------------------------------------------------------------
;;
;; (procesar-cambios-auditoria 210 'en-verde #'timer)
;;
;; Resultado esperado:
;; imprime en consola:
;; [fecha y hora] La luz ha cambiado de EN-VERDE a EN-AMARILLO
;;
;; También devuelve:
;; EN-AMARILLO


;; ----------------------------------------------------------------------------
;; CASO DE PRUEBA 4: Entrada inválida controlada
;; ----------------------------------------------------------------------------
;;
;; (procesar-cambios-auditoria 'rojo 'en-rojo #'timer)
;;
;; Resultado esperado:
;; ERROR
;;
;; No se registra ninguna transición en consola.
