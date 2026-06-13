(defun transicion (color-Actual cambiar-a) 

     (cond  

           ((and(equal color-Actual 'en-Rojo)(equal cambiar-A 'Amarillo)) 

                 (list color-Actual "cambiar-a-Amarillo")) 

            ((and (equal color-Actual 'en-Amarillo)(equal cambiar-A 'Verde)) 

                  (list color-Actual "cambiar-a-Verde")) 

             ((and (equal color-Actual 'en-Verde)(equal cambiar-A 'Rojo)) 

                   (list color-Actual "cambiar-a-Rojo")) 

             (t(list color-actual 'accion-por-defecto))) 
)