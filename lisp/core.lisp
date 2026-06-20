;;; ========================================================
;;; SISTEMA DE SEMÁFOROS INTELIGENTES - GRUPO 13
;;; Common Lisp + Quicklisp + local-time
;;; Requerimientos 1 al 6 + Iteración 2
;;; ========================================================

;;; ========================================================
;;; FASE 2: LIBRERÍA EXTERNA
;;; FUNCIÓN: carga de local-time
;;; NATURALEZA: Impura
;;; ESTRATEGIA: carga mediante Quicklisp
;;; IMPACTO: habilita funciones externas de fecha y hora
;;; ========================================================

(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload :local-time))

;;; ========================================================
;;; FUNCIÓN: transiciones-validas
;;; NATURALEZA: Pura
;;; ESTRATEGIA: lista constante de reglas válidas
;;; IMPACTO: no destructiva
;;; ========================================================

(defun transiciones-validas ()
  '(((en-rojo amarillo-intermitente)
     "cambiar-a-amarillo-intermitente")
    ((amarillo-intermitente verde)
     "cambiar-a-verde")
    ((en-verde amarillo-intermitente)
     "cambiar-a-amarillo-intermitente")
    ((amarillo-intermitente amarillo)
     "cambiar-a-amarillo")
    ((en-amarillo amarillo-intermitente)
     "cambiar-a-amarillo-intermitente")
    ((amarillo-intermitente rojo)
     "cambiar-a-rojo")))

;;; ========================================================
;;; FUNCIÓN: coincide-transicion-p
;;; NATURALEZA: Pura
;;; ESTRATEGIA: comparación simbólica con EQL
;;; IMPACTO: no destructiva
;;; ========================================================

(defun coincide-transicion-p (regla actual destino)
  (and (eql actual (first (first regla)))
       (eql destino (second (first regla)))))

;;; ========================================================
;;; FUNCIÓN: buscar-transicion
;;; NATURALEZA: Pura
;;; ESTRATEGIA: recursión sobre lista de reglas
;;; IMPACTO: no destructiva
;;; ========================================================

(defun buscar-transicion (actual destino reglas)
  (cond
    ((null reglas) nil)
    ((coincide-transicion-p (first reglas) actual destino)
     (second (first reglas)))
    (t
     (buscar-transicion actual destino (rest reglas)))))

;;; ========================================================
;;; FUNCIÓN: transicion
;;; NATURALEZA: Pura
;;; ESTRATEGIA: búsqueda funcional de transición válida
;;; IMPACTO: no destructiva
;;; ========================================================

