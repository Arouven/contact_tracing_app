--
--
--required
--
--
--
-- CREATING TABLES
CREATE TABLE `User` (
  `email` VARCHAR(255) NOT NULL,
  `firstName` VARCHAR(255) NOT NULL,
  `lastName` VARCHAR(255) NOT NULL,
  `address` VARCHAR(255) NOT NULL,
  `dateOfBirth` DATE NOT NULL,
  PRIMARY KEY (`email`)
);

CREATE TABLE `Mobile` (
  `mobileNumber` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `mobileName` VARCHAR(255) NOT NULL,
  `fcmtoken` TEXT NOT NULL,
  `contactWithInfected` BOOLEAN DEFAULT FALSE,
  `confirmInfected` BOOLEAN DEFAULT FALSE,
  `dateTimeLastTest` BIGINT DEFAULT NULL,
  PRIMARY KEY (`mobileNumber`),
  FOREIGN KEY (`email`) REFERENCES `User`(`email`) ON DELETE CASCADE
);

CREATE TABLE `Coordinates` (
  `coordinatesId` BIGINT NOT NULL AUTO_INCREMENT,
  `mobileNumber` VARCHAR(255) NOT NULL,
  `dateTimeCoordinates` BIGINT NOT NULL,
  `latitude` VARCHAR(255) NOT NULL,
  `longitude` VARCHAR(255) NOT NULL,
  `accuracy` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`coordinatesId`),
  FOREIGN KEY (`mobileNumber`) REFERENCES `Mobile`(`mobileNumber`) ON DELETE CASCADE
);

CREATE TABLE `AdminParamters` (
  `adminParamtersId` BIGINT NOT NULL AUTO_INCREMENT,
  `contactDistance` BIGINT NOT NULL,
  `daysOfTestValidity` BIGINT NOT NULL,
  `daysFromContact` BIGINT NOT NULL,
  PRIMARY KEY (`adminParamtersId`)
);
CREATE TABLE `Admin` (
  `email` VARCHAR(255) NOT NULL,
  `username` VARCHAR(255) NOT NULL,
  `password` TEXT NOT NULL,
  PRIMARY KEY (`email`)
);
CREATE TABLE `TestingCentres` (
  `testingId` BIGINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `address` VARCHAR(255) NOT NULL,
  `latitude` VARCHAR(255) NOT NULL,
  `longitude` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`testingId`)
);

--
--
-- create stored procedure
DELIMITER
    //
CREATE PROCEDURE GETUSERINFO(IN email VARCHAR(255))
BEGIN
    SELECT
        u.email,
        u.firstName,
        u.lastName,
        u.dateOfBirth,
        u.address,
        GROUP_CONCAT(
            DISTINCT m.mobileNumber SEPARATOR '\n'
        ) AS mobiles
    FROM
        `User` u
    INNER JOIN `Mobile` m ON
        u.email = m.email
    WHERE
        u.email = email ;
END ; //
DELIMITER
    ;

--
--
-- INSERTING TEST DATA INTO TABLES
INSERT INTO
  `AdminParamters` (
    contactDistance,
    daysOfTestValidity,
    daysFromContact
  )
VALUES
  (2, 7, 14);

-- end required
--
--
--
--
-- dummy values
--
--
-- INSERTING TEST DATA INTO TABLES
--start dummy testing centres
INSERT INTO
  `TestingCentres` (
    name,
    address,
    latitude,
    longitude
  )
VALUES
  (
    'port-louis testing center',
    'Volcy Pougnet Street (ex-rue Madame), Port Louis',
    '-20.1689972',
    '57.4999664'
  ),
  (
    'bambous testing center',
    'Royal road near winners, Bambous',
    '-20.257669',
    '57.413318'
  );

--end dummy testing centres
--
--start dummy users
INSERT INTO
  `User` (
    firstName,
    lastName,
    address,
    dateOfBirth,
    email
  )
VALUES
  (
    'John',
    'Smith',
    'Bambous',
    '2000-01-13',
    'JohnSmith@gmail.com'
  ),
  (
    'James',
    'Smith',
    'Port-Louis',
    '2000-01-13',
    'JamesSmith@gmail.com'
  );

-- end dummy users
--
-- start insert dummy mobiles
INSERT INTO
  `Mobile` (
    email,
    mobileName,
    mobileNumber,
    fcmtoken
  )
