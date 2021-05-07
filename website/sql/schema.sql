CREATE TABLE `Coordinates` (
  `coordinatesId` int(11) NOT NULL,
  `userId` int(8) NOT NULL,
  `dateTime` varchar(55) NOT NULL,
  `latitude` varchar(55) NOT NULL,
  `longitude` varchar(255) NOT NULL,
  `accuracy` varchar(255) NOT NULL
);


ALTER TABLE `Coordinates`
  ADD PRIMARY KEY (`coordinatesId`);


ALTER TABLE `Coordinates`
  MODIFY `coordinatesId` int(11) NOT NULL AUTO_INCREMENT;