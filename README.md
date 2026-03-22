#  Simulación de la Desintegración de una Luna y Formación de Anillos

##  Descripción
Este proyecto implementa un **algoritmo numérico de N-cuerpos** en Fortran para modelar la fragmentación de una luna y la posterior evolución dinámica de sus fragmentos bajo la influencia gravitatoria de un planeta masivo.

El objetivo principal es estudiar:
* **Dispersión de masa**: Evolución tras un evento catastrófico inicial.
* **Formación de estructuras**: Surgimiento de anillos y evolución de su densidad espacial.
* **Clasificación orbital**: Categorización de fragmentos según su destino final: en órbita, estrellados contra el planeta o escapados del sistema.

##  Modelo Físico
La simulación se fundamenta en la mecánica celeste y el tratamiento de partículas independientes:

* **Interacción Gravitatoria**: Se calcula la aceleración Newtoniana para cada fragmento respecto al centro del planeta.
  $$a = -\frac{G \cdot M_{planeta} \cdot r}{||r||^3}$$
* **Física de Colisiones**: Implementa un modelo de choque elástico que detecta la proximidad entre fragmentos ($< 10^{-6}$) y resuelve el intercambio de momentum.
* **Unidades Naturales**: Utiliza constantes físicas normalizadas para optimizar la precisión y evitar errores de escala numérica.



##  Metodología
1. **Inicialización**: Se genera una esfera de fragmentos con una distribución aleatoria de posiciones y velocidades perturbadas basadas en la velocidad orbital.
2. **Integración Temporal**: Se emplea un método de paso de tiempo constante ($\Delta t$) para actualizar las variables de estado:
    * **Velocidad**: $v_{k+1} = v_k + a \cdot \Delta t$
    * **Posición**: $r_{k+1} = r_k + v_{k+1} \cdot \Delta t$
3. **Análisis de Datos**:
    * Cálculo del **Radio Medio** de la nube de escombros.
    * Cálculo de la **Densidad Global** mediante el ordenamiento de posiciones con el algoritmo **Quicksort**.

##  Implementación
**Lenguaje:** Fortran 90/95 utilizando alta precisión (`SELECTED_REAL_KIND(15, 1000)`).

### Estructura del Código:
* `UNIDADES_NATURALES`: Gestión de constantes como $G$, $\pi$ y masas patrón.
* `OPERACIONES_VECTORIALES`: Funciones de álgebra lineal y el algoritmo de ordenamiento recursivo Quicksort.
* `CONDICIONES_INICIALES`: Subrutinas para la generación estocástica de la luna.
* `RADIO_Y_DENSIDAD`: Procesamiento estadístico de la nube de fragmentos.
* `COLISIONES`: Lógica de detección de choques y separación de partículas.
* `GRAVITACION`: Núcleo de la simulación y exportación de resultados.

##  Resultados
El programa genera archivos `.dat` (texto plano) para su posterior análisis o visualización:
* `ANILLO_SATURNIANO`: Coordenadas finales de los fragmentos.
* `LUNA_EXPLOTADA`: Estado inicial del sistema.
* `RADIO_VS_TIEMPO`: Evolución del radio medio vs. tiempo.
* `DENSIDAD_VS_TIEMPO`: Evolución de la densidad global.

##  Autor
Proyecto desarrollado por Hector Acosta, Marisol Miranda y Aldo Espinoza. 
