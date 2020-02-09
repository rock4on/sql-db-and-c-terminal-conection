-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Feb 09, 2020 at 01:16 PM
-- Server version: 5.7.24
-- PHP Version: 7.2.14

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `Proiect_bd`
--

-- --------------------------------------------------------

--
-- Table structure for table `card`
--

CREATE TABLE `card` (
  `id_card` int(11) NOT NULL,
  `numar_card` int(11) NOT NULL,
  `pin_card` varchar(7) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `card`
--

INSERT INTO `card` (`id_card`, `numar_card`, `pin_card`) VALUES
(1, 435443423, '1234'),
(2, 3232453, '1234');

--
-- Triggers `card`
--
DELIMITER $$
CREATE TRIGGER `del_card` BEFORE DELETE ON `card` FOR EACH ROW BEGIN
UPDATE comanda set id_card=null WHERE id_card = old.id_card;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `comanda`
--

CREATE TABLE `comanda` (
  `id_comanda` int(11) NOT NULL,
  `id_cos` int(11) NOT NULL,
  `id_locatie` int(11) DEFAULT NULL,
  `id_curier` int(11) DEFAULT NULL,
  `id_card` int(11) DEFAULT NULL,
  `data` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `comanda`
--

INSERT INTO `comanda` (`id_comanda`, `id_cos`, `id_locatie`, `id_curier`, `id_card`, `data`) VALUES
(1, 1, 1, 1, 1, '2020-01-12'),
(2, 2, 2, 1, 2, '2020-01-13');

-- --------------------------------------------------------

--
-- Table structure for table `contine`
--

CREATE TABLE `contine` (
  `id_cos` int(11) NOT NULL,
  `id_produs` int(11) NOT NULL,
  `cantitate` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `contine`
--

INSERT INTO `contine` (`id_cos`, `id_produs`, `cantitate`) VALUES
(3, 1, 4),
(3, 4, 2);

--
-- Triggers `contine`
--
DELIMITER $$
CREATE TRIGGER `upd_cost` AFTER INSERT ON `contine` FOR EACH ROW BEGIN
UPDATE cos_cumparaturi set cost=cost+new.cantitate*(SELECT pret FROM produse WHERE id_produs=new.id_produs) WHERE id_cos=new.id_cos ;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `cos_cumparaturi`
--

CREATE TABLE `cos_cumparaturi` (
  `id_cos` int(11) NOT NULL,
  `id_utilizator` int(11) NOT NULL,
  `cost` float NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `cos_cumparaturi`
--

INSERT INTO `cos_cumparaturi` (`id_cos`, `id_utilizator`, `cost`) VALUES
(3, 2, 236);

--
-- Triggers `cos_cumparaturi`
--
DELIMITER $$
CREATE TRIGGER `del` BEFORE DELETE ON `cos_cumparaturi` FOR EACH ROW BEGIN
  DELETE FROM contine WHERE id_cos = old.id_cos;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `Curier`
--

CREATE TABLE `Curier` (
  `id_curier` int(11) NOT NULL,
  `nume` varchar(20) NOT NULL,
  `masina` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Curier`
--

INSERT INTO `Curier` (`id_curier`, `nume`, `masina`) VALUES
(1, 'Marcel Dumitru', 'b-007-jum');

--
-- Triggers `Curier`
--
DELIMITER $$
CREATE TRIGGER `null_curier` BEFORE DELETE ON `Curier` FOR EACH ROW BEGIN
UPDATE comanda set id_curier=null WHERE id_curier = old.id_curier;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `locatie`
--

CREATE TABLE `locatie` (
  `id_locatie` int(11) NOT NULL,
  `adresa` varchar(100) NOT NULL,
  `coordonate` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `locatie`
--

INSERT INTO `locatie` (`id_locatie`, `adresa`, `coordonate`) VALUES
(1, 'Strada Livezilor nr 4 Bucuresti', '44.439663,26.096306'),
(2, 'Strada FLorilor nr 2 Bucuresti', '14.439663,36.096306');

--
-- Triggers `locatie`
--
DELIMITER $$
CREATE TRIGGER `loc_null` BEFORE DELETE ON `locatie` FOR EACH ROW BEGIN
UPDATE comanda set id_locatie=null WHERE id_card = old.id_locatie;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `produse`
--

CREATE TABLE `produse` (
  `id_produs` int(11) NOT NULL,
  `id_restaurant` int(11) DEFAULT NULL,
  `nume_produs` varchar(30) NOT NULL,
  `pret` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `produse`
--

INSERT INTO `produse` (`id_produs`, `id_restaurant`, `nume_produs`, `pret`) VALUES
(1, 1, 'Ciorba-De-Burta', 43),
(2, 1, 'Friptura-De-pui', 5),
(3, 2, 'Ciorba-De-pui', 23),
(4, 2, 'Mamaliga', 32);

-- --------------------------------------------------------

--
-- Table structure for table `restaurant`
--

CREATE TABLE `restaurant` (
  `id_restaurant` int(11) NOT NULL,
  `nume` varchar(30) NOT NULL,
  `raiting` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `restaurant`
--

INSERT INTO `restaurant` (`id_restaurant`, `nume`, `raiting`) VALUES
(1, 'Casa-de-Snitele', 4),
(2, 'Hanul-Ciorbarilor', 5);

--
-- Triggers `restaurant`
--
DELIMITER $$
CREATE TRIGGER `s_null` BEFORE DELETE ON `restaurant` FOR EACH ROW BEGIN
UPDATE produse
set id_restaurant=NULL
WHERE id_restaurant=old.id_restaurant;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `utilizatori`
--

CREATE TABLE `utilizatori` (
  `id_utilizator` int(10) UNSIGNED NOT NULL COMMENT 'Cheia primara',
  `nume` varchar(20) DEFAULT 'no-name' COMMENT 'Nume Utilizator',
  `prenume` varchar(20) DEFAULT 'no-name' COMMENT 'Prenume Utilizator',
  `parola` varchar(30) NOT NULL DEFAULT '1234',
  `email` varchar(50) DEFAULT NULL,
  `telefon` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tabela de utilizatori';

--
-- Dumping data for table `utilizatori`
--

INSERT INTO `utilizatori` (`id_utilizator`, `nume`, `prenume`, `parola`, `email`, `telefon`) VALUES
(2, 'Ion', 'Cristian', 'ion1234', 'ioon@gmail.com', '0793134743'),
(3, 'Ricardo', 'Virgil', '12341234', 'ricardo43@gmail.com', '0793134744');

--
-- Triggers `utilizatori`
--
DELIMITER $$
CREATE TRIGGER `del_user` BEFORE DELETE ON `utilizatori` FOR EACH ROW BEGIN
  DELETE FROM cos_cumparaturi WHERE id_utilizator = old.id_utilizator;
END
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `card`
--
ALTER TABLE `card`
  ADD PRIMARY KEY (`id_card`);

--
-- Indexes for table `comanda`
--
ALTER TABLE `comanda`
  ADD PRIMARY KEY (`id_comanda`);

--
-- Indexes for table `contine`
--
ALTER TABLE `contine`
  ADD PRIMARY KEY (`id_cos`,`id_produs`);

--
-- Indexes for table `cos_cumparaturi`
--
ALTER TABLE `cos_cumparaturi`
  ADD PRIMARY KEY (`id_cos`);

--
-- Indexes for table `Curier`
--
ALTER TABLE `Curier`
  ADD PRIMARY KEY (`id_curier`);

--
-- Indexes for table `locatie`
--
ALTER TABLE `locatie`
  ADD PRIMARY KEY (`id_locatie`);

--
-- Indexes for table `produse`
--
ALTER TABLE `produse`
  ADD PRIMARY KEY (`id_produs`);

--
-- Indexes for table `restaurant`
--
ALTER TABLE `restaurant`
  ADD PRIMARY KEY (`id_restaurant`);

--
-- Indexes for table `utilizatori`
--
ALTER TABLE `utilizatori`
  ADD PRIMARY KEY (`id_utilizator`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `card`
--
ALTER TABLE `card`
  MODIFY `id_card` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `comanda`
--
ALTER TABLE `comanda`
  MODIFY `id_comanda` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `cos_cumparaturi`
--
ALTER TABLE `cos_cumparaturi`
  MODIFY `id_cos` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `Curier`
--
ALTER TABLE `Curier`
  MODIFY `id_curier` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `locatie`
--
ALTER TABLE `locatie`
  MODIFY `id_locatie` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `produse`
--
ALTER TABLE `produse`
  MODIFY `id_produs` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `restaurant`
--
ALTER TABLE `restaurant`
  MODIFY `id_restaurant` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `utilizatori`
--
ALTER TABLE `utilizatori`
  MODIFY `id_utilizator` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Cheia primara', AUTO_INCREMENT=4;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
