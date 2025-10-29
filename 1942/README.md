# Proyecto: 1942 en Assembler MIPS

## 📌 Descripción del Proyecto
Este proyecto consiste en la recreación del clásico videojuego retro **1942** utilizando **lenguaje ensamblador MIPS**.  
El desarrollo se realiza sobre **MARS 4.5 (MIPS Assembler and Runtime Simulator)**, un simulador educativo que permite ejecutar y depurar código MIPS de manera interactiva.

El objetivo es implementar progresivamente las mecánicas principales del juego (movimiento del avión, enemigos, disparos, colisiones, puntajes y animaciones) siguiendo un esquema de versiones que permitan avanzar desde un prototipo básico hasta una versión final jugable.

## 🖥️ Entorno de Desarrollo

### Software Requerido
- **MARS 4.5** (MIPS Assembler and Runtime Simulator)
- Herramientas integradas de MARS:
  - **Bitmap Display**: Para la visualización gráfica del juego
  - **Keyboard and Display MMIO Simulator**: Para el control del jugador mediante teclado

### Configuración del Bitmap Display
Para ejecutar el juego correctamente, configurar el **Bitmap Display** con los siguientes parámetros:

- **Unit Width in Pixels:** 8
- **Unit Height in Pixels:** 8
- **Display Width in Pixels:** 512
- **Display Height in Pixels:** 512
- **Base address for display:** `0x10008000 ($gp)`

Esta configuración crea una pantalla virtual de **64x64 píxeles** donde se renderiza el juego.

### Configuración del Keyboard MMIO Simulator
- Conectar el **Keyboard and Display MMIO Simulator** para capturar las entradas del jugador.
- **Controles del juego:**
  - **W/↑**: Mover hacia arriba
  - **S/↓**: Mover hacia abajo
  - **A/←**: Mover hacia la izquierda
  - **D/→**: Mover hacia la derecha
  - **J**: Disparar

## 👥 Miembros del Grupo y Responsabilidades

- **Julián Ferrari – Coordinador y Líder de Proyecto**  
  - Organización del trabajo y gestión de versiones.
  - Líder de Programación.
  - Documentación técnica (README, comentarios en código).

- **Francisco Yucovsky – Programador Gráfico (Sprites y Animaciones)**  
  - Diseño e implementación de sprites del avión, enemigos y efectos.
  - Desarrollo del sistema de renderización en Bitmap Display.
  - Implementación del portaaviones y Boss Final.

- **Julián Vaccari – Programador de Lógica de Juego**  
  - Sistema de movimiento del jugador.
  - Implementación de disparos (jugador y enemigos).
  - Desarrollo del sistema de colisiones y detección de impactos.
  - Sistema de vidas y puntuación.

- **María del Pilar Castro – Programador de Sonido y Eventos**  
  - Implementación de música de fondo y efectos de sonido.  
  - Manejo de eventos especiales (game over, power-ups, pantalla de inicio/fin).

- **Valentino Luchini – Tester y Optimizador**  
  - Pruebas exhaustivas en cada versión.
  - Optimización del código MIPS para mejorar el rendimiento.
  - Detección y corrección de bugs.
  - Balanceo de dificultad y jugabilidad.

## 🕹️ Versiones del Proyecto y Objetivos

### Versión 1.0 – Prototipo básico (Pre-Alpha)
- Mostrar el avión del jugador en pantalla.
- Permitir mover el avión en 4 direcciones (W/A/S/D).
- Implementación del mar de fondo.

### Versión 2.0 – Enemigos y Puntuación (Alpha)
- Sprites de enemigos básicos (avión gris).
- Sistema de disparo del jugador.
- Movimiento automático de enemigos hacia abajo.
- Detección de colisiones jugador-enemigo y bala-enemigo.
- Sistema de puntaje (50 puntos por enemigo destruido).
- Portaaviones inicial con scroll dinámico.

### Versión 3.0 – Mejoras en la jugabilidad (Beta)
- Tres tipos de enemigos con diferentes colores y valores:
  - Gris (50 puntos) - Aparece frecuentemente
  - Verde (100 puntos) - Aparece cada 5 enemigos
  - Amarillo (150 puntos) - Aparece cada 15 enemigos
- Sistema de disparos enemigos (balas en cruz).
- Movimiento horizontal de enemigos con rebote en bordes.
- Sistema de vidas (3 vidas iniciales).
- Efectos visuales mejorados.

### Versión 4.0 – Boss Final y Objetivo (Release Candidate)
- Boss Final que aparece a los 5 minutos:
  - Sprite grande (27x27 píxeles)
  - 15 puntos de vida
  - Dispara 3 balas simultáneas
  - Movimiento horizontal inteligente
  - 1000 puntos al derrotarlo
- Portaaviones final aparece tras derrotar al boss.
- Sistema de victoria al alcanzar el portaaviones.
- Mensajes de estado (kills, puntaje, victoria).

### Versión 5.0 – Versión Final
- Implementación de HUD.
- Mejoras en animaciones (explosiones, efectos).
- Sistema de power-ups.
- Optimizaciones finales de rendimiento.

## 📝 Instrucciones de Uso

1. **Abrir MARS 4.5**
2. **Cargar el archivo** `1942.asm`
3. **Configurar herramientas:**
   - Abrir `Tools > Bitmap Display` y configurar según especificaciones
   - Abrir `Tools > Keyboard and Display MMIO Simulator`
   - Conectar ambas herramientas al MIPS
4. **Ensamblar** el código (F3)
5. **Ejecutar** el programa (F5)
6. **Jugar** usando las teclas W/A/S/D para movimiento y J para disparar

## 🎯 Objetivo del Juego
Sobrevivir durante 5 minutos enfrentando oleadas de enemigos, derrotar al Boss Final y finalmente llegar al portaaviones para completar la misión.

## 📊 Sistema de Puntuación
- Enemigo Gris: 50 puntos
- Enemigo Verde: 100 puntos
- Enemigo Amarillo: 150 puntos
- Boss Final: 1000 puntos

## 🐛 Debugging y Testing
Para facilitar las pruebas, se pueden modificar las siguientes constantes en el código:
- `FINAL_SHIP_TRIGGER`: Cambiar de 6000 a un valor menor para probar el boss más rápido
- `BOSS_SHOOT_RATE`: Ajustar frecuencia de disparo del boss
- `ENEMY_SPAWN_RATE`: Modificar velocidad de aparición de enemigos

---
**Versión Actual:** 5.0 (Final)  
