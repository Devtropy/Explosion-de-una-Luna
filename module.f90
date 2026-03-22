MODULE UNIDADES_NATURALES
   IMPLICIT NONE
   SAVE

   ! KIND para mayor precisión
   INTEGER, PARAMETER::kind = SELECTED_REAL_KIND(15, 1000)

   ! Constantes físicas
   REAL(kind), PARAMETER::G = 1.0_kind        ! Constante gravitacional
   REAL(kind), PARAMETER::t0 = 31.53e6_kind         ! 1 año en segundos
   REAL(kind), PARAMETER::UA = 1.5e11_kind          ! 1 unidad astronómica en metros
   REAL(kind), PARAMETER::m0 = 4.98e28_kind         ! masa patrón
   REAL(kind), PARAMETER::ms = 5.86e26_kind         ! masa de Saturno
   REAL(kind), PARAMETER::pi = 355.0_kind/113.0_kind
END MODULE UNIDADES_NATURALES

MODULE OPERACIONES_VECTORIALES
   USE UNIDADES_NATURALES
   IMPLICIT NONE

CONTAINS

   FUNCTION PRODUCTO_CRUZ(A, B) RESULT(C)
      REAL(kind), INTENT(IN)::A(3), B(3)
      REAL(kind)::C(3)

      C(1) = A(2)*B(3) - A(3)*B(2)
      C(2) = A(3)*B(1) - A(1)*B(3)
      C(3) = A(1)*B(2) - A(2)*B(1)
   END FUNCTION PRODUCTO_CRUZ

   FUNCTION MAGNITUD(X)
      REAL(kind), INTENT(IN)::X(3)
      REAL(kind)::MAGNITUD
      MAGNITUD = SQRT(DOT_PRODUCT(X, X))
   END FUNCTION MAGNITUD

   function Media(n, x)

      IMPLICIT NONE
      INTEGER, INTENT(IN)::n
      REAL(kind), INTENT(IN)::X(n)
      REAL(kind)::media, suma
      integer::i

      suma = 0.0

      do i = 1, n
         suma = suma + x(i)
      end do

      media = suma/N

   end function media

   RECURSIVE SUBROUTINE QUICKSORT(x, p, q, n)
      IMPLICIT NONE
      INTEGER, INTENT(IN)::p, q, n
      REAL(kind), INTENT(INOUT)::X(n)
      INTEGER::r
      IF (p < q) then
         !ordenamos el arreglo
         CALL PARTICION2(x, p, q, r, n)
         !ordenamos a la izquierda del pivote
         !Nota:si estas usando la particion de hoare, la particion
         !de la izquierda termina en el pivote , no uno antes,osea,
         !CALL QUICKSORT(x,p,r,n)
         CALL QUICKSORT(x, p, r - 1, n)
         !ordenamos a la derecha del pivote
         CALL QUICKSORT(x, r + 1, q, n)
      END IF
   END SUBROUTINE QUICKSORT

   SUBROUTINE INTERCAMBIO(x, y)
      IMPLICIT NONE
      REAL(kind), INTENT(INOUT)::x, y
      REAL(kind)::auxiliar

      auxiliar = y
      y = X
      x = auxiliar
   END SUBROUTINE INTERCAMBIO
!ESQUEMA DE PARTICION DUPRET(HORAE++)
   SUBROUTINE PARTICION2(x, p, q, r, n)
      IMPLICIT NONE
      INTEGER, INTENT(IN)::p, q, n
      REAL(kind), INTENT(INOUT)::X(n)
      INTEGER, INTENT(INOUT)::r
      INTEGER::i, j
      !asignacion del pivote
      r = (p + q)/2
      !Mandamos al final el pivote
      CALL INTERCAMBIO(X(r), x(q))
      !inicilizamos los buscadores
      i = p - 1
      j = q

      DO
         !Buscamos un elemento mayor al pivote
         DO
            i = i + 1
            if (x(i) >= x(q)) exit

         END DO
         !Buscamos un elemento menor al pivote
         DO
            j = j - 1
            if (x(j) <= x(q)) exit
         END DO
         !SI SE CRUZAN ENCONTRAMOS DONDE VA EL NUEVO PIVOTE

         IF (i >= j) exit
         !INTERCAMBIAMOS ELEMENTOS
         call INTERCAMBIO(x(j), x(i))
      END DO
      !NUEVO PIVOTE
      r = i
      !COLOCAMOS EL PIVOTE DONDE VA
      CALL INTERCAMBIO(x(r), x(q))
   END SUBROUTINE PARTICION2

