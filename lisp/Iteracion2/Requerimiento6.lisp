



(defun sumaTiempo (t_rojo t_verde t_amarillo t_intermitente)
  (+ t_rojo t_verde t_amarillo (* 3 t_intermitente)))


(defun porcentajeColores (t_rojo t_verde t_amarillo t_intermitente)
  
  (let ((total (sumaTiempo t_rojo t_verde t_amarillo t_intermitente)))
    (list 
      (list 'Rojo (float (* (/ t_rojo total) 100)))
      (list 'Verde (float (* (/ t_verde total) 100)))
      (list 'Amarillo (float (* (/ t_amarillo total) 100)))
      (list 'Amarillo-Intermitente (float (* (/ (* 3 t_intermitente) total) 100))))))
      

(defun verificaciones (t_rojo t_verde t_amarillo &optional (t_intermitente 3))
  (cond
    ((or (not (numberp t_rojo)) 
         (not (numberp t_verde)) 
         (not (numberp t_amarillo))
         (not (numberp t_intermitence (if (boundp 't_intermitente) t_intermitente 3)))) 
     'Error-Duracion-No-Numerica)
    
    ((/= (sumaTiempo t_rojo t_verde t_amarillo t_intermitente) 225) 
     'Ciclos-Desincronizados)
    
    (t 
     (porcentajeColores t_rojo t_verde t_amarillo t_intermitente))))