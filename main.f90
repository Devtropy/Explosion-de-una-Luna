PROGRAM MAIN
   USE UNIDADES_NATURALES
   USE GRAVITACION
   IMPLICIT NONE

   ! Parámetros de simulación
   REAL(kind) :: MASA_PLANETA
   REAL(kind), PARAMETER :: RADIO_INICIAL = 0.1_kind
   REAL(kind), PARAMETER :: DISTANCIA_INICIAL = 1.5_kind
   REAL(kind), PARAMETER :: TIEMPO_SIMULACION = 500.0_kind
   INTEGER, PARAMETER :: PASOS = 10000
   INTEGER, PARAMETER :: NUM_FRAGMENTOS = 200

   ! outputs
   REAL(kind) :: posiciones(PASOS, NUM_FRAGMENTOS, 3)
   REAL(kind) :: densidad_global(PASOS, 2)
   REAL(KIND), ALLOCATABLE::radios_anillos(:, :)

   ALLOCATE (RADIOS_ANILLOS(PASOS, 2))

   ! Naturalizamos la masa
   MASA_PLANETA = ms/m0

   ! Ejecutar simulación
   CALL SIMULACION(MASA_PLANETA, TIEMPO_SIMULACION, PASOS, RADIO_INICIAL, DISTANCIA_INICIAL, &
                   posiciones, densidad_global, radios_anillos)

   ! Guardar resultados
   CALL OUTPUT(posiciones)
   CALL OUTPUT_GRAFICOS(radios_anillos, densidad_global)

   PRINT *, "Simulacion completada exitosamente."
   PRINT *, "Resultados guardados en:"
   PRINT *, "- ANILLO_SATURNIANO"
   PRINT *, "- LUNA_EXPLOTADA"
   PRINT *, "- RADIO_VS_TIEMPO"
   PRINT *, "- DENSIDAD_VS_TIEMPO"

END PROGRAM MAIN
