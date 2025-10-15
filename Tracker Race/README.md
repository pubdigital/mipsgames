# 🏎️ TRACKER RACE

**Tracker Race** es un juego **retro en 2D** donde controlás un **auto visto desde arriba** que debe esquivar obstáculos que aparecen constantemente en la pista.

---

## 🎮 Descripción del juego

El jugador controla un auto que puede moverse entre **tres carriles** usando las teclas:

- **A** → Mover a la izquierda  
- **D** → Mover a la derecha
- **W** → Acelerar (el auto no avanza, pero se mueve todo más rápido)
- **S** → Frenar (el auto no retrocede, pero se mueve todo más lento)

Cada obstáculo esquivado **suma 1 punto** al *score* (mostrado en la esquina superior izquierda).  
El jugador dispone de **3 vidas**, visibles en la esquina inferior derecha.  
Cada colisión resta una vida 🔴 → ⚪.  
Cuando las 3 vidas se agotan, **el juego finaliza**.

---

## 🧠 Desarrollo

El juego fue programado **en lenguaje Assembly MIPS**, utilizando el entorno **MARS (MIPS Assembler and Runtime Simulator)**.  
Se emplearon las herramientas integradas:

- 🖼️ **Bitmap Display**
- ⌨️ **Keyboard and Display MMIO Simulator**

---

## ⚙️ Configuración antes de ejecutar

### 1️⃣ Configurar el Bitmap Display

En **MARS**, abrí:  
**Tools → Bitmap Display** y configurá los valores:

| Parámetro | Valor |
|------------|--------|
| Unit Width in Pixels | `4` |
| Unit Height in Pixels | `4` |
| Display Width in Pixels | `256` |
| Display Height in Pixels | `512` |
| Base address for display | `0x10008000 ($gp)` |

👉 Luego, presioná **"Connect to MIPS"**.

---

### 2️⃣ Configurar el Keyboard and Display MMIO Simulator

En **MARS**:  
**Tools → Keyboard and Display MMIO Simulator → Connect to MIPS**

---

### 3️⃣ Ejecutar el juego

Una vez configurado todo:
1. Compilá el código (`Assemble`).
2. Corré el programa (`Run`).
3. ¡Disfrutá la carrera! 🏁

---

## 📸 En pantalla verás...

- 🚗 Tu auto (controlado por el jugador).  
- 🛣️ Una pista móvil con tres carriles.  
- 🚧 Obstáculos descendiendo.  
- ❤️ Indicador de vidas.  
- 🔢 Contador de puntaje (*score*).

---

## 👥 Integrantes del grupo

- **Nicolás Diaz**  
- **Agustín Franchini**  
- **Tomás Lujan**  
- **Tiziana Gambino**  
- **Mateo Giovannetti**

---
