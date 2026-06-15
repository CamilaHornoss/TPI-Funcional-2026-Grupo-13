;; ========================================================
;; REQUERIMIENTO 5: PLANIFICACIÓN TEMPORAL
;; ITERACIÓN 2
;; ========================================================

;; No fue necesario modificar la función CICLOS-POR-TIEMPO,
;; ya que utiliza DURACION-CICLO.
;; Al redefinirse DURACION-CICLO en la Iteración 2,
;; la duración del ciclo pasa automáticamente de 216 a
;; 225 segundos.

;; Ejemplos actualizados:

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
