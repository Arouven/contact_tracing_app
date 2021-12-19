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
  FOREIGN KEY (`email`) REFERENCES `User`(`email`)
);

CREATE TABLE `Coordinates` (
  `coordinatesId` BIGINT NOT NULL AUTO_INCREMENT,
  `mobileNumber` VARCHAR(255) NOT NULL,
  `dateTimeCoordinates` BIGINT NOT NULL,
  `latitude` VARCHAR(255) NOT NULL,
  `longitude` VARCHAR(255) NOT NULL,
  `accuracy` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`coordinatesId`),
  FOREIGN KEY (`mobileNumber`) REFERENCES `Mobile`(`mobileNumber`)
);

CREATE TABLE `AdminParamters` (
  `adminParamtersId` BIGINT NOT NULL AUTO_INCREMENT,
  `contactDistance` BIGINT NOT NULL,
  `daysOfTestValidity` BIGINT NOT NULL,
  `daysFromContact` BIGINT NOT NULL,
  PRIMARY KEY (`adminParamtersId`)
);

CREATE TABLE `TestingCentres` (
  `testingId` BIGINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `address` VARCHAR(255) NOT NULL,
  `latitude` VARCHAR(255) NOT NULL,
  `longitude` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`testingId`)
);

-- INSERTING TEST DATA INTO TABLES
INSERT INTO
  `AdminParamters` (
    contactDistance,
    daysOfTestValidity,
    daysFromContact
  )
VALUES
  (2, 7, 14);

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

INSERT INTO
  `User` (
    firstName,
    lastName,
    address,
    dateOfBirth,
    email,
    firebaseuid
  )
VALUES
  (
    'John',
    'Smith',
    'Bambous',
    '2000-01-13',
    'JohnSmith@gmail.com',
    '1234'
  ),
  (
    'James',
    'Smith',
    'Port-Louis',
    '2000-01-13',
    'JamesSmith@gmail.com',
    '1234'
  );

INSERT INTO
  `Mobile` (
    mobileId,
    userId,
    mobileName,
    mobileDescription,
    mobileNumber
  )
VALUES
  (1, 1, 'Samsung me', 'Samsung me', '+23012345678'),
  (
    2,
    1,
    'iphone mother',
    'iphone mother',
    '+23012345678'
  ),
  (
    3,
    1,
    'huawei father',
    'huawei father',
    '+23012345678'
  );

INSERT INTO
  `Mobile` (
    mobileId,
    userId,
    mobileName,
    mobileDescription,
    mobileNumber,
    contactWithInfected,
    confirmInfected
  )
VALUES
  (
    4,
    2,
    'nokia de james',
    'nokia de james',
    '+23012345678',
    0,
    0
  ),
  (
    5,
    2,
    'nokia de la mere de james',
    'nokia de la mere de james',
    '+23012345678',
    0,
    0
  ),
  (
    6,
    2,
    'nokia de la soeur de james',
    'nokia de la soeur de james',
    '+23012345678',
    0,
    0
  ),
  (
    7,
    2,
    'nokia du frere de james',
    'nokia du frere de james',
    '+23012345678',
    0,
    0
  );

INSERT INTO
  `Mobile` (
    mobileId,
    userId,
    mobileName,
    mobileDescription,
    mobileNumber,
    contactWithInfected,
    confirmInfected,
    dateTimeLastTest
  )
VALUES
  (
    8,
    2,
    'nokia du pere de james',
    'nokia du pere de james',
    '+23012345678',
    0,
    1,
    1629629292
  );

INSERT INTO
  `Coordinates` (
    coordinatesId,
    mobileId,
    dateTimeCoordinates,
    latitude,
    longitude,
    accuracy
  )
VALUES
  (
    1,
    1,
    1629629291,
    '-20.267031',
    '57.417493',
    '1'
  ),
  (
    2,
    1,
    1629629292,
    '-20.267031',
    '57.417493',
    '1'
  ),
  (
    3,
    1,
    1629629293,
    '-20.267031',
    '57.417493',
    '1'
  ),
  (
    4,
    2,
    1629629291,
    '-20.267031',
    '57.417493',
    '1'
  ),
  (
    5,
    2,
    1629629292,
    '-20.267031',
    '57.417493',
    '1'
  ),
  (
    6,
    2,
    1629629293,
    '-20.267031',
    '57.417493',
    '1'
  ),
  (
    7,
    3,
    1629629291,
    '-20.183035',
    '57.469663',
    '1'
  ),
  (
    8,
    3,
    1629629292,
    '-20.183035',
    '57.469663',
    '1'
  ),
  (
    9,
    3,
    1629629293,
    '-20.183035',
    '57.469663',
    '1'
  ),
  (
    10,
    4,
    1629629291,
    '-20.160839',
    '57.497987',
    '1'
  ),
  (
    11,
    4,
    1629629292,
    '-20.160839',
    '57.497987',
    '1'
  ),
  (
    12,
    4,
    1629629293,
    '-20.160839',
    '57.497987',
    '1'
  ),
  (
    13,
    5,
    1629629291,
    '-20.405418',
    '57.709455',
    '1'
  ),
  (
    14,
    5,
    1629629292,
    '-20.405418',
    '57.709455',
    '1'
  ),
  (
    15,
    5,
    1629629293,
    '-20.405418',
    '57.709455',
    '1'
  ),
  (
    16,
    6,
    1629629291,
    '-20.160839',
    '57.497987',
    '1'
  ),
  (
    17,
    6,
    1629629292,
    '-20.160839',
    '57.497987',
    '1'
  ),
  (
    18,
    6,
    1629629293,
    '-20.160839',
    '57.497987',
    '1'
  ),
  (
    19,
    7,
    1629629291,
    '-20.160839',
    '57.497987',
    '1'
  ),
  (
    20,
    7,
    1629629292,
    '-20.160839',
    '57.497987',
    '1'
  ),
  (
    21,
    7,
    1629629293,
    '-20.160839',
    '57.497987',
    '1'
  ),
  (
    22,
    8,
    1629629288,
    '-20.160839',
    '57.497987',
    '1'
  ),
  (
    23,
    8,
    1629629289,
    '-20.160839',
    '57.497987',
    '1'
  ),
  (
    24,
    8,
    1629629290,
    '-20.160839',
    '57.497987',
    '1'
  ),
  (
    25,
    8,
    1629629291,
    '-20.183035',
    '57.469663',
    '1'
  ),
  (
    26,
    8,
    1629629292,
    '-20.183035',
    '57.469663',
    '1'
  ),
  (
    27,
    8,
    1629629293,
    '-20.183035',
    '57.469663',
    '1'
  ),
  (
    28,
    8,
    1629629294,
    '-20.160839',
    '57.497987',
    '1'
  ),
  (
    29,
    8,
    1629629295,
    '-20.160839',
    '57.497987',
    '1'
  ),
  (
    30,
    8,
    1629629296,
    '-20.160839',
    '57.497987',
    '1'
  );

-- create stored procedure
DELIMITER / / CREATE PROCEDURE GETUSERINFO(IN email VARCHAR(255)) BEGIN
SELECT
  u.email,
  u.firstName,
  u.lastName,
  u.dateOfBirth,
  u.address,
  GROUP_CONCAT(DISTINCT m.mobileNumber SEPARATOR '\n') AS mobiles
FROM
  `User` u
  INNER JOIN `Mobile` m ON u.email = m.email
WHERE
  u.email = email;

END;

/ / DELIMITER;