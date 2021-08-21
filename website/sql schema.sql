-- CREATING TABLES
CREATE TABLE `User` (
  `userId` BIGINT NOT NULL AUTO_INCREMENT,
  `firstName` VARCHAR(255) NOT NULL,
  `lastName` VARCHAR(255) NOT NULL,
  `country` VARCHAR(255) NOT NULL,
  `address` VARCHAR(255) NOT NULL,
  `telephone` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `dateOfBirth` DATE NOT NULL,
  `nationalIdNumber` VARCHAR(255) NOT NULL,
  `username` VARCHAR(255) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`userId`)
);

CREATE TABLE `Mobile` (
  `mobileId` BIGINT NOT NULL AUTO_INCREMENT,
  `userId` BIGINT NOT NULL,
  `mobileName` VARCHAR(255) NOT NULL,
  `contactWithInfected` BOOLEAN NOT NULL DEFAULT FALSE,
  `potential` BOOLEAN NOT NULL DEFAULT FALSE,
  `performCovidTest` BOOLEAN NOT NULL DEFAULT FALSE,
  `confirmInfected` BOOLEAN NOT NULL DEFAULT FALSE,
  PRIMARY KEY (`mobileId`),
  FOREIGN KEY (`userId`) REFERENCES `User`(`userId`)
);

CREATE TABLE `Coordinates` (
  `coordinatesId` BIGINT NOT NULL AUTO_INCREMENT,
  `mobileId` BIGINT NOT NULL,
  `dateTimeEpoch` VARCHAR(255) NOT NULL,
  `latitude` VARCHAR(255) NOT NULL,
  `longitude` VARCHAR(255) NOT NULL,
  `accuracy` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`coordinatesId`),
  FOREIGN KEY (`mobileId`) REFERENCES `Mobile`(`mobileId`)
);

CREATE TABLE `Search` (
  `searchId` BIGINT NOT NULL AUTO_INCREMENT,
  `potential` VARCHAR(255) NOT NULL,
  `infected` VARCHAR(255) NOT NULL,
  `days` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`searchId`)
);

CREATE TABLE `Testing` (
  `testingId` BIGINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `address` VARCHAR(255) NOT NULL,
  `latitude` VARCHAR(255) NOT NULL,
  `longitude` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`testingId`)
);

-- INSERTING TABLES
INSERT INTO
  `Search` (potential, infected)
VALUES
  ('10', '2');

INSERT INTO
  `Testing` (
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
  );

INSERT INTO
  `User` (
    firstName,
    lastName,
    country,
    address,
    telephone,
    email,
    dateOfBirth,
    nationalIdNumber,
    username,
    password
  )
VALUES
  (
    'John',
    'Smith',
    'Mauritius',
    'Port-Louis',
    '654654652',
    'JohnSmith@gmail.com',
    '2000-01-13',
    'J6465516549846513',
    'Johny',
    '1234'
  );

INSERT INTO
  `User` (
    firstName,
    lastName,
    country,
    address,
    telephone,
    email,
    dateOfBirth,
    nationalIdNumber,
    username,
    password
  )
VALUES
  (
    'James',
    'Smith',
    'Mauritius',
    'Port-Louis',
    '564654654',
    'JamesSmith@gmail.com',
    '2000-01-13',
    'J6465516549846523',
    'JamesSmith',
    '1234'
  );