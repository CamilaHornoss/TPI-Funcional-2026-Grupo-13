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
// La función tiene como propósito determinar el siguiente
// estado del semáforo en base al color actual.
// Devuelve el color correspondiente a la siguiente transición.
// Si el color ingresado no es válido, devuelve "accion-por-defecto".
// ========================================================

  def transicion(colorActual: String, cambiarA: String): (String, String) = {

    (colorActual, cambiarA) match { //ocupamos match, ya que su uso es similar al cond en lisp
    
    //Cada case va comparando si los valores recibidos en el match coinciden con el patrón definido. 
    //Cuando encuentra una coincidencia, ejecuta el código asociado y deja de evaluar los demás casos.
      
      case ("en-Rojo", "Verde") =>
        ("en-Rojo", "cambiar-a-Verde")

      case ("en-Verde", "Amarillo") =>
        ("en-Verde", "cambiar-a-Amarillo")

      case ("en-Amarillo", "Rojo") =>
        ("en-Amarillo", "cambiar-a-Rojo")

      case _ =>
        (colorActual, "accion-por-defecto")
    }
  } 

// ========================================================
// FUNCIÓN: timer
// NATURALEZA: Pura
// ESTRATEGIA DE CONTROL: Selección múltiple mediante IF/ELSE
// IMPACTO EN MEMORIA: No destructiva
// PROPÓSITO:
// Determinar el color del semáforo en función del tiempo
// transcurrido dentro del ciclo.
// Devuelve "Rojo", "Verde" o "Amarillo" según corresponda.
// ========================================================
  def timer(tiempo: Int): String = { //define a tiempo como un entero
    if (tiempo < 0) //verifica que no sea un valor negativo (trabajamos con enteros positivos)
      "Error"

    else {
    //Se crea una variable inmutable llamada ciclo mediante la palabra reservada val. 
    //A esta variable se le asigna el resto de la división entre tiempo y 216, utilizando el operador módulo %.
      val ciclo = tiempo % 216 //
     // Las estructuras if/else comparan el valor de ciclo con los límites de cada intervalo 
     //para determinar si el semáforo debe estar en rojo, verde o amarillo.
      if (ciclo < 90) "en-Rojo"
      else if (ciclo < 210) "en-Verde"
      else "en-Amarillo"
    }
  }
}

// ========================================================
// EJEMPLOS DE USO DE LA FUNCIÓN TRANSICION
// ========================================================

// Cambio normal de rojo a verde:
// transicion("en-Rojo", "Verde")
// Resultado esperado: ("en-Rojo", "cambiar-a-Verde")

// Cambio normal de verde a amarillo:
// transicion("en-Verde", "Amarillo")
// Resultado esperado: ("en-Verde", "cambiar-a-Amarillo")

// Cambio normal de amarillo a rojo:
// transicion("en-Amarillo", "Rojo")
// Resultado esperado: ("en-Amarillo", "cambiar-a-Rojo")

// Cambio no permitido:
// transicion("en-Rojo", "Amarillo")
// Resultado esperado: ("en-Rojo", "accion-por-defecto")

// Estado no reconocido:
// transicion("Celeste", "Rojo")
// Resultado esperado: ("Celeste", "accion-por-defecto")

// ========================================================
// EJEMPLOS DE USO DE TIMER
// ========================================================

// Tiempo dentro del intervalo rojo:
// timer(35)
// Resultado esperado: "en-Rojo"

// Último valor del intervalo rojo:
// timer(89)
// Resultado esperado: "en-Rojo"

// Primer valor del intervalo verde:
// timer(90)
// Resultado esperado: "en-Verde"

// Tiempo dentro del intervalo verde:
// timer(145)
// Resultado esperado: "en-Verde"

// Último valor del intervalo verde:
// timer(209)
// Resultado esperado: "en-Verde"

// Primer valor del intervalo amarillo:
// timer(210)
// Resultado esperado: "en-Amarillo"

// Tiempo dentro del intervalo amarillo:
// timer(213)
// Resultado esperado: "en-Amarillo"

// Inicio de un nuevo ciclo:
// timer(216)
// Resultado esperado: "en-Rojo"

// Tiempo mayor a un ciclo completo:
// timer(220)
// Resultado esperado: "en-Rojo"

// Varios ciclos después:
// timer(543)
// Resultado esperado: "en-Verde"   // porque 543 % 216 = 111

// Ejemplo que genera error controlado:
// timer(-1)
// Resultado esperado: "Error"