VALUES
  (
    'JohnSmith@gmail.com',
    'Samsung me home',
    '+23012345670',
    'Dummy token1'
  ),
  (
    'JohnSmith@gmail.com',
    'iphone545125-mother',
    '+23012345671',
    'Dummy token2'
  ),
  (
    'JohnSmith@gmail.com',
    'huawei-6548-father',
    '+23012345672',
    'Dummy token3'
  );

--dummy non infected and non contact with infected
INSERT INTO
  `Mobile` (
    email,
    mobileName,
    mobileNumber,
    fcmtoken,
    contactWithInfected,
    confirmInfected
  )
VALUES
  (
    'JamesSmith@gmail.com',
    'nokia-56546-james-home',
    '+23012345673',
    'Dummy token4',
    0,
    0
  ),
  (
    'JamesSmith@gmail.com',
    'nokia de la mere de james',
    '+23012345674',
    'Dummy token5',
    0,
    0
  ),
  (
    'JamesSmith@gmail.com',
    'nokia de la soeur de james',
    '+23012345675',
    'Dummy token6',
    0,
    0
  ),
  (
    'JamesSmith@gmail.com',
    'nokia du frere de james',
    'nokia du frere de james',
    '+23012345676',
    'Dummy token7',
    0,
    0
  );

-- dummy infected person
INSERT INTO
  `Mobile` (
    email,
    mobileName,
    mobileNumber,
    fcmtoken,
    contactWithInfected,
    confirmInfected,
    dateTimeLastTest
  )
VALUES
  (
    'JamesSmith@gmail.com',
    'nokia du pere de james',
    '+23012345677',
    'Dummy token8',
    0,
    1,
    1629629292
  );

--end insert mobiles
--
--dummy coordinates
INSERT INTO
  `Coordinates` (
    coordinatesId,
    mobileNumber,
    dateTimeCoordinates,
    latitude,
    longitude,
    accuracy
  )
VALUES
  (
    '+23057775794',
    1629629291,
    '-20.2668034','57.4170724,',
    '1'
  ),
  (
    2,
    '+23012345670',
    1629629292,
    '-20.267031',
    '57.417493',
    '1'
  ),
  (
    3,
    '+23012345670',
    1629629293,
    '-20.267031',
    '57.417493',
    '1'
  ),
  (
    4,
    '+23012345671',
    1629629291,
    '-20.267031',
    '57.417493',
    '1'
  ),
  (
    5,
    '+23012345671',
    1629629292,
    '-20.267031',
    '57.417493',
    '1'
  ),
  (
    6,
    '+23012345671',
    1629629293,
    '-20.267031',
    '57.417493',
    '1'
  ),
  (
    7,
    '+23012345672',
    1629629291,
    '-20.183035',
    '57.469663',
    '1'
  ),
  (
    8,
    '+23012345672',
    1629629292,
    '-20.183035',
    '57.469663',
    '1'
  ),
  (
    9,
    '+23012345672',
    1629629293,
    '-20.183035',
    '57.469663',
    '1'
  ),
  (
    10,
    '+23012345673',
    1629629291,
    '-20.160839',
    '57.497987',
    '1'
  ),
  (
    11,
    '+23012345673',
    1629629292,
    '-20.160839',
    '57.497987',
    '1'
  ),
  (
    12,
    '+23012345673',
    1629629293,
    '-20.160839',
    '57.497987',
    '1'
  ),
  (
    13,
    '+23012345674',
    1629629291,
    '-20.405418',
    '57.709455',
    '1'
  ),
  (
    14,
    '+23012345674',
    1629629292,
    '-20.405418',
    '57.709455',
    '1'
  ),
  (
    15,
    '+23012345674',
    1629629293,
    '-20.405418',
    '57.709455',
    '1'
  ),
  (
    16,
    '+23012345675',
    1629629291,
    '-20.160839',
    '57.497987',
    '1'
  ),
  (
    17,
    '+23012345675',
    1629629292,
    '-20.160839',
    '57.497987',
    '1'
  ),
  (
    18,
    '+23012345675',
    1629629293,
    '-20.160839',
    '57.497987',
    '1'
  ),
  (
    19,
    '+23012345676',
    1629629291,
    '-20.160839',
    '57.497987',
    '1'
  ),
  (
    20,
    '+23012345676',
    1629629292,
    '-20.160839',
    '57.497987',
    '1'
  ),
  (
    21,
    '+23012345676',
    1629629293,
    '-20.160839',
    '57.497987',
    '1'
  ),
  (
    22,
    '+23012345677',
    1629629288,
    '-20.160839',
    '57.497987',
    '1'
  ),
  (
    23,
    '+23012345677',
    1629629289,
    '-20.160839',
    '57.497987',
    '1'
  ),
  (
    24,
    '+23012345677',
    1629629290,
    '-20.160839',
    '57.497987',
    '1'
  ),
  (
    25,
    '+23012345677',
    1629629291,
    '-20.183035',
    '57.469663',
    '1'
  ),
  (
    26,
    '+23012345677',
    1629629292,
    '-20.183035',
    '57.469663',
    '1'
  ),
  (
    27,
    '+23012345677',
    1629629293,
    '-20.183035',
    '57.469663',
    '1'
  ),
  (
    28,
    '+23012345677',
    1629629294,
    '-20.160839',
    '57.497987',
    '1'
  ),
  (
    29,
    '+23012345677',
    1629629295,
    '-20.160839',
    '57.497987',
    '1'
  ),
  (
    30,
    '+23012345677',
    1629629296,
    '-20.160839',
    '57.497987',
    '1'
  );

