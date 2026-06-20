// Se utiliza el objeto Semaforo para agrupar las funciones relacionadas
// con el comportamiento del semáforo y mejorar la organización del código.

object Semaforo {

  // ========================================================
  // REQUERIMIENTO 1: TRANSICIÓN DE ESTADOS DEL SEMÁFORO
  // ========================================================

  // ========================================================
  // FUNCIÓN: transicion
  // NATURALEZA: Pura
  // ESTRATEGIA DE CONTROL: Elección múltiple mediante MATCH
  // IMPACTO EN MEMORIA: No destructiva
  // PROPÓSITO:
  // Determinar la acción que debe realizar el semáforo según
  // el estado actual y el color al que se desea cambiar.
  // Devuelve una tupla formada por el estado actual y la acción.
  // Si la transición no es válida, devuelve "accion-por-defecto".
  // ========================================================

  def transicion(
      colorActual: String,
      cambiarA: String
  ): (String, String) = {

    (colorActual, cambiarA) match {

      // Cada case compara los valores recibidos con un patrón.
      // Cuando encuentra una coincidencia, devuelve el resultado
      // asociado y deja de evaluar los demás casos.

      case ("en-Rojo", "Verde") =>
        ("en-Rojo", "cambiar-a-verde")

      case ("en-Verde", "Amarillo") =>
        ("en-Verde", "cambiar-a-amarillo")

      case ("en-Amarillo", "Rojo") =>
        ("en-Amarillo", "cambiar-a-rojo")

      case _ =>
        (colorActual, "accion-por-defecto")
    }
  }

  // ========================================================
  // REQUERIMIENTO 2: TEMPORIZADOR AUTOMÁTICO
  // ========================================================

  // ========================================================
  // FUNCIÓN: timer
  // NATURALEZA: Pura
  // ESTRATEGIA DE CONTROL: Selección múltiple mediante IF/ELSE
  // IMPACTO EN MEMORIA: No destructiva
  // PROPÓSITO:
  // Determinar el color del semáforo en función del tiempo
  // transcurrido dentro del ciclo.
  // Devuelve "en-Rojo", "en-Verde" o "en-Amarillo".
  // ========================================================

  def timer(tiempo: Int): String = {

    if (tiempo < 0) {
      "Error"
    } else {
      // Val define una variable inmutable.
      val ciclo = tiempo % 216

      if (ciclo < 90) {
        "en-Rojo"
      } else if (ciclo < 210) {
        "en-Verde"
      } else {
        "en-Amarillo"
      }
    }
  }
}

// ========================================================
// EJEMPLOS DE USO
// ========================================================

// Semaforo.transicion("en-Rojo", "Verde")
// Resultado esperado: ("en-Rojo", "cambiar-a-verde")

// Semaforo.transicion("en-Verde", "Amarillo")
// Resultado esperado: ("en-Verde", "cambiar-a-amarillo")

// Semaforo.transicion("en-Amarillo", "Rojo")
// Resultado esperado: ("en-Amarillo", "cambiar-a-rojo")

// Semaforo.transicion("en-Rojo", "Amarillo")
// Resultado esperado: ("en-Rojo", "accion-por-defecto")

// Semaforo.transicion("Celeste", "Rojo")
// Resultado esperado: ("Celeste", "accion-por-defecto")

// Semaforo.timer(35)
// Resultado esperado: "en-Rojo"

// Semaforo.timer(90)
// Resultado esperado: "en-Verde"

// Semaforo.timer(210)
// Resultado esperado: "en-Amarillo"

// Semaforo.timer(216)
// Resultado esperado: "en-Rojo"

// Semaforo.timer(543)
// Resultado esperado: "en-Verde"

// Semaforo.timer(-1)
// Resultado esperado: "Error"

// ========================================================
// EJECUCIÓN DE PRUEBAS
// ========================================================

object PruebasSemaforo {

  def main(args: Array[String]): Unit = {

    println(Semaforo.transicion("en-Rojo", "Verde"))
    println(Semaforo.transicion("en-Verde", "Amarillo"))
    println(Semaforo.transicion("en-Amarillo", "Rojo"))
    println(Semaforo.transicion("en-Rojo", "Amarillo"))

    println(Semaforo.timer(35))
    println(Semaforo.timer(90))
    println(Semaforo.timer(210))
    println(Semaforo.timer(216))
    println(Semaforo.timer(543))
    println(Semaforo.timer(-1))
  }
}
