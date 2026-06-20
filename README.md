# TPI Funcional 2026 - Grupo 13

# Smart Traffic Light System

Functional Programming Integrative Project developed in Common Lisp, with `local-time` integration and a comparative implementation in Scala.




<p align="center">

![Common Lisp](https://img.shields.io/badge/Common%20Lisp-2D2D2D?style=for-the-badge&logo=commonlisp&logoColor=white)
![Scala](https://img.shields.io/badge/Scala-DC322F?style=for-the-badge&logo=scala&logoColor=white)
![Quicklisp](https://img.shields.io/badge/Quicklisp-6C63FF?style=for-the-badge)
![local-time](https://img.shields.io/badge/local--time-00897B?style=for-the-badge)
![Academic Project](https://img.shields.io/badge/Academic%20Project-2026-1565C0?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Completado-43A047?style=for-the-badge)

</p>




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

```mermaid
flowchart LR
    A[🔴 Rojo<br>90 segundos] --> B[🟢 Verde<br>120 segundos]
    B --> C[🟡 Amarillo<br>6 segundos]
    C --> D[Ciclo completo<br>216 segundos]
    D --> A
````

---



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

[Ver video en YouTube](https://www.youtube.com/watch?v=kLVycXynRVk&t=2s)

## Estado del proyecto

Proyecto desarrollado para la entrega del Trabajo Práctico Integrador 2026.
