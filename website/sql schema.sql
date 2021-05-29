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
  `password` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`userId`)
);

CREATE TABLE `Mobile` (
  `mobileId` BIGINT NOT NULL AUTO_INCREMENT,
  `userId` BIGINT NOT NULL,
  `mobileName` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`mobileId`),
  FOREIGN KEY (`userId`) REFERENCES `User`(`userId`)
);

CREATE TABLE `Coordinates` (
  `coordinatesId` BIGINT NOT NULL AUTO_INCREMENT,
  `mobileId` BIGINT NOT NULL,
  `dateTime` DATETIME NOT NULL,
  `latitude` VARCHAR(255) NOT NULL,
  `longitude` VARCHAR(255) NOT NULL,
  `accuracy` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`coordinatesId`),
  FOREIGN KEY (`mobileId`) REFERENCES `Mobile`(`mobileId`)
);

-- INSERTING TABLES
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
    'J6465516549846513',
    '1234'
  );