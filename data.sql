-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: localhost    Database: sns
-- ------------------------------------------------------
-- Server version	8.0.42

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `fav`
--

DROP TABLE IF EXISTS `fav`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fav` (
  `id` varchar(12) NOT NULL,
  `time` varchar(32) NOT NULL,
  `favid` varchar(12) NOT NULL,
  PRIMARY KEY (`id`,`time`,`favid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fav`
--

LOCK TABLES `fav` WRITE;
/*!40000 ALTER TABLE `fav` DISABLE KEYS */;
INSERT INTO `fav` VALUES ('user24','2025-05-31 17:02:35','test'),('user28','2025-05-31 17:06:35','test'),('user30','2025-05-31 17:08:35','test');
/*!40000 ALTER TABLE `fav` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `follow`
--

DROP TABLE IF EXISTS `follow`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `follow` (
  `follow` varchar(12) NOT NULL,
  `followed` varchar(12) NOT NULL,
  PRIMARY KEY (`follow`,`followed`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `follow`
--

LOCK TABLES `follow` WRITE;
/*!40000 ALTER TABLE `follow` DISABLE KEYS */;
INSERT INTO `follow` VALUES ('test','user11'),('test','user20'),('test','user27'),('test','user28'),('test','user29'),('user01','user03'),('user01','user04'),('user02','user01'),('user02','user05'),('user02','user06'),('user03','user01'),('user03','user07'),('user03','user08'),('user03','user09'),('user04','user01'),('user04','user05'),('user04','user06'),('user05','user07'),('user05','user08'),('user05','user09'),('user06','user01'),('user06','user02'),('user06','user03'),('user06','user10'),('user07','user01'),('user07','user02'),('user07','user03'),('user08','user04'),('user08','user05'),('user08','user06'),('user08','user07'),('user09','user01'),('user09','user02'),('user09','user08'),('user09','user10'),('user10','user03'),('user10','user04'),('user10','user05'),('user10','user06'),('user11','user01'),('user11','user02'),('user11','user03'),('user11','user04'),('user12','user05'),('user12','user06'),('user12','user07'),('user12','user08'),('user13','user09'),('user13','user10'),('user13','user11'),('user13','user12'),('user14','user02'),('user14','user05'),('user14','user08'),('user14','user11'),('user15','user01'),('user15','user04'),('user15','user07'),('user15','user10'),('user16','user03'),('user16','user06'),('user16','user09'),('user16','user12'),('user17','user05'),('user17','user08'),('user17','user11'),('user17','user14'),('user18','user07'),('user18','user10'),('user18','user13'),('user18','user16'),('user19','user01'),('user19','user04'),('user19','user08'),('user19','user12'),('user20','user02'),('user20','user06'),('user20','user10'),('user20','user14'),('user21','user03'),('user21','user07'),('user21','user11'),('user21','user15'),('user22','user05'),('user22','user09'),('user22','user13'),('user22','user17'),('user23','user06'),('user23','user10'),('user23','user14'),('user23','user18'),('user24','user07'),('user24','user11'),('user24','user15'),('user24','user19'),('user25','user08'),('user25','user12'),('user25','user16'),('user25','user20'),('user26','user09'),('user26','user13'),('user26','user17'),('user26','user21'),('user27','user10'),('user27','user14'),('user27','user18'),('user27','user22'),('user28','user11'),('user28','user15'),('user28','user19'),('user28','user23'),('user29','user12'),('user29','user16'),('user29','user20'),('user29','user24'),('user30','user13'),('user30','user17'),('user30','user21'),('user30','user25');
/*!40000 ALTER TABLE `follow` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `message`
--

DROP TABLE IF EXISTS `message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `message` (
  `id` varchar(12) NOT NULL,
  `time` varchar(32) NOT NULL,
  `message` varchar(256) DEFAULT NULL,
  `address` varchar(8) DEFAULT NULL,
  PRIMARY KEY (`id`,`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `message`
--

LOCK TABLES `message` WRITE;
/*!40000 ALTER TABLE `message` DISABLE KEYS */;
INSERT INTO `message` VALUES ('user02','2025-05-31 16:40:35','新しい本を読みました。','all'),('user03','2025-05-31 16:41:35','ランニングしてきました。','all'),('user04','2025-05-31 16:42:35','美味しいラーメンを食べました。','all'),('user05','2025-05-31 16:43:35','旅行に行きたいなぁ。','all'),('user06','2025-05-31 16:44:35','今日は仕事が忙しかった。','all'),('user07','2025-05-31 16:45:35','猫と遊びました。','all'),('user08','2025-05-31 16:46:35','明日が楽しみです。','all'),('user09','2025-05-31 16:47:35','最近早起きしてます。','all'),('user10','2025-05-31 16:48:35','久しぶりに映画を観ました。','all'),('user11','2025-05-31 16:49:35','今日はラッキーなことがあった。','all'),('user12','2025-05-31 16:50:35','勉強が捗った！','all'),('user13','2025-05-31 16:51:35','コーヒーがおいしい。','all'),('user14','2025-05-31 16:52:35','公園でのんびりしてます。','all'),('user15','2025-05-31 16:53:35','料理に挑戦してみた。','all'),('user16','2025-05-31 16:54:35','筋トレ後は気持ちいい。','all'),('user17','2025-05-31 16:55:35','ゲームをクリアしました！','all'),('user18','2025-05-31 16:56:35','新しいアプリを使ってみた。','all'),('user19','2025-05-31 16:57:35','今日の夕焼けがきれいでした。','all'),('user20','2025-05-31 16:58:35','週末の予定を立てています。','all'),('user21','2025-05-31 16:59:35','日記をつけ始めました。','all'),('user22','2025-05-31 17:00:35','明日の会議が不安です。','all'),('user23','2025-05-31 17:01:35','最近DIYにハマってます。','all'),('user24','2025-05-31 17:02:35','早く夏になってほしい！','all'),('user25','2025-05-31 17:03:35','今日も頑張った自分を褒めたい。','all'),('user26','2025-05-31 17:04:35','週末に映画を観る予定。','all'),('user27','2025-05-31 17:05:35','気になる本を見つけました。','all'),('user28','2025-05-31 17:06:35','散歩してリフレッシュ。','all'),('user29','2025-05-31 17:07:35','カフェでゆっくりしてます。','all'),('user30','2025-05-31 17:08:35','今日は良い1日でした。','all');
/*!40000 ALTER TABLE `message` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` varchar(12) NOT NULL,
  `pwd` varchar(12) DEFAULT NULL,
  `name` varchar(12) DEFAULT NULL,
  `comment` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES ('test','test','test',NULL),('user02','pwd02','鈴木花子','よろしくお願いします。'),('user03','pwd03','佐藤健','プログラミングが好きです。'),('user04','pwd04','田中美咲','猫が大好きです。'),('user05','pwd05','高橋優','週末は山登りしてます。'),('user06','pwd06','井上愛','料理が趣味です。'),('user07','pwd07','中村翔','映画を見るのが好き。'),('user08','pwd08','小林悠','フルマラソン完走しました！'),('user09','pwd09','加藤葵','最近読書にハマってます。'),('user10','pwd10','吉田蓮','旅行が好きです。'),('user11','pwd11','斉藤結','お寿司が好きです。'),('user12','pwd12','山口陽','音楽鑑賞が趣味です。'),('user13','pwd13','松本翔','新しい技術に興味あり。'),('user14','pwd14','清水花','毎朝ランニングしてます。'),('user15','pwd15','渡辺真','写真を撮るのが好きです。'),('user16','pwd16','山崎結','温泉巡りしてます。'),('user17','pwd17','森口駿','ラーメン大好き。'),('user18','pwd18','橋本咲','ダンスを習ってます。'),('user19','pwd19','石田光','アニメをよく見ます。'),('user20','pwd20','大野楓','サッカーが趣味です。'),('user21','pwd21','原田蒼','カフェ巡りしてます。'),('user22','pwd22','村上航','ギターを弾いてます。'),('user23','pwd23','今井香','手芸が得意です。'),('user24','pwd24','横山拓','天体観測が趣味。'),('user25','pwd25','大塚陽','自転車が好き。'),('user26','pwd26','竹内優','ジョギングしてます。'),('user27','pwd27','福田莉','イラスト描いてます。'),('user28','pwd28','三浦悠','筋トレしてます。'),('user29','pwd29','柴田凛','紅茶が好きです。'),('user30','pwd30','西村徹','ボードゲームにハマってます。');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-06-01 20:53:11
