-- =====================================================================
-- DATOS DE PRUEBA - ELECCIONES GENERALES PERU 2026
-- Generado para modelo SQL Server
-- Orden de insercion respeta integridad referencial:
--   ELECCIONES > PARTIDO_POLITICO > EMPLEADO > REGISTRO > CANDIDATOS
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. ELECCIONES
-- ---------------------------------------------------------------------
SET IDENTITY_INSERT ELECCIONES OFF;

INSERT INTO ELECCIONES (NOMBRE, ESTADO) VALUES
('Elecciones Generales Peru 2026 - Primera Vuelta', 1);
-- ID_ELECCION = 1 (IDENTITY)

GO

-- ---------------------------------------------------------------------
-- 2. PARTIDO_POLITICO (10 partidos)
-- ---------------------------------------------------------------------
INSERT INTO PARTIDO_POLITICO (NOMBRE) VALUES
('Fuerza Popular'),                          -- ID_PARTIDO = 1
('Alianza para el Progreso'),                -- ID_PARTIDO = 2
('Peru Libre'),                              -- ID_PARTIDO = 3
('Renovacion Popular'),                      -- ID_PARTIDO = 4
('Podemos Peru'),                            -- ID_PARTIDO = 5
('Accion Popular'),                          -- ID_PARTIDO = 6
('Partido Morado'),                          -- ID_PARTIDO = 7
('Union por el Peru'),                       -- ID_PARTIDO = 8
('Somos Peru'),                              -- ID_PARTIDO = 9
('Avancemos');                               -- ID_PARTIDO = 10

GO

-- ---------------------------------------------------------------------
-- 3. EMPLEADO (un operador que registra las inscripciones)
-- ---------------------------------------------------------------------
INSERT INTO EMPLEADO (DNI, APELLIDOS, NOMBRES, USUARIO, CLAVE) VALUES
('12345678', 'Torres Quispe',   'Carlos Alberto',  'ctorres',  'Op3r@2026'),
('87654321', 'Huaman Villena',  'Maria Elena',     'mhuaman',  'R3g!str0'),
('11223344', 'Flores Medina',   'Jorge Luis',      'jflores',  'Ju3c3s26');
-- ID_EMPLEADO: 1, 2, 3

GO

-- ---------------------------------------------------------------------
-- 4. REGISTRO (un registro por cada partido en la eleccion)
--    ID_ELECCION = 1 para todos
--    ID_EMPLEADO rotado entre los 3 empleados
-- ---------------------------------------------------------------------
INSERT INTO REGISTRO (ID_ELECCION, ID_PARTIDO, FECHA, HORA, OBSERVACIONES, ID_EMPLEADO) VALUES
(1,  1, '20251015', '09:00', 'Inscripcion conforme - documentacion completa', 1),
(1,  2, '20251015', '09:30', 'Inscripcion conforme - documentacion completa', 1),
(1,  3, '20251015', '10:00', 'Inscripcion conforme - documentacion completa', 2),
(1,  4, '20251015', '10:30', 'Inscripcion conforme - documentacion completa', 2),
(1,  5, '20251015', '11:00', 'Inscripcion conforme - documentacion completa', 2),
(1,  6, '20251015', '11:30', 'Inscripcion conforme - documentacion completa', 3),
(1,  7, '20251015', '12:00', 'Inscripcion conforme - documentacion completa', 3),
(1,  8, '20251015', '14:00', 'Inscripcion conforme - documentacion completa', 3),
(1,  9, '20251015', '14:30', 'Inscripcion conforme - documentacion completa', 1),
(1, 10, '20251015', '15:00', 'Inscripcion conforme - documentacion completa', 1);

GO

-- ---------------------------------------------------------------------
-- 5. CANDIDATOS
--    ORDEN 1 = Presidente
--    ORDEN 2 = Primer Vicepresidente
--    ORDEN 3 = Segundo Vicepresidente
--    DNIs ficticios para datos de prueba
--    FEC_NAC plausibles (mayores de 35 anios al 2026)
-- ---------------------------------------------------------------------

-- PARTIDO 1: Fuerza Popular
INSERT INTO CANDIDATOS (ID_ELECCION, ID_PARTIDO, DNI, APELLIDOS, NOMBRES, FEC_NAC, ORDEN) VALUES
(1, 1, '10000001', 'Fujimori Higuchi',     'Keiko Sofia',          '19750525', 1),
(1, 1, '10000002', 'Chlimper Ackermann',   'Jose Joaquin',         '19690312', 2),
(1, 1, '10000003', 'Salaverry Villa',      'Daniel Enrique',       '19770804', 3);

-- PARTIDO 2: Alianza para el Progreso
INSERT INTO CANDIDATOS (ID_ELECCION, ID_PARTIDO, DNI, APELLIDOS, NOMBRES, FEC_NAC, ORDEN) VALUES
(1, 2, '10000004', 'Acuna Peralta',        'Cesar',                '19521212', 1),
(1, 2, '10000005', 'Llatas Altamirano',    'Luis Humberto',        '19680620', 2),
(1, 2, '10000006', 'Vasquez Cotrina',      'Rosa Patricia',        '19741108', 3);

-- PARTIDO 3: Peru Libre
INSERT INTO CANDIDATOS (ID_ELECCION, ID_PARTIDO, DNI, APELLIDOS, NOMBRES, FEC_NAC, ORDEN) VALUES
(1, 3, '10000007', 'Cerrón Rojas',         'Vladimir',             '19700216', 1),
(1, 3, '10000008', 'Bellido Ugarte',       'Guido Ricardo',        '19650903', 2),
(1, 3, '10000009', 'Mendoza Frassinetti', 'Veronika Natalia',      '19760422', 3);

