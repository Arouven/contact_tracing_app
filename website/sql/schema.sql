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