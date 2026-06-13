


(defun duracion-ciclo (&optional
                       (tiempo-rojo 90)
                       (tiempo-amarillo 6)
                       (tiempo-verde 120)
                       (tiempo-intermitencia 3))
  (cond
    ((or (not (numberp tiempo-rojo))
         (not (numberp tiempo-amarillo))
         (not (numberp tiempo-verde))
         (not (numberp tiempo-intermitencia)))
     'error-tiempos-no-numericos)

    
    ((or (<= tiempo-rojo 0)
         (<= tiempo-amarillo 0)
         (<= tiempo-verde 0)
         (<= tiempo-intermitencia 0))
     'error-tiempos-no-positivos)

    (t
     (+ tiempo-rojo
        tiempo-amarillo
        tiempo-verde
        (* 3 tiempo-intermitencia)))))


(defun recomendacion-ciclo (duracion)
  "Evalúa la duración del ciclo y emite una recomendación según los rangos óptimos de la psicología vial."
  (cond
    ((not (numberp duracion))
     'error-duracion-no-numerica)

    ((<= duracion 0)
     'error-duracion-no-positiva)

    ((< duracion 35)
     'aumentar-duracion-del-ciclo)

    ((> duracion 150)
     'reducir-duracion-del-ciclo)

    (t
     'duracion-optima)))