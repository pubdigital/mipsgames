# Proyecto: 1942 en Assembler MIPS

## 📌 Descripción del Proyecto
Este proyecto consiste en la recreación del clásico videojuego retro **1942** utilizando **lenguaje ensamblador MIPS**.  
El desarrollo se realiza sobre una máquina virtual con **QEMU**, utilizando la imagen de Debian y el kernel provistos para la arquitectura **MIPS Malta**.  

El objetivo es implementar progresivamente las mecánicas principales del juego (movimiento del avión, enemigos, disparos, colisiones, puntajes, efectos de sonido y animaciones) siguiendo un esquema de versiones que permitan avanzar desde un prototipo básico hasta una versión final jugable.

## 🖥️ Entorno de Desarrollo
El entorno se basa en los siguientes archivos descargados desde el repositorio de imágenes de Aurel32:

- **Sistema operativo (QCOW2):** `debian_wheezy_mips_standard.qcow2`
- **Kernel MIPS:** `vmlinux-3.2.0-4-4kc-malta`

Se ejecuta con **QEMU** emulando la arquitectura MIPS Malta.  
Dentro de esta máquina virtual se programará y probará el juego en Assembler MIPS.

## 👥 Miembros del Grupo y Responsabilidades

- **Integrante 1 – Coordinador y Líder de Proyecto**  
  - Organización del trabajo.  
  - Integración de los módulos y pruebas globales.  
  - Documentación (README y manuales de uso).

- **Integrante 2 – Programador Gráfico (Sprites y Animaciones)**  
  - Diseño e implementación de los sprites del avión, enemigos y explosiones.  
  - Desarrollo de animaciones (roll del avión, movimiento de enemigos, efectos visuales).  

- **Integrante 3 – Programador de Lógica de Juego**  
  - Movimiento del jugador en pantalla.  
  - Sistema de disparos (jugador y enemigos).  
  - Implementación de colisiones y detección de impactos.

- **Integrante 4 – Programador de Sonido y Eventos**  
  - Implementación de música de fondo y efectos de sonido.  
  - Manejo de eventos especiales (game over, power-ups, pantalla de inicio/fin).

- **Integrante 5 – Tester y Optimizador**  
  - Pruebas unitarias y globales en cada versión.  
  - Optimización del código en ensamblador para mejorar el rendimiento.  
  - Reporte de errores y mejoras.

## 🕹️ Versiones del Proyecto y Objetivos

### Versión 1.0 – Prototipo básico (Pre-Alpha)
- Mostrar el avión del jugador en pantalla.
- Permitir mover el avión en 4 direcciones.

### Versión 2.0 – Enemigos y Puntuación (Alpha)
- Incorporar sprites de enemigos básicos.
- Disparo simple del jugador hacia arriba.
- Movimiento de enemigos en línea recta.
- Detección de colisiones jugador - enemigo.
- Sistema de puntaje (cada enemigo destruido suma puntos).

### Versión 3.0 – Mejoras en la jugabilidad (Beta)
- Incorporar diferentes patrones de movimiento de enemigos.
- Implementar disparos de enemigos.
- Sistema de vidas para el jugador.
- Efectos de explosión básicos.

### Versión 4.0 – Audio y animaciones (Release Candidate)
- Agregar música de fondo.
- Efectos de sonido (disparo, explosión, game over).
- Animación fluida de sprites tanto para el jugador (posibilidad de hacer el roll) y enemigos, así como también explosiones.

### Versión 5.0 – Versión final
- Power-ups (vidas extra, disparos múltiples).
- Pantalla de inicio y menú.
- Pantalla de fin de juego con puntaje final.

