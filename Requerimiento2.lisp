(defun timer (tiempo) 

      (cond 

           ((< (mod tiempo 216) 90) 'en-rojo) 

           ((< (mod tiempo 216) 96) 'en-amarillo) 

           (t 'en-verde) 

))
