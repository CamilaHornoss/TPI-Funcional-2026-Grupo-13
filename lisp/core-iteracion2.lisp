;; ========================================================
;; SISTEMA DE SEMÁFOROS INTELIGENTES
;; CORE FINAL - REQUERIMIENTOS 1 AL 6 + ITERACIÓN 2
;; ========================================================

;; ========================================================
;; COMPATIBILIDAD CON SBCL
;; TIMER ya existe en el paquete SB-EXT. SHADOW crea un
;; símbolo TIMER propio en COMMON-LISP-USER para poder definir
;; la función solicitada por la consigna.
;; ========================================================

(shadow 'timer)

;; ========================================================
;; REQUERIMIENTO 1: TRANSICIÓN DE ESTADOS DEL SEMÁFORO
;; ITERACIÓN 2: INTERMITENCIA DE SEGURIDAD
;; ========================================================

;; ========================================================
;; FUNCIÓN: transicion
;; NATURALEZA: Pura
;; ESTRATEGIA DE CONTROL: Elección múltiple mediante COND
;; IMPACTO EN MEMORIA: No destructiva
;; PROPÓSITO:
;; Determinar la acción correspondiente a una transición,
;; incluyendo el estado amarillo intermitente de seguridad.
;;
;; El orden del ciclo es:
;; rojo → amarillo-intermitente → verde →
;; amarillo-intermitente → amarillo →
;; amarillo-intermitente → rojo.
;;
;; Cualquier cambio diferente devuelve ACCION-POR-DEFECTO.
;; ========================================================

(defun transicion (color-actual cambiar-a)
  (cond
    ;; Rojo → amarillo intermitente
    ((and (equal color-actual 'en-rojo)
          (equal cambiar-a 'amarillo-intermitente))
     (list color-actual
           "cambiar-a-amarillo-intermitente"))

    ;; Amarillo intermitente → verde
    ((and (equal color-actual 'amarillo-intermitente)
          (equal cambiar-a 'verde))
     (list color-actual
           "cambiar-a-verde"))

    ;; Verde → amarillo intermitente
    ((and (equal color-actual 'en-verde)
          (equal cambiar-a 'amarillo-intermitente))
     (list color-actual
           "cambiar-a-amarillo-intermitente"))

    ;; Amarillo intermitente → amarillo
    ((and (equal color-actual 'amarillo-intermitente)
          (equal cambiar-a 'amarillo))
     (list color-actual
           "cambiar-a-amarillo"))

    ;; Amarillo → amarillo intermitente
    ((and (equal color-actual 'en-amarillo)
          (equal cambiar-a 'amarillo-intermitente))
     (list color-actual
           "cambiar-a-amarillo-intermitente"))

    ;; Amarillo intermitente → rojo
    ((and (equal color-actual 'amarillo-intermitente)
          (equal cambiar-a 'rojo))
     (list color-actual
           "cambiar-a-rojo"))

    ;; Cualquier otra transición es inválida
    (t
     (list color-actual 'accion-por-defecto))))


;; ========================================================
;; CASOS DE PRUEBA: TRANSICIONES VÁLIDAS
;; ========================================================

;; Rojo → amarillo intermitente
;; (transicion 'en-rojo 'amarillo-intermitente)
;; Resultado esperado:
;; (EN-ROJO "cambiar-a-amarillo-intermitente")


;; Amarillo intermitente → verde
;; (transicion 'amarillo-intermitente 'verde)
;; Resultado esperado:
;; (AMARILLO-INTERMITENTE "cambiar-a-verde")


;; Verde → amarillo intermitente
;; (transicion 'en-verde 'amarillo-intermitente)
;; Resultado esperado:
;; (EN-VERDE "cambiar-a-amarillo-intermitente")


;; Amarillo intermitente → amarillo
;; (transicion 'amarillo-intermitente 'amarillo)
;; Resultado esperado:
;; (AMARILLO-INTERMITENTE "cambiar-a-amarillo")


;; Amarillo → amarillo intermitente
;; (transicion 'en-amarillo 'amarillo-intermitente)
;; Resultado esperado:
;; (EN-AMARILLO "cambiar-a-amarillo-intermitente")


;; Amarillo intermitente → rojo
;; Esta transición termina el ciclo actual e inicia el siguiente.
;; (transicion 'amarillo-intermitente 'rojo)
;; Resultado esperado:
;; (AMARILLO-INTERMITENTE "cambiar-a-rojo")


;; ========================================================
;; CASOS DE PRUEBA: TRANSICIONES NO PERMITIDAS
;; ========================================================

;; No se permite pasar directamente de rojo a verde.
;; (transicion 'en-rojo 'verde)
;; Resultado esperado:
;; (EN-ROJO ACCION-POR-DEFECTO)


;; No se permite pasar directamente de rojo a amarillo.
;; (transicion 'en-rojo 'amarillo)
;; Resultado esperado:
;; (EN-ROJO ACCION-POR-DEFECTO)


;; No se permite pasar directamente de verde a amarillo.
;; (transicion 'en-verde 'amarillo)
;; Resultado esperado:
;; (EN-VERDE ACCION-POR-DEFECTO)


;; No se permite pasar directamente de verde a rojo.
;; (transicion 'en-verde 'rojo)
;; Resultado esperado:
;; (EN-VERDE ACCION-POR-DEFECTO)


;; No se permite pasar directamente de amarillo a rojo.
;; Primero debe pasar por amarillo intermitente.
;; (transicion 'en-amarillo 'rojo)
;; Resultado esperado:
;; (EN-AMARILLO ACCION-POR-DEFECTO)


;; No se permite pasar de amarillo a verde.
;; (transicion 'en-amarillo 'verde)
;; Resultado esperado:
;; (EN-AMARILLO ACCION-POR-DEFECTO)


;; Estado no reconocido.
;; (transicion 'celeste 'verde)
;; Resultado esperado:
;; (CELESTE ACCION-POR-DEFECTO)


;; Destino no reconocido.
;; (transicion 'en-rojo 'azul)
;; Resultado esperado:
;; (EN-ROJO ACCION-POR-DEFECTO)


;; ========================================================
;; CASO QUE GENERA ERROR
;; ========================================================

;; Falta el argumento CAMBIAR-A.
;; (transicion 'en-rojo)
;; Resultado esperado:
;; error por cantidad incorrecta de argumentos


;; ========================================================
;; REQUERIMIENTO 2: TEMPORIZADOR AUTOMÁTICO
;; ITERACIÓN 2: INTERMITENCIA DE SEGURIDAD
;; ========================================================

;; ========================================================
;; FUNCIÓN: timer
;; NATURALEZA: Pura
;; ESTRATEGIA DE CONTROL: Selección múltiple mediante COND
;; IMPACTO EN MEMORIA: No destructiva
;; PROPÓSITO:
;; Determinar el estado en el que se encuentra el semáforo
;; para un tiempo dado.
;; La función calcula el estado dentro de un ciclo de
;; 225 segundos, incluyendo tres intervalos de amarillo
;; intermitente de 3 segundos cada uno.
;; El cálculo se realiza mediante la operación módulo.
;; ========================================================

(defun timer (tiempo)
  (cond
    ;; Control de entrada inválida o tiempo negativo.
    ((not (and (integerp tiempo)
               (>= tiempo 0)))
     'error)

    ;; Segundos 0 a 89: rojo.
    ((< (mod tiempo 225) 90)
     'en-rojo)

    ;; Segundos 90 a 92: primera intermitencia.
    ((< (mod tiempo 225) 93)
     'amarillo-intermitente)

    ;; Segundos 93 a 212: verde.
    ((< (mod tiempo 225) 213)
     'en-verde)

    ;; Segundos 213 a 215: segunda intermitencia.
    ((< (mod tiempo 225) 216)
     'amarillo-intermitente)

    ;; Segundos 216 a 221: amarillo.
    ((< (mod tiempo 225) 222)
     'en-amarillo)

    ;; Segundos 222 a 224: tercera intermitencia.
    (t
     'amarillo-intermitente)))


;; ========================================================
;; EJEMPLOS DE USO DE TIMER
;; ========================================================

;; Tiempo dentro del intervalo rojo:
;; (timer 35)
;; Resultado esperado: EN-ROJO

;; Último valor del intervalo rojo:
;; (timer 89)
;; Resultado esperado: EN-ROJO

;; Primer valor de la primera intermitencia:
;; (timer 90)
;; Resultado esperado: AMARILLO-INTERMITENTE

;; Último valor de la primera intermitencia:
;; (timer 92)
;; Resultado esperado: AMARILLO-INTERMITENTE

;; Primer valor del intervalo verde:
;; (timer 93)
;; Resultado esperado: EN-VERDE

;; Tiempo dentro del intervalo verde:
;; (timer 145)
;; Resultado esperado: EN-VERDE

;; Último valor del intervalo verde:
;; (timer 212)
;; Resultado esperado: EN-VERDE

;; Primer valor de la segunda intermitencia:
;; (timer 213)
;; Resultado esperado: AMARILLO-INTERMITENTE

;; Último valor de la segunda intermitencia:
;; (timer 215)
;; Resultado esperado: AMARILLO-INTERMITENTE

;; Primer valor del intervalo amarillo:
;; (timer 216)
;; Resultado esperado: EN-AMARILLO

;; Último valor del intervalo amarillo:
;; (timer 221)
;; Resultado esperado: EN-AMARILLO

;; Primer valor de la tercera intermitencia:
;; (timer 222)
;; Resultado esperado: AMARILLO-INTERMITENTE

;; Último valor de la tercera intermitencia:
;; (timer 224)
;; Resultado esperado: AMARILLO-INTERMITENTE

;; Inicio de un nuevo ciclo:
;; (timer 225)
;; Resultado esperado: EN-ROJO

;; Varios ciclos después:
;; (timer 543)
;; 543 MOD 225 = 93
;; Resultado esperado: EN-VERDE

;; Ejemplo que genera error controlado:
;; (timer 'rojo)
;; Resultado esperado: ERROR

;; Ejemplo que genera error controlado por tiempo negativo:
;; (timer -1)
;; Resultado esperado: ERROR

;; ============================================================================
;; FASE 2: GESTIÓN DE DEPENDENCIAS EXTERNAS (Quicklisp)
;; ============================================================================

(eval-when (:compile-toplevel :load-toplevel :execute)
  ;; Si Quicklisp todavía no está cargado, intenta cargar su archivo setup.lisp.
  (unless (find-package :ql)
    (let ((quicklisp-setup
            (merge-pathnames
             "quicklisp/setup.lisp"
             (user-homedir-pathname))))
      (if (probe-file quicklisp-setup)
          (load quicklisp-setup)
          (error
           "Quicklisp no está instalado o no se encontró ~A.~%Instalá Quicklisp o cargá setup.lisp antes de ejecutar este archivo."
           quicklisp-setup))))

  ;; Se evita escribir QL:QUICKLOAD directamente para que SBCL no falle
  ;; durante la lectura cuando el paquete QL aún no existe.
  (funcall (intern "QUICKLOAD" :ql) :local-time))
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
;; CASO DE PRUEBA 1: Transición de rojo a amarillo intermitente
;; ----------------------------------------------------------------------------
;;
;; (procesar-cambios-auditoria 90 'en-rojo #'timer)
;;
;; Resultado esperado:
;; imprime en consola:
;; [fecha y hora] La luz ha cambiado de EN-ROJO a AMARILLO-INTERMITENTE
;;
;; También devuelve:
;; AMARILLO-INTERMITENTE


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
;; CASO DE PRUEBA 3: Transición de verde a amarillo intermitente
;; ----------------------------------------------------------------------------
;;
;; (procesar-cambios-auditoria 213 'en-verde #'timer)
;;
;; Resultado esperado:
;; imprime en consola:
;; [fecha y hora] La luz ha cambiado de EN-VERDE a AMARILLO-INTERMITENTE
;;
;; También devuelve:
;; AMARILLO-INTERMITENTE


;; ----------------------------------------------------------------------------
;; CASO DE PRUEBA 4: Transición de amarillo intermitente a amarillo
;; ----------------------------------------------------------------------------
;;
;; (procesar-cambios-auditoria
;;  216
;;  'amarillo-intermitente
;;  #'timer)
;;
;; Resultado esperado:
;; imprime en consola:
;; [fecha y hora] La luz ha cambiado de
;; AMARILLO-INTERMITENTE a EN-AMARILLO
;;
;; También devuelve:
;; EN-AMARILLO


;; ----------------------------------------------------------------------------
;; CASO DE PRUEBA 5: Entrada inválida controlada
;; ----------------------------------------------------------------------------
;;
;; (procesar-cambios-auditoria 'rojo 'en-rojo #'timer)
;;
;; Resultado esperado:
;; ERROR
;;
;; No se registra ninguna transición en consola.

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

;; ========================================================
;; REQUERIMIENTO 4: ANÁLISIS DE CICLOS SEMAFÓRICOS
;; ITERACIÓN 2: INTERMITENCIA DE SEGURIDAD
;; ========================================================


;; ========================================================
;; FUNCIÓN: duracion-ciclo
;; NATURALEZA: Pura
;; ESTRATEGIA DE CONTROL: Función no recursiva con COND
;; IMPACTO EN MEMORIA: No destructiva
;; PROPÓSITO:
;; Calcular la duración total de un ciclo completo,
;; incluyendo tres intervalos de amarillo intermitente
;; de 3 segundos cada uno.
;;
;; El ciclo sigue el orden:
;; rojo → amarillo-intermitente → verde →
;; amarillo-intermitente → amarillo →
;; amarillo-intermitente.
;;
;; El ciclo finaliza al terminar la tercera intermitencia.
;; ========================================================

(defun duracion-ciclo (&optional
                       (tiempo-rojo 90)
                       (tiempo-verde 120)
                       (tiempo-amarillo 6)
                       (tiempo-intermitencia 3))
  (cond
    ((or (not (realp tiempo-rojo))
         (not (realp tiempo-verde))
         (not (realp tiempo-amarillo))
         (not (realp tiempo-intermitencia)))
     'error-tiempos-no-numericos)

    ((or (<= tiempo-rojo 0)
         (<= tiempo-verde 0)
         (<= tiempo-amarillo 0)
         (<= tiempo-intermitencia 0))
     'error-tiempos-no-positivos)

    (t
     (+ tiempo-rojo
        tiempo-verde
        tiempo-amarillo
        (* 3 tiempo-intermitencia)))))


;; ========================================================
;; FUNCIÓN: recomendacion-ciclo
;; NATURALEZA: Pura
;; ESTRATEGIA DE CONTROL: Función no recursiva con COND
;; IMPACTO EN MEMORIA: No destructiva
;; PROPÓSITO:
;; Evaluar la duración total del ciclo según el rango
;; recomendado de 35 a 150 segundos.
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

;; Caso normal con las reglas actuales:
;;
;; 90 segundos de rojo
;; 120 segundos de verde
;; 6 segundos de amarillo
;; 3 intermitencias de 3 segundos
;;
;; (duracion-ciclo)
;; Resultado esperado: 225


;; Evaluación del ciclo actual:
;;
;; (recomendacion-ciclo (duracion-ciclo))
;; Resultado esperado: REDUCIR-DURACION-DEL-CICLO


;; Camino alternativo dentro del rango recomendado:
;;
;; 50 + 60 + 5 + (3 × 3) = 124
;;
;; (duracion-ciclo 50 60 5 3)
;; Resultado esperado: 124
;;
;; (recomendacion-ciclo
;;  (duracion-ciclo 50 60 5 3))
;; Resultado esperado: DURACION-OPTIMA


;; Camino alternativo: ciclo demasiado corto:
;;
;; (recomendacion-ciclo 30)
;; Resultado esperado: AUMENTAR-DURACION-DEL-CICLO


;; Valores límite:
;;
;; (recomendacion-ciclo 35)
;; Resultado esperado: DURACION-OPTIMA
;;
;; (recomendacion-ciclo 150)
;; Resultado esperado: DURACION-OPTIMA


;; Ejemplo que genera error controlado:
;; duración no numérica.
;;
;; (recomendacion-ciclo 'largo)
;; Resultado esperado: ERROR-DURACION-NO-NUMERICA


;; Ejemplo que genera error controlado:
;; duración negativa.
;;
;; (recomendacion-ciclo -20)
;; Resultado esperado: ERROR-DURACION-NO-POSITIVA


;; Ejemplo que genera error controlado:
;; tiempo verde no numérico.
;;
;; (duracion-ciclo 90 'ciento-veinte 6 3)
;; Resultado esperado: ERROR-TIEMPOS-NO-NUMERICOS


;; Ejemplo que genera error controlado:
;; tiempo de intermitencia igual a cero.
;;
;; (duracion-ciclo 90 120 6 0)
;; Resultado esperado: ERROR-TIEMPOS-NO-POSITIVOS

;; ========================================================
;; REQUERIMIENTO 5: PLANIFICACIÓN TEMPORAL
;; ITERACIÓN 2
;; ========================================================

;; No fue necesario modificar la lógica de CICLOS-POR-TIEMPO,
;; ya que utiliza DURACION-CICLO. Al redefinirse DURACION-CICLO
;; en la Iteración 2, la duración del ciclo pasa de 216 a 225 segundos.

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

;; (ciclos-por-tiempo 15)
;; Resultado esperado: 4

;; (ciclos-por-tiempo 60)
;; Resultado esperado: 16

;; (ciclos-por-tiempo 3)
;; Resultado esperado: 0

;; (ciclos-por-tiempo 7.2)
;; Resultado esperado: 1

;; (ciclos-por-tiempo 7.5)
;; Resultado esperado: 2

;; (ciclos-por-tiempo 'quince)
;; Resultado esperado: ERROR-MINUTOS-NO-NUMERICOS

;; (ciclos-por-tiempo -15)
;; Resultado esperado: ERROR-MINUTOS-NEGATIVOS

;; ========================================================
;; REQUERIMIENTO 6: INFORME DE DISTRIBUCIÓN TEMPORAL
;; ITERACIÓN 2: INTERMITENCIA DE SEGURIDAD
;; ========================================================

;; Con las reglas actuales:
;; Rojo: 90 segundos
;; Verde: 120 segundos
;; Amarillo: 6 segundos
;; Amarillo intermitente: 3 intervalos de 3 segundos
;; Duración total: 225 segundos
;;
;; En una hora se completan exactamente 16 ciclos:
;; 3600 / 225 = 16


;; ========================================================
;; FUNCIÓN: suma-tiempo
;; NATURALEZA: Pura
;; ESTRATEGIA DE CONTROL: Función simple
;; IMPACTO EN MEMORIA: No destructiva
;; PROPÓSITO:
;; Calcular la duración total del ciclo, incluyendo los tres
;; intervalos de amarillo intermitente.
;; ========================================================

(defun suma-tiempo
       (tiempo-rojo
        tiempo-verde
        tiempo-amarillo
        tiempo-intermitencia)

  (+ tiempo-rojo
     tiempo-verde
     tiempo-amarillo
     (* 3 tiempo-intermitencia)))


;; ========================================================
;; FUNCIÓN: distribucion-una-hora
;; NATURALEZA: Pura
;; ESTRATEGIA DE CONTROL: Función no recursiva con LET*
;; IMPACTO EN MEMORIA: No destructiva
;; PROPÓSITO:
;; Calcular los segundos correspondientes a cada estado
;; durante una hora, incluyendo los ciclos completos y el
;; posible tiempo restante.
;; El período comienza en el estado rojo.
;; ========================================================

(defun distribucion-una-hora
       (tiempo-rojo
        tiempo-verde
        tiempo-amarillo
        tiempo-intermitencia)

  (let* ((duracion-total
           (suma-tiempo
            tiempo-rojo
            tiempo-verde
            tiempo-amarillo
            tiempo-intermitencia))

         (cantidad-ciclos
           (floor (/ 3600 duracion-total)))

         (tiempo-restante
           (mod 3600 duracion-total))

         ;; Rojo.
         (extra-rojo
           (min tiempo-restante tiempo-rojo))

         (resto-1
           (max 0
                (- tiempo-restante tiempo-rojo)))

         ;; Primera intermitencia.
         (extra-intermitente-1
           (min resto-1 tiempo-intermitencia))

         (resto-2
           (max 0
                (- resto-1 tiempo-intermitencia)))

         ;; Verde.
         (extra-verde
           (min resto-2 tiempo-verde))

         (resto-3
           (max 0
                (- resto-2 tiempo-verde)))

         ;; Segunda intermitencia.
         (extra-intermitente-2
           (min resto-3 tiempo-intermitencia))

         (resto-4
           (max 0
                (- resto-3 tiempo-intermitencia)))

         ;; Amarillo.
         (extra-amarillo
           (min resto-4 tiempo-amarillo))

         (resto-5
           (max 0
                (- resto-4 tiempo-amarillo)))

         ;; Tercera intermitencia.
         (extra-intermitente-3
           (min resto-5 tiempo-intermitencia))

         (total-rojo
           (+ (* cantidad-ciclos tiempo-rojo)
              extra-rojo))

         (total-verde
           (+ (* cantidad-ciclos tiempo-verde)
              extra-verde))

         (total-amarillo
           (+ (* cantidad-ciclos tiempo-amarillo)
              extra-amarillo))

         (total-intermitente
           (+ (* cantidad-ciclos
                 (* 3 tiempo-intermitencia))
              extra-intermitente-1
              extra-intermitente-2
              extra-intermitente-3)))

    (list total-rojo
          total-verde
          total-amarillo
          total-intermitente)))


;; ========================================================
;; FUNCIÓN: porcentaje-colores
;; NATURALEZA: Pura
;; ESTRATEGIA DE CONTROL: Composición funcional
;; IMPACTO EN MEMORIA: No destructiva
;; PROPÓSITO:
;; Calcular el porcentaje exacto que representa cada estado
;; del semáforo durante una hora.
;; ========================================================

(defun porcentaje-colores
       (tiempo-rojo
        tiempo-verde
        tiempo-amarillo
        tiempo-intermitencia)

  (let ((distribucion
          (distribucion-una-hora
           tiempo-rojo
           tiempo-verde
           tiempo-amarillo
           tiempo-intermitencia)))

    (list
     (list 'rojo
           (* (/ (first distribucion) 3600.0)
              100))

     (list 'verde
           (* (/ (second distribucion) 3600.0)
              100))

     (list 'amarillo
           (* (/ (third distribucion) 3600.0)
              100))

     (list 'amarillo-intermitente
           (* (/ (fourth distribucion) 3600.0)
              100)))))


;; ========================================================
;; FUNCIÓN: verificaciones
;; NATURALEZA: Pura
;; ESTRATEGIA DE CONTROL: Función no recursiva con COND
;; IMPACTO EN MEMORIA: No destructiva
;; PROPÓSITO:
;; Validar los tiempos ingresados y calcular la distribución
;; porcentual durante una hora.
;; ========================================================

(defun verificaciones
       (tiempo-rojo
        tiempo-verde
        tiempo-amarillo
        &optional
        (tiempo-intermitencia 3))

  (cond
    ((or (not (realp tiempo-rojo))
         (not (realp tiempo-verde))
         (not (realp tiempo-amarillo))
         (not (realp tiempo-intermitencia)))
     'error-duracion-no-numerica)

    ((or (<= tiempo-rojo 0)
         (<= tiempo-verde 0)
         (<= tiempo-amarillo 0)
         (<= tiempo-intermitencia 0))
     'error-duracion-no-positiva)

    (t
     (porcentaje-colores
      tiempo-rojo
      tiempo-verde
      tiempo-amarillo
      tiempo-intermitencia))))


;; ========================================================
;; EJEMPLOS DE USO DEL REQUERIMIENTO 6
;; ========================================================

;; Distribución en segundos con las reglas actuales:
;;
;; (distribucion-una-hora 90 120 6 3)
;;
;; Resultado esperado:
;; (1440 1920 96 144)


;; Porcentajes durante una hora:
;;
;; (verificaciones 90 120 6)
;;
;; Resultado aproximado esperado:
;; ((ROJO 40.0)
;;  (VERDE 53.333336)
;;  (AMARILLO 2.6666667)
;;  (AMARILLO-INTERMITENTE 4.0))


;; Entrada no numérica:
;;
;; (verificaciones 90 'verde 6)
;;
;; Resultado esperado:
;; ERROR-DURACION-NO-NUMERICA


;; Tiempo de intermitencia igual a cero:
;;
;; (verificaciones 90 120 6 0)
;;
;; Resultado esperado:
;; ERROR-DURACION-NO-POSITIVA
