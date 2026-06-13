# TPI Funcional 2026 - Grupo 13

## Sistema de Semáforos Inteligentes

Trabajo Práctico Integrador desarrollado para la materia **Paradigmas y Lenguajes**.

El proyecto implementa el núcleo lógico de un sistema de semáforos inteligentes utilizando **Common Lisp** y aplicando principios del paradigma funcional, como funciones puras, inmutabilidad, composición funcional y estructuras no destructivas.

## Integrantes

* Natalia Magali Lezcano - GitHub: `lezcanomagali32-commits`
* Abraham Fernández - GitHub: `abrahamfernan-pixel`
* Verónica Stefanía Gómez Varela - GitHub: `VeroSGV`
* Valentín Nicolás Luque - GitHub: `Valenluq10`
* Camila Paloma Hornos - GitHub: `CamilaHornoss`

## Funcionalidades

El sistema incluye los siguientes requerimientos:

1. Transición entre estados del semáforo.
2. Temporización automática de los colores.
3. Registro de auditoría de los cambios de estado.
4. Cálculo y recomendación de la duración del ciclo.
5. Cálculo de ciclos completos en un período determinado.
6. Informe de distribución temporal de los colores.

El ciclo semafórico implementado es:

`rojo → verde → amarillo`

El ciclo comienza en rojo y finaliza al terminar el estado amarillo.

## Fase 2: integración de una librería externa

Para la Fase 2 se utilizó la librería `local-time`, integrada mediante **Quicklisp**.

Esta librería permite convertir los timestamps Unix utilizados por el sistema de auditoría en fechas y horas legibles para el usuario.

Ejemplo de salida:

```text
[2026-06-10 14:30:00] La luz ha cambiado de EN-ROJO a EN-VERDE
```

La elección de `local-time` permitió mejorar la legibilidad del registro de auditoría sin modificar la lógica principal del semáforo.

## Fase 3: estudio comparativo

El lenguaje asignado al grupo fue:

`Scala`

En este lenguaje se reimplementaron las funciones:

* `transicion`
* `timer`

El código correspondiente se encuentra en:

```text
comparativa/solucion.scala
```

## Estructura del repositorio

```text
TPI-Funcional-2026-Grupo13/
├── lisp/
│   └── core.lisp
├── comparativa/
│   └── solucion.scala
├── docs/
│   ├── INFORME.pdf
│   └── HONOR.md
└── README.md
```

## Requisitos

Para ejecutar el proyecto se necesita:

* Una implementación de Common Lisp.
* Quicklisp.
* Librería `local-time`.
* Un entorno compatible con Scala para ejecutar la solución comparativa.

## Ejecución del programa en Common Lisp

Primero se debe iniciar el entorno de Common Lisp.

Luego se carga el archivo principal:

```lisp
(load "lisp/core.lisp")
```

El archivo principal carga la librería externa mediante:

```lisp
(ql:quickload :local-time)
```

## Ejemplos de uso

### Transición de estado

```lisp
(transicion 'en-rojo 'verde)
```

Resultado esperado:

```lisp
(EN-ROJO "cambiar-a-verde")
```

### Temporizador

```lisp
(timer 90)
```

Resultado esperado:

```lisp
EN-VERDE
```

### Duración del ciclo

```lisp
(duracion-ciclo)
```

Resultado esperado:

```lisp
216
```

### Recomendación del ciclo

```lisp
(recomendacion-ciclo (duracion-ciclo))
```

Resultado esperado:

```lisp
REDUCIR-DURACION-DEL-CICLO
```

### Ciclos completos en quince minutos

```lisp
(ciclos-por-tiempo 15)
```

Resultado esperado:

```lisp
4
```

## Informe técnico

El informe técnico completo se encuentra en:

```text
docs/INFORME.pdf
```

El informe incluye:

* fundamentos del diseño funcional;
* clasificación de las funciones;
* integración de la librería `local-time`;
* bitácora de errores y depuración;
* análisis comparativo con Scala;
* respuestas teóricas;
* conclusión grupal;
* bibliografía.

## Declaración de autoría

La declaración individual de cada integrante se encuentra en:

```text
docs/HONOR.md
```

## Video de defensa

El video de demostración técnica se encuentra disponible en:

[Ver video en YouTube](PEGAR-ENLACE-AQUI)

## Estado del proyecto

Proyecto desarrollado para la entrega del Trabajo Práctico Integrador 2026.