(defun transicion (color-actual cambiar-a)
  (let ((accion (buscar-transicion
                 color-actual
                 cambiar-a
                 (transiciones-validas))))
    (if accion
        (list color-actual accion)
        (list color-actual 'accion-por-defecto))))

;;; ========================================================
;;; FUNCIÓN: estado-ciclo
;;; NATURALEZA: Pura
;;; ESTRATEGIA: selección condicional por intervalos
;;; IMPACTO: no destructiva
;;; ========================================================

(defun estado-ciclo (segundo)
  (cond
    ((< segundo 90) 'en-rojo)
    ((< segundo 93) 'amarillo-intermitente)
    ((< segundo 213) 'en-verde)
    ((< segundo 216) 'amarillo-intermitente)
    ((< segundo 222) 'en-amarillo)
    (t 'amarillo-intermitente)))

;;; ========================================================
;;; FUNCIÓN: timer
;;; NATURALEZA: Pura
;;; ESTRATEGIA: módulo 225 y selección por intervalo
;;; IMPACTO: no destructiva
;;; ========================================================

#+sbcl
(sb-ext:without-package-locks
  (defun timer (tiempo)
    (if (and (integerp tiempo) (>= tiempo 0))
        (estado-ciclo (mod tiempo 225))
        'error)))

#-sbcl
(defun timer (tiempo)
  (if (and (integerp tiempo) (>= tiempo 0))
      (estado-ciclo (mod tiempo 225))
      'error))

;;; ========================================================
;;; FUNCIÓN: fecha-legible
;;; NATURALEZA: Pura respecto del valor recibido
;;; ESTRATEGIA: uso explícito de local-time
;;; IMPACTO: no destructiva
;;; ========================================================

(defun fecha-legible (timestamp)
  (local-time:format-timestring
   nil
   (local-time:unix-to-timestamp timestamp)
   :format '((:year 4) "-" (:month 2) "-" (:day 2)
             " " (:hour 2) ":" (:min 2) ":" (:sec 2))))

;;; ========================================================
;;; FUNCIÓN: log-auditoria
;;; NATURALEZA: Impura
;;; ESTRATEGIA: formateo de mensaje de auditoría
;;; IMPACTO: salida por consola
;;; ========================================================

(defun log-auditoria (timestamp color-anterior color-nuevo)
  (format t
          "~%[~A] La luz ha cambiado de ~A a ~A"
          (fecha-legible timestamp)
          color-anterior
          color-nuevo))

;;; ========================================================
;;; FUNCIÓN: procesar-cambios-auditoria
;;; NATURALEZA: Impura
;;; ESTRATEGIA: función de orden superior con FUNCALL
;;; IMPACTO: registra en consola si cambia el estado
;;; ========================================================

(defun procesar-cambios-auditoria (tiempo color-previo temporizador)
  (let ((color-actual (funcall temporizador tiempo)))
    (cond
      ((eql color-actual 'error) 'error)
      ((not (eql color-previo color-actual))
       (log-auditoria tiempo color-previo color-actual)
       color-actual)
      (t color-actual))))

;;; ========================================================
;;; FUNCIÓN: escribir-registro
;;; NATURALEZA: Impura
;;; ESTRATEGIA: función aplicada sobre cada registro
;;; IMPACTO: escritura en stream
;;; ========================================================

(defun escribir-registro (stream registro)
  (format stream "~A~%" registro))

;;; ========================================================
;;; FUNCIÓN: escribir-registros
;;; NATURALEZA: Impura
;;; ESTRATEGIA: recorrido funcional mediante MAPCAR
;;; IMPACTO: escritura no destructiva de cada registro
;;; ========================================================

(defun escribir-registros (datos stream)
  (mapcar
   (lambda (registro)
     (escribir-registro stream registro))
   datos))

;;; ========================================================
;;; FUNCIÓN: informe
;;; NATURALEZA: Impura
;;; ESTRATEGIA: persistencia en archivo de texto
;;; IMPACTO: genera informe-ejecucion-semaforo.txt
;;; ========================================================

(defun informe (datos)
  (with-open-file (stream "informe-ejecucion-semaforo.txt"
                          :direction :output
                          :if-exists :supersede
                          :if-does-not-exist :create)
    (format stream "Informe de Ejecución del Sistema Semafórico~%")
    (format stream "=========================================~%")
    (escribir-registros datos stream)
    (format stream "~%--- Fin del Informe ---"))
  'informe-generado)

;;; ========================================================
;;; FUNCIÓN: tiempos-numericos-p
;;; NATURALEZA: Pura
;;; ESTRATEGIA: validación funcional con EVERY
;;; IMPACTO: no destructiva
;;; ========================================================

(defun tiempos-numericos-p (tiempos)
  (every #'realp tiempos))

;;; ========================================================
;;; FUNCIÓN: tiempos-positivos-p
;;; NATURALEZA: Pura
;;; ESTRATEGIA: validación funcional con EVERY
;;; IMPACTO: no destructiva
;;; ========================================================

(defun tiempos-positivos-p (tiempos)
  (every (lambda (tiempo) (> tiempo 0)) tiempos))

;;; ========================================================
;;; FUNCIÓN: suma-tiempo
;;; NATURALEZA: Pura
;;; ESTRATEGIA: suma directa del ciclo completo
;;; IMPACTO: no destructiva
;;; ========================================================

(defun suma-tiempo (rojo verde amarillo intermitencia)
  (+ rojo verde amarillo (* 3 intermitencia)))

;;; ========================================================
;;; FUNCIÓN: duracion-ciclo
;;; NATURALEZA: Pura
;;; ESTRATEGIA: validación y composición con SUMA-TIEMPO
;;; IMPACTO: no destructiva
;;; ========================================================

(defun duracion-ciclo (&optional (rojo 90) (verde 120)
                                  (amarillo 6) (intermitencia 3))
  (let ((tiempos (list rojo verde amarillo intermitencia)))
    (cond
      ((not (tiempos-numericos-p tiempos)) 'error-tiempos-no-numericos)
      ((not (tiempos-positivos-p tiempos)) 'error-tiempos-no-positivos)
      (t (suma-tiempo rojo verde amarillo intermitencia)))))

;;; ========================================================
;;; FUNCIÓN: recomendacion-ciclo
;;; NATURALEZA: Pura
;;; ESTRATEGIA: selección condicional por rango
;;; IMPACTO: no destructiva
;;; ========================================================

(defun recomendacion-ciclo (duracion)
  (cond
    ((not (realp duracion)) 'error-duracion-no-numerica)
    ((<= duracion 0) 'error-duracion-no-positiva)
    ((< duracion 35) 'aumentar-duracion-del-ciclo)
    ((> duracion 150) 'reducir-duracion-del-ciclo)
    (t 'duracion-optima)))

;;; ========================================================
;;; FUNCIÓN: ciclos-por-tiempo
;;; NATURALEZA: Pura
;;; ESTRATEGIA: conversión de minutos y división entera
;;; IMPACTO: no destructiva
;;; ========================================================

(defun ciclos-por-tiempo (minutos)
  (cond
    ((not (realp minutos)) 'error-minutos-no-numericos)
    ((< minutos 0) 'error-minutos-negativos)
    (t (floor (/ (* minutos 60) (duracion-ciclo))))))

;;; ========================================================
;;; FUNCIÓN: estados-ciclo
;;; NATURALEZA: Pura
;;; ESTRATEGIA: representación ordenada del ciclo
;;; IMPACTO: no destructiva
;;; ========================================================

(defun estados-ciclo (rojo verde amarillo intermitencia)
  (list (list 'rojo rojo)
        (list 'amarillo-intermitente intermitencia)
        (list 'verde verde)
        (list 'amarillo-intermitente intermitencia)
        (list 'amarillo amarillo)
        (list 'amarillo-intermitente intermitencia)))

;;; ========================================================
;;; FUNCIÓN: tomar-tiempo
;;; NATURALEZA: Pura
;;; ESTRATEGIA: mínimo entre resto y duración del estado
;;; IMPACTO: no destructiva
;;; ========================================================

(defun tomar-tiempo (estado restante)
  (list (first estado)
        (min restante (second estado))))

;;; ========================================================
;;; FUNCIÓN: nuevo-restante
;;; NATURALEZA: Pura
;;; ESTRATEGIA: resta protegida con MAX
;;; IMPACTO: no destructiva
;;; ========================================================

(defun nuevo-restante (estado restante)
  (max 0 (- restante (second estado))))

;;; ========================================================
;;; FUNCIÓN: extras-por-resto
;;; NATURALEZA: Pura
;;; ESTRATEGIA: recursión sobre estados del ciclo
;;; IMPACTO: no destructiva
;;; ========================================================

(defun extras-por-resto (restante estados)
  (cond
    ((or (null estados) (<= restante 0)) nil)
    (t (cons (tomar-tiempo (first estados) restante)
             (extras-por-resto
              (nuevo-restante (first estados) restante)
              (rest estados))))))

;;; ========================================================
;;; FUNCIÓN: sumar-estado
;;; NATURALEZA: Pura
;;; ESTRATEGIA: recursión filtrando por estado
;;; IMPACTO: no destructiva
;;; ========================================================

(defun sumar-estado (estado pares)
  (cond
    ((null pares) 0)
    ((eql estado (first (first pares)))
     (+ (second (first pares))
        (sumar-estado estado (rest pares))))
    (t (sumar-estado estado (rest pares)))))

;;; ========================================================
;;; FUNCIÓN: segundos-estado
;;; NATURALEZA: Pura
;;; ESTRATEGIA: ciclos completos más tiempo restante
;;; IMPACTO: no destructiva
;;; ========================================================

(defun segundos-estado (estado ciclos base extras)
  (+ (* ciclos base)
     (sumar-estado estado extras)))

;;; ========================================================
;;; FUNCIÓN: distribucion-una-hora
;;; NATURALEZA: Pura
;;; ESTRATEGIA: descomposición en ciclos y resto
;;; IMPACTO: no destructiva
;;; ========================================================

(defun distribucion-una-hora (rojo verde amarillo intermitencia)
  (let* ((total (suma-tiempo rojo verde amarillo intermitencia))
         (ciclos (floor (/ 3600 total)))
         (restante (mod 3600 total))
         (estados (estados-ciclo rojo verde amarillo intermitencia))
         (extras (extras-por-resto restante estados)))
    (list (segundos-estado 'rojo ciclos rojo extras)
          (segundos-estado 'verde ciclos verde extras)
          (segundos-estado 'amarillo ciclos amarillo extras)
          (segundos-estado 'amarillo-intermitente
                           ciclos
                           (* 3 intermitencia)
                           extras))))

;;; ========================================================
;;; FUNCIÓN: porcentaje-par
;;; NATURALEZA: Pura
;;; ESTRATEGIA: cálculo porcentual por par estado-tiempo
;;; IMPACTO: no destructiva
;;; ========================================================

(defun porcentaje-par (par)
  (list (first par)
        (* (/ (second par) 3600.0) 100)))

;;; ========================================================
;;; FUNCIÓN: pares-distribucion
;;; NATURALEZA: Pura
;;; ESTRATEGIA: asociación de nombres con segundos
;;; IMPACTO: no destructiva
;;; ========================================================

(defun pares-distribucion (distribucion)
  (list (list 'rojo (first distribucion))
        (list 'verde (second distribucion))
        (list 'amarillo (third distribucion))
        (list 'amarillo-intermitente (fourth distribucion))))

;;; ========================================================
;;; FUNCIÓN: porcentaje-colores
;;; NATURALEZA: Pura
;;; ESTRATEGIA: composición funcional con MAPCAR
;;; IMPACTO: no destructiva
;;; ========================================================

(defun porcentaje-colores (rojo verde amarillo intermitencia)
  (mapcar #'porcentaje-par
          (pares-distribucion
           (distribucion-una-hora rojo verde amarillo intermitencia))))

;;; ========================================================
;;; FUNCIÓN: verificaciones
;;; NATURALEZA: Pura
;;; ESTRATEGIA: validación y cálculo porcentual
;;; IMPACTO: no destructiva
;;; ========================================================

(defun verificaciones (rojo verde amarillo &optional (intermitencia 3))
  (let ((tiempos (list rojo verde amarillo intermitencia)))
    (cond
      ((not (tiempos-numericos-p tiempos)) 'error-duracion-no-numerica)
      ((not (tiempos-positivos-p tiempos)) 'error-duracion-no-positiva)
      (t (porcentaje-colores rojo verde amarillo intermitencia)))))

;;; ========================================================
;;; CASOS DE PRUEBA ESPERADOS
;;; ========================================================

;;; (timer 90) => AMARILLO-INTERMITENTE
;;; (timer 93) => EN-VERDE
;;; (timer 216) => EN-AMARILLO
;;; (timer 225) => EN-ROJO
;;; (duracion-ciclo) => 225
;;; (ciclos-por-tiempo 15) => 4
;;; (distribucion-una-hora 90 120 6 3) => (1440 1920 96 144)
;;; (verificaciones 90 120 6)
;;; => ((ROJO 40.0) (VERDE 53.333336)
;;;     (AMARILLO 2.6666667) (AMARILLO-INTERMITENTE 4.0))
