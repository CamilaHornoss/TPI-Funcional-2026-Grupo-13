(ql:quickload "local-time")
(use-package :local-time)

(defun log-auditoria (timestamp color-anterior color-nuevo)
  
  (let* ((ts-obj (universal-to-timestamp timestamp))
         (fecha-hora (format-timestring nil ts-obj 
                       :format '((:year 4) "-" (:month 2) "-" (:day 2) " " 
                                 (:hour 2) ":" (:min 2) ":" (:sec 2)))))
    ;; Retorna una lista estructurada: (Fecha/Hora Símbolo-Anterior Símbolo-Nuevo)
    (list fecha-hora color-anterior color-nuevo)))


(defun procesar-cambios-auditoria (tiempo-actual color-previo funcion-temporizador historial-acumulado)

  (let ((color-actual (funcall funcion-temporizador tiempo-actual)))
    (if (not (eq color-previo color-actual))
        (cons (log-auditoria tiempo-actual color-previo color-actual) historial-acumulado)
        historial-acumulado)))

(defun informe (datos)
  
  (with-open-file (stream "informe-ejecucion-semaforo.txt" 
                          :direction :output 
                          :if-exists :supersede 
                          :if-does-not-exist :create)
    ;; Encabezado del reporte
    (format stream "Informe de Ejecución del Sistema Semafórico~%")
    (format stream "============================================~%")
    
    ;; Iteramos en orden cronológico (los datos recolectados con cons vienen invertidos)
    (dolist (registro (reverse datos))
      (let ((fecha-hora (first registro))
            (anterior (second registro))
            (nuevo (third registro)))
        ;; Formato estricto: AAAA-MM-DD HH:MM:SS - Transición: ROJO → VERDE
        (format stream "~A - Transición: ~A → ~A~%" 
                fecha-hora 
                (string-upcase (symbol-name anterior)) 
                (string-upcase (symbol-name nuevo)))))
                
    (format stream "============================================~%")
    (format stream "~% --- Fin del Informe ---")))        


