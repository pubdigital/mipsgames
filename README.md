# Asteroids
## Descripción
Asteroids es un clásico videojuego de arcade lanzado originalmente por Atari en 1979, pero tuvo una gran popularidad también en los 90s gracias a las reediciones y al boom de los juegos retro. El objetivo principal del juego es controlar una nave espacial que debe destruir asteroides y naves enemigas en un campo de espacio en 2D. Aunque su lanzamiento inicial fue en los 70s, en los 90s llegó a diversas plataformas, incluyendo consolas y computadoras de esa época, lo que le permitió mantener su legado.


## Características
Mecánicas del Jugador: Desplazamiento de la nave alrededor del mapa con WASD. 

### Físicas y Colisiones
colisiones con asteroides y generacion de los mismos con un vector de movimiento.
Interfaz: Muestra vidas en la parte superior izquierda y al colisionar con un asteroide la mismas son reducidas.
Condiciones de Victoria/Derrota: Sobrevive el mayor tiempo posible y si se queda sin vidas aperece una "calavera" en la pantalla.


## Instalación y Ejecución
Instalar MARS 4.5: Descarga desde https://dpetersanderson.github.io/download.html.
Cargar Código: Abre asteroids.asm en MARS.

Configurar Pantalla:
Herramientas > Bitmap Display
Ancho/Alto de Unidad: 4 píxeles
Ancho/Alto de Pantalla: 256 píxeles
Dirección Base: 0x10008000 ($gp)

Conectar Entrada: Herramientas > Keyboard and Display MMIO Simulator > Conectar a MIPS.
Ejecutar: Ensambla y ejecuta. Usar WASD para desplazarse.


## Controles
W o w: Mover hacia arriba.
A o a: Mover a la izquierda.
D o d: Mover a la derecha.
S o s: Mover hacia abajo.

## Notas
Diseñado para fines académicos, demostrando programación en MIPS y gráficos en tiempo real. Si la pantalla parpadea, verifica la configuración de Bitmap Display y la conexión del MMIO Simulator.
