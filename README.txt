# Simulación de la Desintegración de una Luna y Formación de Anillos

## Descripción
[cite_start]Este proyecto implementa un **algoritmo numérico de N-cuerpos** en Fortran para modelar la fragmentación de una luna y la posterior evolución dinámica de sus fragmentos bajo la influencia gravitatoria de un planeta masivo[cite: 1, 43, 149].

El objetivo principal es estudiar:
* [cite_start]La dispersión de masa tras un evento catastrófico inicial[cite: 151].
* [cite_start]La formación de estructuras anulares y la evolución de su densidad[cite: 125, 172].
* [cite_start]La clasificación de fragmentos según su destino final: en órbita, estrellados contra el planeta o escapados del sistema[cite: 161, 220].

## ⚙️ Modelo Físico
La simulación se fundamenta en la mecánica celeste y el tratamiento de partículas independientes:

* [cite_start]**Interacción Gravitatoria**: Se calcula la aceleración Newtoniana para cada fragmento respecto al centro del planeta[cite: 157, 217].
    $$a = -\frac{G \cdot M_{planeta} \cdot r}{||r||^3}$$
* [cite_start]**Física de Colisiones**: Implementa un modelo de choque elástico que detecta la proximidad entre fragmentos ($< 10^{-6}$) y resuelve el intercambio de momentum[cite: 138, 148, 211].
* [cite_start]**Unidades Naturales**: Utiliza constantes físicas normalizadas para optimizar la precisión y evitar errores de escala numérica[cite: 32, 185].



##  Metodología
1.  [cite_start]**Inicialización**: Se genera una esfera de fragmentos con una distribución aleatoria de posiciones y velocidades perturbadas basadas en la velocidad orbital[cite: 90, 100, 201].
2.  [cite_start]**Integración Temporal**: Se emplea un método de paso de tiempo constante ($\Delta t$) para actualizar las variables de estado[cite: 152, 215]:
    * [cite_start]**Velocidad**: $v_{k+1} = v_k + a \cdot \Delta t$[cite: 158, 218].
    * [cite_start]**Posición**: $r_{k+1} = r_k + v_{k+1} \cdot \Delta t$[cite: 159, 218].
3.  **Análisis de Datos**:
    * [cite_start]Cálculo del **Radio Medio** de la nube de escombros[cite: 114, 205].
    * [cite_start]Cálculo de la **Densidad Global** mediante el ordenamiento de posiciones con el algoritmo **Quicksort**[cite: 125, 209].

##  Implementación
[cite_start]**Lenguaje:** Fortran 90/95[cite: 35, 186].

### Estructura del Código:
* [cite_start]`UNIDADES_NATURALES`: Gestión de constantes como $G$, $\pi$ y masas patrón[cite: 32, 185].
* [cite_start]`OPERACIONES_VECTORIALES`: Funciones de álgebra lineal y el algoritmo de ordenamiento recursivo Quicksort[cite: 43, 84, 194].
* [cite_start]`CONDICIONES_INICIALES`: Subrutinas para la generación estocástica de la luna[cite: 89, 200].
* [cite_start]`RADIO_Y_DENSIDAD`: Procesamiento estadístico de la nube de fragmentos[cite: 113, 205].
* [cite_start]`COLISIONES`: Lógica de detección de choques y separación de partículas[cite: 137, 210].
* [cite_start]`GRAVITACION`: Núcleo de la simulación y exportación de resultados[cite: 149, 213].

##  Resultados
El programa genera archivos `.dat` (o texto plano) para visualización:
* [cite_start]`ANILLO_SATURNIANO`: Coordenadas finales de los fragmentos[cite: 168, 224].
* [cite_start]`LUNA_EXPLOTADA`: Estado inicial del sistema[cite: 170, 224].
* [cite_start]`RADIO_VS_TIEMPO`: Evolución del radio medio vs. tiempo[cite: 173, 225].
* [cite_start]`DENSIDAD_VS_TIEMPO`: Evolución de la densidad global[cite: 175, 226].

##  Cómo ejecutar
1.  **Compilar los módulos**:
    ```bash
    gfortran -c module.f90
    ```
2.  **Compilar el programa principal**:
    ```bash
    gfortran main.f90 module.o -o simulacion
    ```
3.  **Ejecutar**:
    ```bash
    ./simulacion
    ```

##  Autor
Proyecto desarrollado por Hector Acosta, Marisol Miranda y Aldo Espinoza. 