END MODULE OPERACIONES_VECTORIALES

MODULE CONDICIONES_INICIALES
   USE UNIDADES_NATURALES
   USE OPERACIONES_VECTORIALES
   IMPLICIT NONE

CONTAINS

   SUBROUTINE POSICION_INICIAL_FRAGMENTOS(F, r, l)
      REAL(kind), INTENT(OUT)::F(:, :)
      REAL(kind), INTENT(IN)::r, l
      REAL(kind)::z, phi
      INTEGER::i, n

      n = SIZE(F, 1)

      CALL RANDOM_SEED()

      DO i = 1, n
         CALL RANDOM_NUMBER(z)
         z = (2.0_kind*z - 1.0_kind)*r

         CALL RANDOM_NUMBER(phi)
         phi = 2.0_kind*pi*phi

         F(i, 1) = SQRT(r**2 - z**2)*COS(phi) + L
         F(i, 2) = SQRT(r**2 - z**2)*SIN(phi)
         F(i, 3) = z
      END DO
   END SUBROUTINE POSICION_INICIAL_FRAGMENTOS

   SUBROUTINE VELOCIDADES_INICIALES_FRAGMENTOS(M_p, p, v)
      REAL(kind), INTENT(IN) :: M_p, p(:, :)
      REAL(kind), INTENT(OUT) :: v(:, :)
      REAL(kind) :: r, rapidez, perturbacion, centripeta(3), tangencial(3), z(3)
      INTEGER :: i, n

      n = SIZE(p, 1)
      z = [0.0_kind, 0.0_kind, 1.0_kind]
      !
      DO i = 1, n
         r = MAGNITUD(p(i, :))
         !velocidad orbital
         rapidez = SQRT(G*M_p/r)

         CALL RANDOM_NUMBER(perturbacion)
         perturbacion = -0.01_kind + 0.02_kind*perturbacion
         rapidez = rapidez + perturbacion
         centripeta = -p(i, :)/r
         tangencial = PRODUCTO_CRUZ(centripeta, z)
         tangencial = tangencial/MAGNITUD(tangencial)

         v(i, :) = rapidez*tangencial
      END DO
   END SUBROUTINE VELOCIDADES_INICIALES_FRAGMENTOS

END MODULE CONDICIONES_INICIALES

MODULE RADIO_Y_DENSIDAD
   use UNIDADES_NATURALES
   use OPERACIONES_VECTORIALES

CONTAINS

   SUBROUTINE radio(rf, dt, RADIOS_ANILLOS, radios)
      REAL(KIND), INTENT(IN)::rf(:, :, :)
      REAL(KIND), INTENT(IN)::dt
      REAL(KIND), ALLOCATABLE, INTENT(OUT)::RADIOS(:, :, :)
      REAL(KIND), allocatable::RADIOS_MEDIOS(:, :), x(:)
      INTEGER::i, n, J, M
      REAL(KIND), allocatable, INTENT(OUT)::RADIOS_ANILLOS(:, :)

      n = size(RF, 1)
      m = size(RF, 2)
      allocate (X(M), RADIOS_MEDIOS(n, 2), radios(n, m, 1), radios_anillos(m, 2))
      !OBTENEMOS EL ARREGLO DE TODOS LAS DISTANCIAS A CADA FRAGMENTOS EN TODOS LOS TIEMPOS
      DO i = 1, n
         DO j = 1, m
            RADIOS(i, j, 1) = magnitud(rf(i, j, :))
         END DO
      END DO
      !almacenar en una arreglo
      do i = 1, n
         Do j = 1, m
            x(j) = radios(i, j, 1)
         END DO
         !calcular el tiempo de la iteracion
         RADIOS_MEDIOS(i, 1) = i*dt
         !poner el radio medio por iteracion
         RADIOS_MEDIOS(i, 2) = media(m, x)
      END DO
      RADIOS_ANILLOS = RADIOs_MEDIOS
      DEALLOCATE (x, RADIOs_MEDIOS)
   END SUBROUTINE RADIO

   SUBROUTINE DENSIDAD(radios, dt, rf, densidades)
      REAL(KIND), INTENT(IN)::RADIOS(:, :, :)
      REAL(KIND), INTENT(IN)::dt
      REAL(KIND), INTENT(IN)::rf(:, :, :)
      REAL(KIND), allocatable::X(:), z(:)
      REAL(KIND), INTENT(OUT)::DENSIDADES(:, :)
      INTEGER::n, M, i, j

      n = size(RADIOS, 1)
      M = SIZE(RADIOS, 2)

      allocate (X(m), z(m))
      DO i = 1, n
         Do j = 1, m
            z(j) = rf(i, j, 3)
         END DO

         call QUICKSORT(z, 1, m, m)

         DO j = 1, m
            x(j) = radios(i, j, 1)
         END DO

         call QUICKSORT(x, 1, m, m)

         DENSIDADes(i, 1) = i*dt
         DENSIDADes(i, 2) = m/(pi*(x(m - 5)**2 - x(5)**2)*(z(m) - z(1)))
      END DO
      deallocate (x, z)
   END SUBROUTINE DENSIDAD

