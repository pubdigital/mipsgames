# Pac-Man en MIPS Assembly

Este es un proyecto de Pac-Man desarrollado en lenguaje ensamblador MIPS32. Recrea la jugabilidad con gráficos simples y lógica de juego funcional.

## Descripción del Juego

El juego se basa en el clásico Pac-Man donde controlas al personaje amarillo a través de un laberinto, comiendo puntos mientras escapas (o cazas) a cuatro fantasmas de colores. El objetivo es comer todos los puntos del mapa sin ser atrapado por los fantasmas.

### Características principales:
- **Pac-Man controlable** con las teclas WASD
- **4 fantasmas con IA básica** (rosa, verde, rojo y blanco)
- **Sistema de puntos** que rastrea tu progreso
- **Power-ups** (frutas rojas) que te permiten comer fantasmas temporalmente
- **Teletransporte** en los laterales del mapa
- **Detección de colisiones** entre Pac-Man y fantasmas
- **Condición de victoria** al comer todos los puntos

## Estructura de Archivos

```
Pacman/
│
├── main.asm                    # Archivo principal del juego
├── mapa.asm                    # Generación del laberinto
├── punto.asm                   # Colocación de puntos colectables
├── comer.asm                   # Lógica de colisiones
├── AnalisisMapa.asm            # Análisis del mapa (detección de paredes)
├── desicion_Ghost.asm          # IA de los fantasmas
├── control_puntos.asm          # Sistema de puntuación
│
└── Disenio/
    ├── draw.asm                # Funciones de dibujo de personajes
    ├── mov.asm                 # Funciones de movimiento
    └── pintar.asm              # Función básica de pintar píxeles
```

## Arquitectura

### `main.asm`
Este es el archivo principal que arranca todo. En este tenemos:
1. **Inicializa las posiciones** de Pac-Man y los 4 fantasmas
2. **Dibujo**: Se traza el mapa y los diferentes puntos
3. **Loop principal**: bucle que hace que el juego funcione constantemente
4. **Gestiona el flujo del juego**: lee el teclado, mueve personajes, detecta colisiones

**Variables importantes:**
- `Posicao`: Vector de 80 bytes que guarda las posiciones (x,y) de todos los personajes
- `pontos`: Contador de puntos recolectados
- `Colores definidos` (white, black, yellow, red, pink, green, blue, blue_ghost)

### `mapa.asm`
Dibuja píxel por píxel todo el laberinto azul. Es un archivo largo porque literalmente está pintando cada posición de las paredes del mapa. Usa la macro `set_mapa()` que imprime los píxeles azules en sus coordenadas específicas.

### `punto.asm` - 
Coloca de manera espaciada todos los puntos amarillos (y las frutas) que el Pac-Man debe comer. Las frutas rojas son los power-ups que activan el modo "caza fantasmas".

### `comer.asm`
Tiene dos macros importantes:
- **`comer`**: Verifica si Pac-Man y algún fantasma están en la misma posición. Si hay power-up activo, el fantasma es "comido" y reaparece en su posición inicial. De otro modo, pierde el jugagor
- **`reaparecer`**: Controla el tiempo de reaparición de fantasmas después de ser comidos (15 ciclos de espera)

### `AnalisisMapa.asm` 
Este archivo es importante para que los personajes no atraviesen paredes. Contiene varias macros:

- **`block`**: Verifica si el próximo movimiento choca con una pared. Si detecta un muro azul, impide el movimiento
- **`next_Block`**: Analiza el píxel en la dirección del movimiento y devuelve 1 si es pared (azul) o 0 si está libre
- **`bifurcacion`**: Detecta si estamos en una intersección (3 o más caminos disponibles) - importante para la IA de fantasmas
- **`victoria`**: Verifica si recolectamos los 218 puntos para ganar

**¿Cómo funciona?** Antes de mover un personaje, el juego "mira" el color del píxel en la dirección deseada. Si es azul (código de color 255 en algunos bits), es una pared y bloquea el movimiento.

### `desicion_Ghost.asm` - La inteligencia de los fantasmas
Aca está la lógica de la IA de los fantasmas. Tienen dos modos:

**Modo Persecución:**
- 50% de probabilidad de moverse en X o en Y
- 80% de probabilidad de seguir a Pac-Man
- 20% de probabilidad de ir en dirección contraria
- Solo toman decisiones en intersecciones

**Modo Huida (cuando hay power-up):**
- Misma estructura pero invierte las direcciones
- Intentan alejarse de Pac-Man

**`esquina`**: Cuando un fantasma llega a una esquina (no bifurcación), calcula automáticamente la única dirección válida para girar.

### `control_puntos.asm`
Maneja un mapa paralelo de puntos para saber qué se ha comido. Similar a `pintar.asm` pero para un array de puntos en lugar del display gráfico.

### Carpeta `Disenio/` - Los gráficos

#### `pintar.asm`
La función más básica: `draw_P`. Pinta un solo píxel en la pantalla.
- Toma coordenadas (s1, s2) y un color (s0)
- Calcula la dirección de memoria en el heap: `0x10040000 + (x*4) + (y*256)`
- Escribe el color en esa posición