-- PARTIDO 4: Renovacion Popular
INSERT INTO CANDIDATOS (ID_ELECCION, ID_PARTIDO, DNI, APELLIDOS, NOMBRES, FEC_NAC, ORDEN) VALUES
(1, 4, '10000010', 'Lopez Aliaga Cazorla', 'Rafael Santos',        '19680714', 1),
(1, 4, '10000011', 'Reggiardo Barreto',    'Alejandro Martin',     '19600130', 2),
(1, 4, '10000012', 'Tudela van Breugel',   'Francisco Javier',     '19551019', 3);

-- PARTIDO 5: Podemos Peru
INSERT INTO CANDIDATOS (ID_ELECCION, ID_PARTIDO, DNI, APELLIDOS, NOMBRES, FEC_NAC, ORDEN) VALUES
(1, 5, '10000013', 'Luna Galvez',          'Jose',                 '19610507', 1),
(1, 5, '10000014', 'Menchola Vasquez',     'Patricia Cecilia',     '19720815', 2),
(1, 5, '10000015', 'Paredes Solis',        'Roberto Carlos',       '19780328', 3);

-- PARTIDO 6: Accion Popular
INSERT INTO CANDIDATOS (ID_ELECCION, ID_PARTIDO, DNI, APELLIDOS, NOMBRES, FEC_NAC, ORDEN) VALUES
(1, 6, '10000016', 'Garcia Belaunde',      'Victor Andres',        '19541122', 1),
(1, 6, '10000017', 'Lescano Ancieta',      'Yonhy',                '19580709', 2),
(1, 6, '10000018', 'Salgado Rubianes',     'Luz Filomena',         '19630214', 3);

-- PARTIDO 7: Partido Morado
INSERT INTO CANDIDATOS (ID_ELECCION, ID_PARTIDO, DNI, APELLIDOS, NOMBRES, FEC_NAC, ORDEN) VALUES
(1, 7, '10000019', 'Sagasti Hochhausler',  'Francisco Rafael',     '19441009', 1),
(1, 7, '10000020', 'Guibovich Arteaga',    'Maria Belen',          '19710618', 2),
(1, 7, '10000021', 'Neyra Olaychea',       'Carlos Augusto',       '19671205', 3);

-- PARTIDO 8: Union por el Peru
INSERT INTO CANDIDATOS (ID_ELECCION, ID_PARTIDO, DNI, APELLIDOS, NOMBRES, FEC_NAC, ORDEN) VALUES
(1, 8, '10000022', 'Antauro Humala Tasso', 'Isaac Humala',         '19650401', 1),
(1, 8, '10000023', 'Quispe Tito',          'Felipe Santiago',      '19590827', 2),
(1, 8, '10000024', 'Mamani Condori',       'Rosa Elvira',          '19730111', 3);

-- PARTIDO 9: Somos Peru
INSERT INTO CANDIDATOS (ID_ELECCION, ID_PARTIDO, DNI, APELLIDOS, NOMBRES, FEC_NAC, ORDEN) VALUES
(1, 9, '10000025', 'Villanueva Arévalo',   'Cesar Wilfredo',       '19520909', 1),
(1, 9, '10000026', 'Diez Canseco Terry',   'Javier',               '19590523', 2),
(1, 9, '10000027', 'Alcorta Suero',        'Lourdes',              '19640730', 3);

-- PARTIDO 10: Avancemos
INSERT INTO CANDIDATOS (ID_ELECCION, ID_PARTIDO, DNI, APELLIDOS, NOMBRES, FEC_NAC, ORDEN) VALUES
(1, 10, '10000028', 'Barnechea Garcia',    'Alfredo',              '19480602', 1),
(1, 10, '10000029', 'Gutierrez Perez',     'Ana Lucia',            '19751014', 2),
(1, 10, '10000030', 'Delgado Zegarra',     'Manuel Augusto',       '19690307', 3);

GO

-- ---------------------------------------------------------------------
-- CONSULTA DE VERIFICACION
-- ---------------------------------------------------------------------
SELECT
    e.NOMBRE                                        AS Eleccion,
    pp.NOMBRE                                       AS Partido,
    r.FECHA                                         AS FechaRegistro,
    r.HORA                                          AS Hora,
    emp.APELLIDOS + ', ' + emp.NOMBRES              AS Registrado_por,
    c.ORDEN                                         AS Orden,
    CASE c.ORDEN
        WHEN 1 THEN 'Presidente'
        WHEN 2 THEN 'Primer Vicepresidente'
        WHEN 3 THEN 'Segundo Vicepresidente'
    END                                             AS Cargo,
    c.APELLIDOS + ', ' + c.NOMBRES                 AS Candidato,
    CONVERT(varchar(10), c.FEC_NAC, 103)            AS FechaNacimiento
FROM ELECCIONES e
    INNER JOIN REGISTRO r       ON r.ID_ELECCION = e.ID_ELECCION
    INNER JOIN PARTIDO_POLITICO pp ON pp.ID_PARTIDO = r.ID_PARTIDO
    INNER JOIN EMPLEADO emp      ON emp.ID_EMPLEADO  = r.ID_EMPLEADO
    INNER JOIN CANDIDATOS c     ON  c.ID_ELECCION   = r.ID_ELECCION
                                AND c.ID_PARTIDO    = r.ID_PARTIDO
ORDER BY
    pp.NOMBRE ASC,
    c.ORDEN   ASC;
GO