END MODULE RADIO_Y_DENSIDAD

MODULE COLISIONES
   USE UNIDADES_NATURALES
   USE OPERACIONES_VECTORIALES

CONTAINS

   SUBROUTINE COLISION(ra, va, rb, vb, vfa, vfb)
      REAL(KIND), INTENT(iN)::va(3), vb(3)
      REAL(KIND), INTENT(INOUT)::ra(3), rb(3)
      REAL(KIND)::n(3), resta(3), velocidad_relativa(3)
      real(kind), intent(out)::vfa(3), vfb(3)

      resta = ra - rb
      n = (resta)/magnitud(resta)

      velocidad_relativa = va - vb
      !conservacion del moemnto
      VFa = va - (DOT_PRODUCT(velocidad_relativa, n))*n
      VFb = vb + (DOT_PRODUCT(velocidad_relativa, n))*n
      !separamos los fragmentos
      ra = ra + (1e-6_kind - magnitud(resta))*n
      rb = rb - (1e-6_kind - magnitud(resta))*n
   END SUBROUTINE

   SUBROUTINE CHOQUE(R, V, VF)
      REAL(kind), INTENT(INout)::R(:, :)
      REAL(KIND), INTENT(INout)::V(:, :)
      REAL(KIND), INTENT(OUT)::VF(:, :)
      INTEGER::n, i, j, k, m, renglon1, renglon2, coli
      logical::choco
      n = size(R, 1)
      coli = 0
      Do renglon1 = 1, n - 1
         DO renglon2 = renglon1 + 1, n
            choco = (MAGNITUD(R(renglon1, :) - R(renglon2, :))) < 1e-6_kind

            if (choco) then
               coli = coli + 1
               call colision(r(renglon1, :), r(renglon2, :), v(renglon1, :), v(renglon2, :), vf(renglon1, :), vf(renglon2, :))
            end if
         end do
      end dO
   END SUBROUTINE CHOQUE

END MODULE COLISIONES
MODULE GRAVITACION
   USE UNIDADES_NATURALES
   USE OPERACIONES_VECTORIALES
   USE CONDICIONES_INICIALES
   USE COLISIONES
   USE RADIO_Y_DENSIDAD

   IMPLICIT NONE

