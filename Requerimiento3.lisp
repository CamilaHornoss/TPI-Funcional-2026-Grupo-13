
(defun log-auditoria (timestamp color-anterior color-nuevo)
  (format t "~%Tiempo ~A: la luz ha cambiado de ~A a ~A" 
          timestamp 
          color-anterior 
          color-nuevo))

    ;; Aquí consume la información de tu Punto 2
(defun procesar-cambios-auditoria (tiempo-actual color-previo)
  (let ((color-actual (timer tiempo-actual)))
    
    ;; Condición de Transición: Si el color previo es diferente al actual, hubo un cambio
    (if (not (eq color-previo color-actual))
        (log-auditoria tiempo-actual color-previo color-actual))
    
    ;; Retornamos el color actual para que el sistema continúe el flujo recursivo
    color-actual))