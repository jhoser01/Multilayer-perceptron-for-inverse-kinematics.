# Cinemática inversa de un manipulador de 3 GDL mediante una red neuronal

Proyecto académico de **Ingeniería Mecatrónica** que explora la aproximación de la cinemática inversa de un manipulador **plano de tres grados de libertad (3 GDL)** utilizando una red neuronal feedforward en MATLAB.

**Áreas:** robótica · cinemática directa/inversa · Denavit–Hartenberg · aprendizaje supervisado · MATLAB.

> **Alcance:** implementación experimental/académica. No se publican aquí valores numéricos de exactitud validados ni se afirma control de un robot físico.

## Qué problema aborda

En cinemática inversa, se busca un conjunto de variables articulares capaz de situar el efector final en una posición y orientación deseadas. Este proyecto genera pares de configuraciones articulares y posiciones cartesianas mediante cinemática directa, y los utiliza para entrenar una red que estime los ángulos del manipulador.

## Flujo de trabajo

~~~mermaid
flowchart LR
    A["Robot plano de 3 GDL<br/>Parámetros DH"] --> B["Cinemática directa<br/>Generación de datos"]
    B --> C["Restricción de espacio<br/>y normalización"]
    C --> D["Red feedforward<br/>MATLAB"]
    D --> E["Predicción articular"]
    E --> F["Cinemática directa<br/>Comparación de trayectorias"]
~~~

| Etapa | Archivos principales |
| --- | --- |
| Modelo cinemático | [denavit.m](denavit.m), [generarDatos.m](generarDatos.m) |
| Construcción de datos | [generacionDeDatos.m](generacionDeDatos.m), [restringirDatos.m](restringirDatos.m), [normalizar.m](normalizar.m) |
| Entrenamiento | [entrenarRedNeuronal.m](entrenarRedNeuronal.m) |
| Pruebas de trayectoria | [pruebaConTrayectorias.m](pruebaConTrayectorias.m), [CD3prueba.m](CD3prueba.m), [RECMN.m](RECMN.m) |
| Trayectoria desde CSV | [SITEM.m](SITEM.m), [SITEM_positions.csv](SITEM_positions.csv) |

## Modelo y entrenamiento

- En [generarDatos.m](generarDatos.m) se consideran tres eslabones de longitud **1** (unidades modeladas como metros) y variables articulares de entrada en intervalos configurables.
- La generación usa matrices homogéneas de **Denavit–Hartenberg** para obtener coordenadas X, Y y orientación.
- [entrenarRedNeuronal.m](entrenarRedNeuronal.m) configura una red feedforward con tres capas de tamaños **17, 15 y 3** y entrenamiento **Levenberg–Marquardt (trainlm)**, con una división configurada de datos **80 % / 10 % / 10 %**.
- El entrenamiento usa error cuadrático medio (**MSE**) y guarda red e información de entrenamiento en [RedNeuronal_Entrenada.mat](RedNeuronal_Entrenada.mat).

Estas cifras describen la **configuración del código**, no resultados finales de desempeño.

## Cómo explorarlo

**Requisito:** MATLAB con las funciones de redes neuronales empleadas por el proyecto.

1. Abrir MATLAB con la carpeta del repositorio como directorio de trabajo.
2. Revisar los rangos articulares y el área de trabajo definidos en **generacionDeDatos.m**.
3. Ejecutar **generacionDeDatos.m** para construir y normalizar las muestras.
4. Ejecutar **entrenarRedNeuronal.m** para ajustar una red y guardar el archivo MAT.
5. Revisar **pruebaConTrayectorias.m**, que compara trayectorias circulares y rectangulares, además de orientación.
6. Consultar [ordenDeCodigo.txt](ordenDeCodigo.txt) y el [documento explicativo original](EXPLICACION.pdf).

**Advertencia de reproducibilidad:** algunos scripts de prueba dependen de variables generadas en el espacio de trabajo de MATLAB por pasos previos; no se garantiza su ejecución aislada ni se han ejecutado aquí.

## Evaluación incluida en el código

El script de trayectorias prepara comparaciones de trayectoria deseada y obtenida, visualiza la orientación y calcula errores normalizados mediante la función **RECMN** para X, Y y orientación. No se han calculado ni verificado números de rendimiento durante esta revisión documental.

## Limitaciones y siguientes mejoras

- El manipulador está modelado en el plano XY; no se describe un robot tridimensional industrial.
- Las trayectorias y pruebas dependen de parámetros de normalización y variables del entorno MATLAB.
- Falta una guía de ejecución autónoma con comprobaciones reproducibles.
- Para mejorar este portafolio se necesitan **gráficas reales** de trayectorias y errores obtenidas al ejecutar los scripts.

---

**Autor:** Jhoser Simeon · Proyecto académico de ingeniería mecatrónica y robótica.
