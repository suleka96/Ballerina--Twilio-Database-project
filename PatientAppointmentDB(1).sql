-- phpMyAdmin SQL Dump
-- version 4.8.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Jul 09, 2018 at 06:40 AM
-- Server version: 10.1.33-MariaDB
-- PHP Version: 7.2.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `PatientAppointmentDB`
--

-- --------------------------------------------------------

--
-- Table structure for table `AppointmentInfo`
--

CREATE TABLE `AppointmentInfo` (
  `AppointmentId` varchar(11) NOT NULL,
  `AppointmentDate` varchar(10) DEFAULT NULL,
  `ArrivalTime` varchar(5) DEFAULT NULL,
  `NameOfDocor` varchar(50) DEFAULT NULL,
  `PatientId` varchar(11) DEFAULT NULL,
  `MsgStatus` varchar(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `AppointmentInfo`
--

INSERT INTO `AppointmentInfo` (`AppointmentId`, `AppointmentDate`, `ArrivalTime`, `NameOfDocor`, `PatientId`, `MsgStatus`) VALUES
('1', '09-07-2018', '18:00', 'Sam Wiop', '1', 'sent'),
('2', '09-07-2018', '18:30', 'Lisa marie', '2', 'sent');

-- --------------------------------------------------------

--
-- Table structure for table `PatientInfo`
--

CREATE TABLE `PatientInfo` (
  `PatientId` varchar(11) NOT NULL,
  `PatientName` varchar(50) NOT NULL,
  `PatientTelephoneNo` varchar(12) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `PatientInfo`
--

INSERT INTO `PatientInfo` (`PatientId`, `PatientName`, `PatientTelephoneNo`) VALUES
('1', 'Kith Bren', '+94727321271'),
('2', 'Anna Sole', '+94761600699');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `AppointmentInfo`
--
ALTER TABLE `AppointmentInfo`
  ADD PRIMARY KEY (`AppointmentId`),
  ADD KEY `FK_Appointment` (`PatientId`);

--
-- Indexes for table `PatientInfo`
--
ALTER TABLE `PatientInfo`
  ADD PRIMARY KEY (`PatientId`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `AppointmentInfo`
--
ALTER TABLE `AppointmentInfo`
  ADD CONSTRAINT `FK_Appointment` FOREIGN KEY (`PatientId`) REFERENCES `PatientInfo` (`PatientId`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
