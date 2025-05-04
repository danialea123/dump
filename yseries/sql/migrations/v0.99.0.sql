CREATE TABLE IF NOT EXISTS `yphone_promo_hub_posts` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `phone_imei` VARCHAR(255) NOT NULL,
    `contact_number` VARCHAR(15) NOT NULL,
    `contact_name` VARCHAR(50) NOT NULL,

    `title` VARCHAR(50) NOT NULL,
    `description` VARCHAR(1000) NOT NULL,
    `attachments` TEXT DEFAULT NULL,
    `price` VARCHAR(255) NOT NULL,

    `archived` BOOLEAN NOT NULL DEFAULT FALSE,

    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`phone_imei`) REFERENCES `yphone_devices`(`imei`) ON DELETE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

ALTER TABLE `yphone_devices` ADD COLUMN `damage` VARCHAR(255);