--end of insert coordinates
--end of insertion of dummy values




-- start testing dummy mobiles
INSERT INTO
  `Mobile` (
    mobileNumber,
    email,
    mobileName,
    fcmtoken,
    contactWithInfected,
    confirmInfected
  )
VALUES
  (
'+23057775790',
'apoolian@umail.utm.ac.mu',
'my mobile',
'dummy token',
0,
0
),
  (
'+23057775791',
'apoolian@umail.utm.ac.mu',
'my mobile',
'dummy token',
0,
0
),
  (
'+23057775792',
'apoolian@umail.utm.ac.mu',
'my mobile',
'dummy token',
0,
0
),
  (
'+23057775793',
'apoolian@umail.utm.ac.mu',
'my mobile',
'dummy token',
0,
0
),  (
'+23057775794',
'apoolian@umail.utm.ac.mu',	
'SM-G532F-PERSO',
'flnmOmj4RYqfllEekHcBHe:APA91bFGgeGF6DCn0LKKVXSk2VRwkJohwkk6xx1hKFuWAHwctW7TWW--qNkFPos2eo3m9nRxzDZNMs1MxvAdtmpgWjwGwrAk4LDmb6GSHwN15R9fPUt6Ud05dpkSpSLkJcHxrNlyUbfV',
0,0
),
  (
'+23057775795',
'apoolian@umail.utm.ac.mu',
'my mobile',
'dummy token',
0,
0
),
  (
'+23057775796',
'apoolian@umail.utm.ac.mu',
'my mobile',
'dummy token',
0,
0
),
  (
'+23057775797',
'apoolian@umail.utm.ac.mu',
'my mobile',
'dummy token',
0,
0
),
  (
'+23057775798',
'apoolian@umail.utm.ac.mu',
'my mobile',
'dummy token',
0,
0
),
  (
'+23057775799',
'apoolian@umail.utm.ac.mu',
'my mobile',
'dummy token',
0,
0
);


INSERT INTO
  `Coordinates` (
    mobileNumber,
    dateTimeCoordinates,
    latitude,
    longitude,
    accuracy
  )
VALUES
  ('+23057775790', 1641527100,'-20.266162', '57.415321','1'),--familyA-father-07/01/2022-07.45
  ('+23057775791', 1641527100,'-20.2668034','57.4170724','1'),--familyA-mother-07/01/2022-07.45
  ('+23057775792', 1641527100,'-20.2668034','57.4170724','1'),--familyA-dauther-07/01/2022-07.45
  ('+23057775793', 1641527100,'-20.2668034','57.4170724','1'),--familyA-son-07/01/2022-07.45

  ('+23057775794', 1641527100,'-20.266454', '57.417569','1'),--familyB-son-07/01/2022-07.45
  ('+23057775795', 1641527100,'-20.2668034','57.4170724','1'),--familyB-mother-07/01/2022-07.45
  ('+23057775796', 1641527100,'-20.2668034','57.4170724','1'),--familyB-father-07/01/2022-07.45

  ('+23057775797', 1641527100,'-20.2668034','57.4170724','1'),--familyC-wife-07/01/2022-07.45
  ('+23057775798', 1641527100,'-20.2668034','57.4170724','1'),--familyC-husband-07/01/2022-07.45
  ('+23057775799', 1641527100,'-20.2668034','57.4170724','1'),--familyC-nephew-07/01/2022-07.45
  
 ;