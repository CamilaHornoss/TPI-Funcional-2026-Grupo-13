;; ========================================================
;; ITERACIÓN 2 - EXTENSIÓN 2: PERSISTENCIA DE DATOS
;; ========================================================

;; ========================================================
;; FUNCIÓN: escribir-registros
;; NATURALEZA: Impura
;; ESTRATEGIA DE CONTROL: Recursiva simple
;; IMPACTO EN MEMORIA: No destructiva
;; PROPÓSITO:
;; Escribir cada registro de la lista en el archivo abierto.
;; ========================================================

(defun escribir-registros (datos stream)
  (cond
    ((null datos)
     nil)

    (t
     (format stream "~A~%" (car datos))
     (escribir-registros (cdr datos) stream))))


;; ========================================================
;; FUNCIÓN: informe
;; NATURALEZA: Impura
;; ESTRATEGIA DE CONTROL: Composición funcional
;; IMPACTO EN MEMORIA: No destructiva
;; PROPÓSITO:
;; Guardar el log de cambios de estado en un archivo
;; de texto plano.
;; ========================================================

(defun informe (datos)
  (with-open-file
      (stream
       "informe-ejecucion-semaforo.txt"
       :direction :output
       :if-exists :supersede
       :if-does-not-exist :create)

    (format stream
            "Informe de Ejecución del Sistema Semafórico~%")

    (format stream
            "=========================================~%")

    (escribir-registros datos stream)

    (format stream
            "~%--- Fin del Informe ---"))

  'informe-generado)


;; ========================================================
;; EJEMPLO DE USO
;; ========================================================

;; (informe
;;  '("2026-06-15 14:30:15 - Transición: ROJO → AMARILLO-INTERMITENTE"
;;    "2026-06-15 14:30:18 - Transición: AMARILLO-INTERMITENTE → VERDE"
;;    "2026-06-15 14:32:18 - Transición: VERDE → AMARILLO-INTERMITENTE"))
;;
;; Resultado esperado:
;; INFORME-GENERADO
;;
;; Archivo generado:
;; informe-ejecucion-semaforo.txt