#### `draw.asm`
Funciones de nivel superior para dibujar personajes completos:

- **`draw_Pac_Man`**: Dibuja Pac-Man con 6 píxeles amarillos formando un círculo con "boca" en la dirección de movimiento
- **`draw_Ghost`**: Dibuja un fantasma con 8 píxeles del color correspondiente
- **`draw_quadrado`**: Dibuja un cuadrado negro (para "borrar" a Pac-Man)
- **`apagar`**: Borra todos los personajes de la pantalla (usado en Game Over/Victoria)

#### `mov.asm`
Contiene las macros de movimiento:

- **`mov_Ghost`**: Borra el fantasma de su posición anterior, actualiza coordenadas según el comando (w/a/s/d), y lo dibuja en la nueva posición. Incluye lógica de teletransporte.
- **`mov_Pac_Man`**: Similar al movimiento de fantasmas pero también:
  - Verifica si hay un punto amarillo en la nueva posición y lo cuenta
  - Detecta si come una fruta roja (power-up)
  - Incluye teletransporte en los bordes

## Cómo Ejecutar el Juego

### Configuración del MARS

Se debe configurar la herramienta `Bitmap Display` de la siguiente manera:

   - **Unit Width in Pixels**: 8
   - **Unit Height in Pixels**: 8
   - **Display Width in Pixels**: 512
   - **Display Height in Pixels**: 1024
   - **Base address for display**: `0x10040000` (heap)

Ademas se debe habilitar la tool de `Keyboard and Display MMIO Simulator` de la misma manera

### Controles
- **W**: Arriba
- **A**: Izquierda
- **S**: Abajo
- **D**: Derecha
- **P**: Pausa

## Lógica del Juego

### Loop Principal

El juego funciona con un loop infinito que ejecuta constantemente:

```
1. Pac_Man:
   - Lee comando del teclado
   - Verifica si hay pared en esa dirección
   - Si es válido, mueve Pac-Man
   - Actualiza contador si comió un punto
   - Verifica si comió power-up
   - Verifica condición de victoria

2. Fantasma (los 4 fantasmas):
   - Verifica si está en tiempo de reaparición
   - Decide movimiento (perseguir o huir)
   - Mueve el fantasma
   - Verifica colisión con Pac-Man

5. Espera 75ms (syscall 32)
6. Vuelve al paso 1
```

### Sistema de Coordenadas

El mapa usa un sistema de coordenadas donde:
- **X**: 0-62 (63 unidades de ancho)
- **Y**: 0-80 (81 unidades de alto)
- Cada unidad representa un "bloque" de 8x8 píxeles

**Posiciones iniciales:**
- Pac-Man: (31, 61) - centro inferior
- Fantasma Rosa: (4, 4) - esquina superior izquierda
- Fantasma Verde: (58, 4) - esquina superior derecha
- Fantasma Rojo: (4, 76) - esquina inferior izquierda
- Fantasma Blanco: (58, 76) - esquina inferior derecha

### Power-Ups (Frutas Rojas)

Cuando Pac-Man come una fruta roja:
1. Se activa un contador de 45 ciclos
2. Los fantasmas cambian a color celeste
3. Los fantasmas entran en modo "huida"
4. Si Pac-Man toca un fantasma, éste es "comido" y reaparece en su esquina inicial
5. Después de 45 ciclos, todo vuelve a la normalidad

### Registros Importantes

- **$s0**: Almacena el color actual a dibujar
- **$s1**: Coordenada X
- **$s2**: Coordenada Y
- **$s3**: Comando de movimiento (119=w, 97=a, 115=s, 100=d)
- **$s4**: Valor de retorno para verificaciones (0 o 1)
- **$s5**: Estado de reaparición de fantasma
- **$s6**: Identificador del fantasma actual
- **$s7**: Puntero al vector de posiciones
- **$t8**: Estado del power-up (0=normal, 1=activo)

### Detección de Colisiones

Se detecta colisiones de la siguietne manera:
```assembly
# Compara posición X de Pac-Man con posición X del Fantasma 1
bne $t1, $s1, VF2    # Si no son iguales, verifica el siguiente fantasma
beq $t2, $s2, F1     # Si Y también es igual, hay colisión!
```

Si las coordenadas X e Y coinciden, hay colisión.

## Limitaciones y Consideraciones

### Velocidad del Juego
- El delay está fijado en 75ms por ciclo (syscall 32 con $a0=75)

### Memoria
- El juego usa la memoria del heap de MARS (0x10040000)
- Si MARS tiene algún error de memoria, se debe aumentar el tamaño del heap en: `Settings` → `Memory Configuration`

### Colores en Assembly
Los colores se almacenan como números hexadecimales de 32 bits (formato RGB):
- `0xFFFFFF` = Blanco
- `0x000000` = Negro
- `0xFFFF00` = Amarillo
- `0xFF0000` = Rojo
- `0xFF1493` = Rosa
- `0x00FF00` = Verde
- `0x0000FF` = Azul
- `0x80CEE1` = Celeste (fantasmas asustados)