CONTAINS
   SUBROUTINE SIMULACION(masa_planeta, t_sim, N_steps, radio_inicial, distancia_inicial, rf, densidad_global, RADIOS_ANILLOS)
      REAL(kind), INTENT(IN)::masa_planeta, t_sim, radio_inicial, distancia_inicial
      INTEGER, INTENT(IN)::N_steps
      REAL(kind), INTENT(OUT)::rf(:, :, :), DENSIDAD_GLOBAL(:, :)
      REAL(KIND), ALLOCATABLE, INTENT(OUT)::radios_anillos(:, :)

      REAL(kind)::vf(SIZE(rf, 1), SIZE(rf, 2), SIZE(rf, 3))
      REAL(KIND), allocatable::RADIOS(:, :, :)
      REAL(kind)::dt, a(3), r(3), v(3), E
      INTEGER::i, k, n_frag, orbito = 0, ESTRELLO = 0, ESCAPO = 0, j
      REAL(kind), PARAMETER::TOLERANCE = 1.0e-6_kind

      n_frag = SIZE(rf, 2)
      ALLOCATE (RADIOS(N_steps, n_frag, 1))

      ! Inicialización
      CALL POSICION_INICIAL_FRAGMENTOS(rf(1, :, :), radio_inicial, distancia_inicial)
      CALL VELOCIDADES_INICIALES_FRAGMENTOS(masa_planeta, rf(1, :, :), vf(1, :, :))

      dt = t_sim/REAL(N_steps - 1, kind)

      !simulacion del sistema
      DO k = 1, N_steps - 1
         CALL CHOQUE(rf(k + 1, :, :), vf(k + 1, :, :), vf(k + 1, :, :))
         DO i = 1, n_frag
            r = rf(k, i, :)
            v = vf(k, i, :)

            ! Aceleración gravitacional
            a = -G*masa_planeta*r/(MAGNITUD(r)**3)

            ! Actualización de velocidad y posición
            vf(k + 1, i, :) = v + a*dt
            rf(k + 1, i, :) = r + vf(k + 1, i, :)*dt

         END DO
      END DO

      !encontramos el radio medio
      CALL radio(rf, dt, RADIOS_ANILLOS, radios)
      !encontramos la densidad global
      call DENSIDAD(radios, dt, rf, densidad_global)
      ! Clasificación de órbitas

      DO i = 1, n_frag
         r = rf(N_steps, i, :)
         v = vf(N_steps, i, :)
         E = 0.5_kind*DOT_PRODUCT(v, v) - G*masa_planeta/MAGNITUD(r)

         IF (E > 0.0_kind .and. magnitud(V) > 0) THEN
            escapo = ESCAPO + 1

         ELSE IF (MAGNITUD(v) <= TOLERANCE .and. E < 0) THEN
            ESTRELLO = estrello + 1
         ELSE if (E < 0 .and. magnitud(v) >= TOLERANCE) then
            orbito = orbito + 1
         END IF
      END DO

      PRINT *, "Fragmentos en orbita: ", orbito
      PRINT *, "Fragmentos estrellados: ", ESTRELLO
      PRINT *, "Fragmentos escapados: ", escapo

      DEALLOCATE (RADIOS)
   END SUBROUTINE SIMULACION

   SUBROUTINE OUTPUT(Rf)
      REAL(kind), INTENT(IN) :: Rf(:, :, :)
      INTEGER :: i, unit, unit0, unit1, k
      CHARACTER(len=20)::filename = "ANILLO_SATURNIANO"

      !Do k=1,size(RF,1),50
      !write(filename, '("frame_", I5.5, ".dat")') k
      !open(newunit=unit, file=filename, status="replace")

      !do i = 1, size(rf,2)
      !write(unit, '(6F15.8)') rf(k, i, 1), rf(k, i, 2), rf(k, i, 3),0.0,0.0,0.0
      !end do

      !CLOSE(unit)
      ! end do

      OPEN (NEWUNIT=unit1, FILE="ANILLO SATURNIANO", STATUS='REPLACE')
      DO i = 1, SIZE(Rf, 2)
         WRITE (unit1, *) Rf(SIZE(Rf, 1), i, 1), Rf(SIZE(Rf, 1), i, 2), Rf(SIZE(Rf, 1), i, 3)
      END DO
      CLOSE (unit1)
      OPEN (NEWUNIT=unit0, FILE="LUNA EXPLOTADA", STATUS='REPLACE')
      DO i = 1, SIZE(Rf, 2)
         WRITE (unit0, *) Rf(1, i, 1), Rf(1, i, 2), Rf(1, i, 3)
      END DO
      CLOSE (unit0)
   END SUBROUTINE OUTPUT

   SUBROUTINE OUTPUT_GRAFICOS(radios_anillos, DENSIDAD_GLOBAL)
      REAL(KIND), INTENT(IN)::radios_anillos(:, :), DENSIDAD_GLOBAL(:, :)
      INTEGER::i, unit, unit0

      OPEN (NEWUNIT=UNIT, FILE="RADIO VS T ", STATUS="REPLACE")
      DO i = 1, size(radios_anillos, 1)
         write (unit, *) radios_anillos(i, 1), radios_anillos(i, 2)
      END DO

      CLOSE (UNIT)
      OPEN (NEWUNIT=UNIT0, FILE="DENSIDAD VS T ", STATUS="REPLACE")
      DO i = 4000, size(DENSIDAD_GLOBAL, 1)
         write (unit0, *) DENSIDAD_GLOBAL(i, 1), DENSIDAD_GLOBAL(i, 2)
      END DO

      CLOSE (UNIT0)
   END SUBROUTINE OUTPUT_GRAFICOS

END MODULE GRAVITACION
