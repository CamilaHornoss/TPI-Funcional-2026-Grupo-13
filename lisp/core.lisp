;; ========================================================
;; SISTEMA DE SEMÁFOROS INTELIGENTES
;; ARCHIVO PRINCIPAL: core_sin_iteracion2.lisp
;; VERSION BASE: SIN ITERACION 2
;; ========================================================


;; ========================================================
;; COMPATIBILIDAD CON SBCL
;; ========================================================

(shadow 'timer)


;; ========================================================
;; REQUERIMIENTO 1: TRANSICIÓN DE ESTADOS DEL SEMÁFORO
;; ========================================================

;; ========================================================
;; FUNCIÓN: transicion
;; NATURALEZA: Pura
;; ESTRATEGIA DE CONTROL: Elección múltiple mediante el uso del condicional COND
;; IMPACTO EN MEMORIA: No destructiva
;; PROPÓSITO:
;; La función tiene como propósito determinar la acción a realizar
;; en base a su estado actual y al estado al que se quiere cambiar.
;; La misma nos devuelve una lista con el estado actual y la acción a realizar,
;; si dicha acción no está definida dentro de las opciones disponibles en el
;; COND devuelve una lista con el estado actual y la acción por defecto.
;; ========================================================

(defun transicion (color-actual cambiar-a)
  (cond
    ((and (equal color-actual 'en-rojo)
          (equal cambiar-a 'verde))
     (list color-actual "cambiar-a-verde"))

    ((and (equal color-actual 'en-verde)
          (equal cambiar-a 'amarillo))
     (list color-actual "cambiar-a-amarillo"))

    ((and (equal color-actual 'en-amarillo)
          (equal cambiar-a 'rojo))
     (list color-actual "cambiar-a-rojo"))

    (t
     (list color-actual 'accion-por-defecto))))


;; ========================================================
;; EJEMPLOS DE USO DE LA FUNCIÓN TRANSICION
;; ========================================================

;; (transicion 'en-rojo 'verde)
;; Resultado esperado: (EN-ROJO "cambiar-a-verde")

;; (transicion 'en-verde 'amarillo)
;; Resultado esperado: (EN-VERDE "cambiar-a-amarillo")

;; (transicion 'en-amarillo 'rojo)
;; Resultado esperado: (EN-AMARILLO "cambiar-a-rojo")

;; (transicion 'en-rojo 'amarillo)
;; Resultado esperado: (EN-ROJO ACCION-POR-DEFECTO)

;; (transicion 'celeste 'rojo)
;; Resultado esperado: (CELESTE ACCION-POR-DEFECTO)

;; (transicion 'en-rojo)
;; Resultado esperado: error por falta del argumento CAMBIAR-A


;; ========================================================
;; REQUERIMIENTO 2: TEMPORIZADOR AUTOMÁTICO
;; ========================================================

;; ========================================================
;; FUNCIÓN: timer
;; NATURALEZA: Pura
;; ESTRATEGIA DE CONTROL: Selección múltiple mediante el condicional COND
;; IMPACTO EN MEMORIA: No destructiva
;; PROPÓSITO:
;; Determinar el estado en el que se encuentra el semáforo
;; para un tiempo dado. La función calcula el estado
;; del semáforo dentro de un ciclo de 216 segundos.
;; El cálculo se realiza mediante la operación módulo y,
;; según el intervalo correspondiente, devuelve EN-ROJO,
;; EN-VERDE o EN-AMARILLO. Dicho ciclo se repite indefinidamente
;; cada 216 segundos.
;; ========================================================

(defun timer (tiempo)
  (cond
    ((not (and (integerp tiempo) (>= tiempo 0)))
     'error)

    ((< (mod tiempo 216) 90)
     'en-rojo)

    ((< (mod tiempo 216) 210)
     'en-verde)

    (t
     'en-amarillo)))


;; ========================================================
;; EJEMPLOS DE USO DE TIMER
;; ========================================================

;; (timer 35)  ; EN-ROJO
;; (timer 89)  ; EN-ROJO
;; (timer 90)  ; EN-VERDE
;; (timer 145) ; EN-VERDE
;; (timer 209) ; EN-VERDE
;; (timer 210) ; EN-AMARILLO
;; (timer 213) ; EN-AMARILLO
;; (timer 216) ; EN-ROJO
;; (timer 220) ; EN-ROJO
;; (timer 543) ; EN-VERDE
;; (timer 'rojo) ; ERROR


;; ========================================================
;; FASE 2: GESTIÓN DE DEPENDENCIAS EXTERNAS
;; ========================================================

(eval-when (:compile-toplevel :load-toplevel :execute)
  (unless (find-package :ql)
    (let ((quicklisp-setup
            (merge-pathnames
             "quicklisp/setup.lisp"
             (user-homedir-pathname))))
      (if (probe-file quicklisp-setup)
          (load quicklisp-setup)
          (error
           "Quicklisp no esta instalado o no se encontro ~A."
           quicklisp-setup))))
  (funcall (intern "QUICKLOAD" :ql) :local-time))

(use-package :local-time)


;; ========================================================
;; REQUERIMIENTO 3: MÓDULO DE AUDITORÍA FORENSE
;; ========================================================

;; ========================================================
;; FUNCIÓN: log-auditoria
;; NATURALEZA: Impura
;; ESTRATEGIA DE CONTROL: Función simple
;; IMPACTO EN MEMORIA: No destructiva
;; PROPÓSITO:
;; Convertir un timestamp Unix a una fecha y hora legibles
;; e imprimir el cambio de estado del semáforo en la consola.
;; ========================================================

(defun log-auditoria (timestamp color-anterior color-nuevo)
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


;; ========================================================
;; FUNCIÓN: procesar-cambios-auditoria
;; NATURALEZA: Impura
;; ESTRATEGIA DE CONTROL: Función de orden superior
;; IMPACTO EN MEMORIA: No destructiva
;; PROPÓSITO:
;; Determinar el color actual utilizando una función temporizadora
;; recibida como parámetro y registrar el cambio cuando el nuevo
;; color es diferente del estado anterior.
;; ========================================================

(defun procesar-cambios-auditoria
       (tiempo-actual color-previo funcion-temporizador)
  (let ((color-actual
          (funcall funcion-temporizador tiempo-actual)))
    (cond
      ((eq color-actual 'error)
       'error)

      ((not (eq color-previo color-actual))
       (log-auditoria
        tiempo-actual
        color-previo
        color-actual)
       color-actual)

      (t
       color-actual))))


;; ========================================================
;; EJEMPLOS DE USO DEL REQUERIMIENTO 3
;; ========================================================

;; (procesar-cambios-auditoria 90 'en-rojo #'timer)
;; Imprime el cambio de EN-ROJO a EN-VERDE y devuelve EN-VERDE.

;; (procesar-cambios-auditoria 145 'en-verde #'timer)
;; No imprime cambios y devuelve EN-VERDE.

;; (procesar-cambios-auditoria 210 'en-verde #'timer)
;; Imprime el cambio de EN-VERDE a EN-AMARILLO y devuelve EN-AMARILLO.

;; (procesar-cambios-auditoria 'rojo 'en-rojo #'timer)
;; Resultado esperado: ERROR


;; ========================================================
;; REQUERIMIENTO 4: ANÁLISIS DE CICLOS SEMAFÓRICOS
;; ========================================================

;; ========================================================
;; FUNCIÓN: duracion-ciclo
;; NATURALEZA: Pura
;; ESTRATEGIA DE CONTROL: Función no recursiva con COND
;; IMPACTO EN MEMORIA: No destructiva
;; PROPÓSITO:
;; Calcular la duración total de un ciclo completo:
;; rojo → verde → amarillo.
;; El ciclo finaliza al terminar el estado amarillo.
;; ========================================================

(defun duracion-ciclo (&optional
                       (tiempo-rojo 90)
                       (tiempo-verde 120)
                       (tiempo-amarillo 6))
  (cond
    ((or (not (realp tiempo-rojo))
         (not (realp tiempo-verde))
         (not (realp tiempo-amarillo)))
     'error-tiempos-no-numericos)

    ((or (<= tiempo-rojo 0)
         (<= tiempo-verde 0)
         (<= tiempo-amarillo 0))
     'error-tiempos-no-positivos)

    (t
     (+ tiempo-rojo
        tiempo-verde
        tiempo-amarillo))))


;; ========================================================
;; FUNCIÓN: recomendacion-ciclo
;; NATURALEZA: Pura
;; ESTRATEGIA DE CONTROL: Función no recursiva con COND
;; IMPACTO EN MEMORIA: No destructiva
;; PROPÓSITO:
;; Evaluar la duración de un ciclo según el rango recomendado
;; de 35 a 150 segundos.
;; ========================================================

(defun recomendacion-ciclo (duracion)
  (cond
    ((not (realp duracion))
     'error-duracion-no-numerica)

    ((<= duracion 0)
     'error-duracion-no-positiva)

    ((< duracion 35)
     'aumentar-duracion-del-ciclo)

    ((> duracion 150)
     'reducir-duracion-del-ciclo)

    (t
     'duracion-optima)))


;; ========================================================
;; EJEMPLOS DE USO DEL REQUERIMIENTO 4
;; ========================================================

;; (duracion-ciclo) ; 216
;; (recomendacion-ciclo (duracion-ciclo))
;; REDUCIR-DURACION-DEL-CICLO
;; (duracion-ciclo 50 60 5) ; 115
;; (recomendacion-ciclo 30) ; AUMENTAR-DURACION-DEL-CICLO
;; (recomendacion-ciclo 35) ; DURACION-OPTIMA
;; (recomendacion-ciclo 150) ; DURACION-OPTIMA
;; (recomendacion-ciclo 'largo) ; ERROR-DURACION-NO-NUMERICA
;; (recomendacion-ciclo -20) ; ERROR-DURACION-NO-POSITIVA
;; (duracion-ciclo 90 'ciento-veinte 6) ; ERROR-TIEMPOS-NO-NUMERICOS
;; (duracion-ciclo 90 0 6) ; ERROR-TIEMPOS-NO-POSITIVOS


;; ========================================================
;; REQUERIMIENTO 5: PLANIFICACIÓN TEMPORAL
;; ========================================================

;; ========================================================
;; FUNCIÓN: ciclos-por-tiempo
;; NATURALEZA: Pura
;; ESTRATEGIA DE CONTROL: Composición funcional
;; IMPACTO EN MEMORIA: No destructiva
;; PROPÓSITO:
;; Calcular cuántos ciclos semafóricos completos entran en
;; una determinada cantidad de minutos.
;; ========================================================

(defun ciclos-por-tiempo (minutos)
  (cond
    ((not (realp minutos))
     'error-minutos-no-numericos)

    ((< minutos 0)
     'error-minutos-negativos)

    (t
     (nth-value
      0
      (floor
       (/ (* minutos 60)
          (duracion-ciclo)))))))


;; ========================================================
;; EJEMPLOS DE USO DEL REQUERIMIENTO 5
;; ========================================================

;; (ciclos-por-tiempo 15) ; 4
;; (ciclos-por-tiempo 60) ; 16
;; (ciclos-por-tiempo 3) ; 0
;; (ciclos-por-tiempo 0) ; 0
;; (ciclos-por-tiempo 7.2) ; 2
;; (ciclos-por-tiempo 'quince) ; ERROR-MINUTOS-NO-NUMERICOS
;; (ciclos-por-tiempo -15) ; ERROR-MINUTOS-NEGATIVOS


;; ========================================================
;; REQUERIMIENTO 6: INFORME DE DISTRIBUCIÓN TEMPORAL
;; ========================================================

;; ========================================================
;; FUNCIÓN: suma-tiempo
;; NATURALEZA: Pura
;; ESTRATEGIA DE CONTROL: Función simple
;; IMPACTO EN MEMORIA: No destructiva
;; PROPÓSITO:
;; Sumar los tiempos en segundos correspondientes a rojo,
;; verde y amarillo para obtener la duración total del ciclo.
;; ========================================================

(defun suma-tiempo (tiempo-rojo tiempo-verde tiempo-amarillo)
  (+ tiempo-rojo tiempo-verde tiempo-amarillo))


;; ========================================================
;; FUNCIÓN: distribucion-una-hora
;; NATURALEZA: Pura
;; ESTRATEGIA DE CONTROL: Función no recursiva con LET*
;; IMPACTO EN MEMORIA: No destructiva
;; PROPÓSITO:
;; Calcular la cantidad total de segundos que corresponde a
;; cada color durante una hora, considerando los ciclos
;; completos y el tiempo restante.
;; El período de una hora se analiza comenzando desde el estado rojo.
;; ========================================================

(defun distribucion-una-hora
       (tiempo-rojo tiempo-verde tiempo-amarillo)
  (let* ((duracion-total
           (suma-tiempo
            tiempo-rojo
            tiempo-verde
            tiempo-amarillo))

         (cantidad-ciclos
           (floor (/ 3600 duracion-total)))

         (tiempo-restante
           (mod 3600 duracion-total))

         (rojo-extra
           (min tiempo-restante tiempo-rojo))

         (restante-despues-rojo
           (max 0 (- tiempo-restante tiempo-rojo)))

         (verde-extra
           (min restante-despues-rojo tiempo-verde))

         (restante-despues-verde
           (max 0
                (- restante-despues-rojo tiempo-verde)))

         (amarillo-extra
           (min restante-despues-verde tiempo-amarillo))

         (total-rojo
           (+ (* cantidad-ciclos tiempo-rojo)
              rojo-extra))

         (total-verde
           (+ (* cantidad-ciclos tiempo-verde)
              verde-extra))

         (total-amarillo
           (+ (* cantidad-ciclos tiempo-amarillo)
              amarillo-extra)))

    (list total-rojo
          total-verde
          total-amarillo)))


;; ========================================================
;; FUNCIÓN: porcentaje-colores
;; NATURALEZA: Pura
;; ESTRATEGIA DE CONTROL: Composición funcional
;; IMPACTO EN MEMORIA: No destructiva
;; PROPÓSITO:
;; Calcular el porcentaje exacto que representa cada color
;; dentro de un período de una hora.
;; ========================================================

(defun porcentaje-colores
       (tiempo-rojo tiempo-verde tiempo-amarillo)
  (let ((distribucion
          (distribucion-una-hora
           tiempo-rojo
           tiempo-verde
           tiempo-amarillo)))
    (list
     (list 'rojo
           (* (/ (first distribucion) 3600.0) 100))

     (list 'verde
           (* (/ (second distribucion) 3600.0) 100))

     (list 'amarillo
           (* (/ (third distribucion) 3600.0) 100)))))


;; ========================================================
;; FUNCIÓN: verificaciones
;; NATURALEZA: Pura
;; ESTRATEGIA DE CONTROL: Función no recursiva con COND
;; IMPACTO EN MEMORIA: No destructiva
;; PROPÓSITO:
;; Validar los tiempos ingresados y, si son correctos,
;; calcular la distribución porcentual de los colores
;; durante una hora.
;; ========================================================

(defun verificaciones
       (tiempo-rojo tiempo-verde tiempo-amarillo)
  (cond
    ((or (not (realp tiempo-rojo))
         (not (realp tiempo-verde))
         (not (realp tiempo-amarillo)))
     'error-duracion-no-numerica)

    ((or (<= tiempo-rojo 0)
         (<= tiempo-verde 0)
         (<= tiempo-amarillo 0))
     'error-duracion-no-positiva)

    (t
     (porcentaje-colores
      tiempo-rojo
      tiempo-verde
      tiempo-amarillo))))


;; ========================================================
;; EJEMPLOS DE USO DEL REQUERIMIENTO 6
;; ========================================================

;; (verificaciones 90 120 6)
;; Resultado aproximado:
;; ((ROJO 42.5)
;;  (VERDE 54.833332)
;;  (AMARILLO 2.6666667))

;; (distribucion-una-hora 90 120 6)
;; Resultado esperado: (1530 1974 96)

;; (verificaciones 90 'verde 6)
;; Resultado esperado: ERROR-DURACION-NO-NUMERICA

;; (verificaciones 90 120 0)
;; Resultado esperado: ERROR-DURACION-NO-POSITIVA
