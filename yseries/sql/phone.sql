CREATE TABLE IF NOT EXISTS `yphone_metadata` (
    -- A table to hold data about the database version and handle automatic migrations during updates.
    `dbVersion` VARCHAR(10) NOT NULL,
    `lastUpdate` TIMESTAMP NOT NULL,
    `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY (`dbVersion`)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- * General
CREATE TABLE IF NOT EXISTS `yphone_settings`(
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `phone_imei` VARCHAR(255) NOT NULL,
    `pin` VARCHAR(4),
    -- Used as identifier for fingerprint and face recognition
    `citizen_id` VARCHAR(255),
    `fingerprint` BOOLEAN NOT NULL DEFAULT 0,
    `face_recognition` BOOLEAN NOT NULL DEFAULT 0,
    `auto_lock_timeout` INT NOT NULL DEFAULT 0,
    `scale` VARCHAR(255) NOT NULL DEFAULT 1,
    `homescreen_wallpaper` VARCHAR(255),
    `lockscreen_wallpaper` VARCHAR(255),
    `type` VARCHAR(255) NOT NULL,
    `theme` VARCHAR(255) NOT NULL DEFAULT 'light',
    `language` VARCHAR(255) NOT NULL DEFAULT 'en',
    `volume` INT NOT NULL DEFAULT 50,
    `brightness` INT NOT NULL DEFAULT 100,
    `sound` VARCHAR(255) NOT NULL DEFAULT 'sound',
    `ringtone` VARCHAR(255) NULL,
    `notification` VARCHAR(255) NULL,
    `streamer_mode` BOOLEAN NOT NULL DEFAULT FALSE,
    `do_not_disturb` BOOLEAN NOT NULL DEFAULT FALSE,
    `airplane` BOOLEAN NOT NULL DEFAULT FALSE,
    `quickshare` BOOLEAN NOT NULL DEFAULT TRUE,
    `hide_caller_id` BOOLEAN NOT NULL DEFAULT FALSE,
    `notifications` LONGTEXT,
    `apps` LONGTEXT,
    `metadata` VARCHAR(4069) NOT NULL DEFAULT ''
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `yphone_devices` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    -- * A unique identifier of the phone. If Config.Item.UniquePhones is true `imei` will be generated. Otherwise, player identifier will be used.
    `imei` VARCHAR(255) NOT NULL,
    -- * If the phone has any lock method enabled (pin, fingerprint, face recognition).
    `lock` BOOLEAN DEFAULT FALSE,
    -- * The settings id of the phone in `yphone_settings`.
    `settings_id` INT,
    -- * If the phone has been setup.
    `is_setup` BOOLEAN DEFAULT FALSE,
    -- * The phone's operating system.
    `os` VARCHAR(255) NOT NULL,
    UNIQUE KEY (`imei`),
    FOREIGN KEY (`settings_id`) REFERENCES `yphone_settings`(`id`) ON DELETE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `yphone_sim_cards` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `phone_imei` VARCHAR(255) NOT NULL,
    `sim_number` VARCHAR(20) NOT NULL,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`phone_imei`) REFERENCES `yphone_devices`(`imei`) ON DELETE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `yphone_holders` (
    `holder_identifier` VARCHAR(100) NOT NULL,
    `phone_imei` VARCHAR(255) NOT NULL,
    PRIMARY KEY (`holder_identifier`) 
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- * General
-- * Gallery
CREATE TABLE IF NOT EXISTS `yphone_gallery` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `phone_imei` VARCHAR(255) NOT NULL,
    `image` VARCHAR(4096) NOT NULL,
    `thumbnail` VARCHAR(4096) NULL,
    `date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (`phone_imei`) REFERENCES `yphone_devices`(`imei`) ON DELETE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- * Gallery
-- * Phone
CREATE TABLE IF NOT EXISTS `yphone_contacts` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `phone_imei` VARCHAR(255) NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    `number` VARCHAR(20) NOT NULL,
    `favorite` BOOLEAN NOT NULL DEFAULT 0,
    FOREIGN KEY (`phone_imei`) REFERENCES `yphone_devices`(`imei`) ON DELETE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `yphone_blocked_numbers` (
    `phone_imei` VARCHAR(255) NOT NULL,
    -- the phone imei of the person who blocked the number
    `blocked_number` VARCHAR(15) NOT NULL,
    -- the phone number that was blocked
    PRIMARY KEY (`phone_imei`, `blocked_number`)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `yphone_recents` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `target_number` VARCHAR(255) NULL,
    `phone_imei` VARCHAR(255) NOT NULL,
    `date` TIMESTAMP NULL DEFAULT current_timestamp(),
    `call_type` VARCHAR(255) NOT NULL,
    FOREIGN KEY (`phone_imei`) REFERENCES `yphone_devices`(`imei`) ON DELETE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- * Phone
-- * Cloud(Backups)
CREATE TABLE IF NOT EXISTS `yphone_ycloud_accounts` (
    `phone_imei` VARCHAR(255) NOT NULL,
    `phone_number` VARCHAR(20) NULL,
    `username` VARCHAR(255) NOT NULL,
    `phone_name` VARCHAR(255) NOT NULL,
    `avatar` VARCHAR(4096) NULL,
    `password` VARCHAR(255) NOT NULL,
    `synced_imei` VARCHAR(255) NULL,
    `last_sync` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`username`),
    FOREIGN KEY (`phone_imei`) REFERENCES `yphone_devices`(`imei`) ON DELETE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `yphone_ycloud_loggedin` (
    `phone_imei` VARCHAR(255) NOT NULL,
    `username` VARCHAR(20) NOT NULL,
    PRIMARY KEY (`phone_imei`),
    FOREIGN KEY (`phone_imei`) REFERENCES `yphone_devices`(`imei`) ON DELETE CASCADE,
    FOREIGN KEY (`username`) REFERENCES `yphone_ycloud_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- * Cloud(Backups)s
-- * Twitter(Y)
CREATE TABLE IF NOT EXISTS `yphone_twitter_accounts` (
    `display_name` VARCHAR(30) NOT NULL,
    `username` VARCHAR(20) NOT NULL,
    `password` VARCHAR(100) NOT NULL,
    `phone_imei` VARCHAR(255) NOT NULL,
    `bio` VARCHAR(200) DEFAULT NULL,
    `profile_image` VARCHAR(4096) DEFAULT NULL,
    `profile_header` VARCHAR(4096) DEFAULT NULL,
    `pinned_tweet` VARCHAR(50) DEFAULT NULL,
    `verified` BOOLEAN DEFAULT FALSE,
    `follower_count` INT(11) NOT NULL DEFAULT 0,
    `following_count` INT(11) NOT NULL DEFAULT 0,
    `date_joined` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`username`)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `yphone_twitter_follows` (
    `followed` VARCHAR(20) NOT NULL,
    -- the person followed, matches to `username` in yphone_twitter_accounts
    `follower` VARCHAR(20) NOT NULL,
    -- the person following, matches to `username` in yphone_twitter_accounts
    `notifications` BOOLEAN NOT NULL DEFAULT FALSE,
    -- if the follower gets notifications from the followed
    PRIMARY KEY (`followed`, `follower`),
    FOREIGN KEY (`followed`) REFERENCES `yphone_twitter_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`follower`) REFERENCES `yphone_twitter_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `yphone_twitter_tweets` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `username` VARCHAR(20) NOT NULL,
    -- the person who tweeted, matches to `username` in yphone_twitter_accounts
    `content` VARCHAR(280),
    `attachments` TEXT,
    -- json array of attachments
    `reply_to` VARCHAR(50) DEFAULT NULL,
    -- the tweet / reply this tweet / reply was a reply to
    `like_count` INT(11) DEFAULT 0,
    `reply_count` INT(11) DEFAULT 0,
    `retweet_count` INT(11) DEFAULT 0,
    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`username`) REFERENCES `yphone_twitter_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `yphone_twitter_likes` (
    `tweet_id` VARCHAR(50) NOT NULL,
    `username` VARCHAR(20) NOT NULL,
    -- the person who liked the tweet / reply, matches to `username` in phone_twitter_accounts
    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`tweet_id`, `username`),
    FOREIGN KEY (`username`) REFERENCES `yphone_twitter_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `yphone_twitter_loggedin` (
    `phone_imei` VARCHAR(255) NOT NULL,
    `username` VARCHAR(20) NOT NULL,
    PRIMARY KEY (`phone_imei`),
    FOREIGN KEY (`phone_imei`) REFERENCES `yphone_devices`(`imei`) ON DELETE CASCADE,
    FOREIGN KEY (`username`) REFERENCES `yphone_twitter_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `yphone_twitter_hashtags` (
    `hashtag` VARCHAR(50) NOT NULL,
    `amount` INT NOT NULL DEFAULT 0,
    `last_used` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`hashtag`)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `yphone_twitter_retweets` (
    `tweet_id` VARCHAR(50) NOT NULL,
    `username` VARCHAR(20) NOT NULL,
    -- the person who retweeted the tweet / reply, matches to `username` in yphone_twitter_accounts
    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`tweet_id`, `username`),
    FOREIGN KEY (`username`) REFERENCES `yphone_twitter_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE -- no foreign key on tweet_id as it should still show in the feed, even if the tweet is deleted
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `yphone_twitter_messages` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `sender` VARCHAR(20) NOT NULL,
    -- the person who sent the message, matches to `username` in yphone_twitter_accounts
    `recipient` VARCHAR(20) NOT NULL,
    -- the person who received the message, matches to `username` in yphone_twitter_accounts
    `content` VARCHAR(1000),
    `attachments` TEXT,
    -- json array of attachments
    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`sender`) REFERENCES `yphone_twitter_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`recipient`) REFERENCES `yphone_twitter_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `yphone_twitter_notifications` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `username` VARCHAR(20) NOT NULL,
    `from` VARCHAR(20) NOT NULL,
    -- like, comment, follow  
    `type` VARCHAR(20) NOT NULL,
    `attachments` LONGTEXT,
    -- the post / comment this notification is about
    `post_id` INT DEFAULT NULL,
    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`username`) REFERENCES `yphone_twitter_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`from`) REFERENCES `yphone_twitter_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- * Twitter(Y)
-- * Notes
CREATE TABLE IF NOT EXISTS `yphone_notes` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `phone_imei` VARCHAR(255) NOT NULL,
    `title` VARCHAR(50) NOT NULL,
    `content` LONGTEXT,
    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`phone_imei`) REFERENCES `yphone_devices`(`imei`) ON DELETE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- * Notes
-- * Companies
CREATE TABLE IF NOT EXISTS `yphone_companies_channels` (
    `id` VARCHAR(50) NOT NULL,
    `phone_imei` VARCHAR(255) NOT NULL,
    `company` VARCHAR(50) NOT NULL,
    `phone_number` VARCHAR(20) NULL,
    `last_message` VARCHAR(100) DEFAULT NULL,
    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `yphone_companies_messages` (
    `id` VARCHAR(50) NOT NULL,
    `channel_id` VARCHAR(50) NOT NULL,
    -- phone_imei or company(job)
    `sender` VARCHAR(255) NOT NULL,
    `message` VARCHAR(1000) NOT NULL,
    `x_pos` INT(11) DEFAULT NULL,
    `y_pos` INT(11) DEFAULT NULL,
    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`channel_id`) REFERENCES `yphone_companies_channels`(`id`) ON DELETE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- * Companies
-- * Messages
CREATE TABLE IF NOT EXISTS `yphone_messages_channels` (
    `channel_id` VARCHAR(50) NOT NULL,
    `is_group` BOOLEAN NOT NULL DEFAULT FALSE,
    `name` VARCHAR(50) DEFAULT NULL,
    `last_message` VARCHAR(255) NOT NULL DEFAULT '',
    `last_message_timestamp` DATETIME(3) NOT NULL DEFAULT current_timestamp(3) ON UPDATE current_timestamp(3),
    PRIMARY KEY (`channel_id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `yphone_messages_messages` (
    `id` INT AUTO_INCREMENT,
    `channel_id` VARCHAR(50) NOT NULL,
    `sender_imei` VARCHAR(255) NOT NULL,
    `sender` VARCHAR(15) NOT NULL,
    `content` VARCHAR(1000) DEFAULT NULL,
    `attachments` TEXT DEFAULT NULL,
    `timestamp` DATETIME(3) NOT NULL DEFAULT current_timestamp(3),
    PRIMARY KEY (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `yphone_messages_members` (
    `channel_id` VARCHAR(50) NOT NULL,
    `phone_number` VARCHAR(15) NOT NULL,
    `is_owner` BOOLEAN NOT NULL DEFAULT FALSE,
    `deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    `unread` INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (`channel_id`, `phone_number`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- * Messages
-- * Clock(Alarms)
CREATE TABLE IF NOT EXISTS `yphone_clock_alarms` (
    `id` INT AUTO_INCREMENT,
    `phone_imei` VARCHAR(255) NOT NULL,
    `hours` INT(2) NOT NULL DEFAULT 0,
    `minutes` INT(2) NOT NULL DEFAULT 0,
    `name` VARCHAR(50) NULL,
    `repeat` TEXT DEFAULT NULL,
    `local` BOOLEAN NOT NULL DEFAULT FALSE,
    `enabled` BOOLEAN DEFAULT TRUE,
    `created_on` DATETIME(3) NOT NULL DEFAULT current_timestamp(3),
    PRIMARY KEY (`id`, `phone_imei`),
    FOREIGN KEY (`phone_imei`) REFERENCES `yphone_devices`(`imei`) ON DELETE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- * Clock(Alarms)
-- * Maps
CREATE TABLE IF NOT EXISTS `yphone_maps_locations` (
    `id` INT AUTO_INCREMENT,
    `phone_imei` VARCHAR(255) NOT NULL,
    `name` VARCHAR(50) NOT NULL,
    `x` FLOAT NOT NULL,
    `y` FLOAT NOT NULL,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`phone_imei`) REFERENCES `yphone_devices`(`imei`) ON DELETE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- * Maps
-- * Banking
CREATE TABLE IF NOT EXISTS `yphone_banking_transactions` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `sender_number` VARCHAR(15) NOT NULL,
    `recipient_number` VARCHAR(15) NOT NULL,
    `amount` INT(11) NOT NULL,
    `reason` VARCHAR(50) NOT NULL,
    -- 'pending', 'completed', 'failed'
    `status` VARCHAR(50) NOT NULL,
    `type` VARCHAR(50) NOT NULL,
    -- 'transfer', 'request'
    `timestamp` DATETIME(3) NOT NULL DEFAULT current_timestamp(3) ON UPDATE current_timestamp(3),
    PRIMARY KEY (`id`)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- * Banking
-- * Email
CREATE TABLE IF NOT EXISTS `yphone_mails` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `timestamp` DATETIME(3) NOT NULL DEFAULT current_timestamp(3),
    `title` VARCHAR(255) NOT NULL,
    `content` TEXT NOT NULL,
    `phone_imei` VARCHAR(255) NOT NULL,
    `attachments` LONGTEXT,
    `actions` LONGTEXT,
    `is_read` BOOLEAN DEFAULT FALSE,
    `sender` VARCHAR(255) NOT NULL,
    `sender_display_name` VARCHAR(255),
    PRIMARY KEY (`id`),
    FOREIGN KEY (`phone_imei`) REFERENCES `yphone_devices`(`imei`) ON DELETE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- * Email
-- * YBuy
CREATE TABLE IF NOT EXISTS `yphone_ybuy_ads` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `timestamp` DATETIME(3) NOT NULL DEFAULT current_timestamp(3),
    `title` VARCHAR(255) NOT NULL,
    `description` VARCHAR(1000),
    `category` VARCHAR(255) NOT NULL,
    `price` VARCHAR(255) NOT NULL,
    `contact_name` VARCHAR(255) NOT NULL,
    `phone_number` VARCHAR(255) NOT NULL,
    `allow_messages` BOOLEAN DEFAULT FALSE,
    `allow_calls` BOOLEAN DEFAULT FALSE,
    `attachments` LONGTEXT,
    `phone_imei` VARCHAR(255) NOT NULL,
    `archived` BOOLEAN DEFAULT FALSE,
    `last_renew` DATETIME(3) NOT NULL DEFAULT current_timestamp(3),
    PRIMARY KEY (`id`),
    FOREIGN KEY (`phone_imei`) REFERENCES `yphone_devices`(`imei`) ON DELETE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `yphone_ybuy_favorites` (
    `ad_id` INT(11) NOT NULL AUTO_INCREMENT,
    `phone_imei` VARCHAR(255) NOT NULL,
    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`ad_id`, `phone_imei`),
    FOREIGN KEY (`phone_imei`) REFERENCES `yphone_devices`(`imei`) ON DELETE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- * YBuy
-- * Instashots
CREATE TABLE IF NOT EXISTS `yphone_instashots_accounts` (
    `display_name` VARCHAR(30) NOT NULL,
    `username` VARCHAR(20) NOT NULL,
    `password` VARCHAR(100) NOT NULL,
    -- `phone_imei` VARCHAR(255) NOT NULL,
    `bio` VARCHAR(200) DEFAULT NULL,
    `profile_image` VARCHAR(4096) DEFAULT NULL,
    `verified` BOOLEAN DEFAULT FALSE,
    `private` BOOLEAN DEFAULT FALSE,
    `follower_count` INT(11) NOT NULL DEFAULT 0,
    `following_count` INT(11) NOT NULL DEFAULT 0,
    `story_count` INT(11) NOT NULL DEFAULT 0,
    `posts_count` INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (`username`)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `yphone_instashots_follows` (
    `followed` VARCHAR(20) NOT NULL,
    -- the person followed, matches to `username` in yphone_instashots_accounts
    `follower` VARCHAR(20) NOT NULL,
    -- the person following, matches to `username` in yphone_instashots_accounts
    `notifications` BOOLEAN NOT NULL DEFAULT FALSE,
    -- if the follower gets notifications from the followed
    PRIMARY KEY (`followed`, `follower`),
    FOREIGN KEY (`followed`) REFERENCES `yphone_instashots_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`follower`) REFERENCES `yphone_instashots_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `yphone_instashots_posts` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    -- the person who posted, matches to `username` in yphone_instashots_accounts
    `username` VARCHAR(20) NOT NULL,
    `caption` VARCHAR(280),
    -- json array of attachments
    `attachments` LONGTEXT,
    `like_count` INT(11) DEFAULT 0,
    `comment_count` INT(11) DEFAULT 0,
    `archived` BOOLEAN NOT NULL DEFAULT FALSE,
    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`username`) REFERENCES `yphone_instashots_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `yphone_instashots_likes` (
    `post_id` VARCHAR(50) NOT NULL,
    `username` VARCHAR(20) NOT NULL,
    `is_comment` BOOLEAN NOT NULL DEFAULT FALSE,
    -- the person who liked the post matches to `username` in phone_instashots_accounts
    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`post_id`, `username`),
    FOREIGN KEY (`username`) REFERENCES `yphone_instashots_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `yphone_instashots_loggedin` (
    `phone_imei` VARCHAR(255) NOT NULL,
    `username` VARCHAR(20) NOT NULL,
    PRIMARY KEY (`phone_imei`),
    FOREIGN KEY (`phone_imei`) REFERENCES `yphone_devices`(`imei`) ON DELETE CASCADE,
    FOREIGN KEY (`username`) REFERENCES `yphone_instashots_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `yphone_instashots_hashtags` (
    `hashtag` VARCHAR(50) NOT NULL,
    `amount` INT NOT NULL DEFAULT 0,
    `last_used` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`hashtag`)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `yphone_instashots_comments`(
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `post_id` INT NOT NULL,
    -- the post this comment was made on, matches to `id` in yphone_instashots_posts
    `username` VARCHAR(20) NOT NULL,
    -- the person who commented, matches to `username` in yphone_instashots_accounts
    `comment` VARCHAR(500) NOT NULL DEFAULT "",
    `like_count` INT(11) NOT NULL DEFAULT 0,
    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(`post_id`) REFERENCES `yphone_instashots_posts`(`id`) ON DELETE CASCADE,
    FOREIGN KEY(`username`) REFERENCES `yphone_instashots_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `yphone_instashots_notifications` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `username` VARCHAR(20) NOT NULL,
    `from` VARCHAR(20) NOT NULL,
    -- like, comment, follow  
    `type` VARCHAR(20) NOT NULL,
    `attachments` LONGTEXT,
    -- the post / comment this notification is about
    `post_id` INT DEFAULT NULL,
    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`username`) REFERENCES `yphone_instashots_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`from`) REFERENCES `yphone_instashots_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `yphone_instashots_stories` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `username` VARCHAR(20) NOT NULL,
    `attachments` LONGTEXT,
    `archived` BOOLEAN NOT NULL DEFAULT FALSE,
    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`username`) REFERENCES `yphone_instashots_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `yphone_instashots_stories_views` (
    `story_id` INT NOT NULL,
    `viewer` VARCHAR(20) NOT NULL,
    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`story_id`, `viewer`),
    FOREIGN KEY (`story_id`) REFERENCES `yphone_instashots_stories`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`viewer`) REFERENCES `yphone_instashots_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `yphone_instashots_messages` (
    `id` INT AUTO_INCREMENT,
    `sender` VARCHAR(20) NOT NULL,
    -- the person who sent the message, matches to `username` in yphone_instashots_accounts
    `recipient` VARCHAR(20) NOT NULL,
    -- the person who received the message, matches to `username` in phone_instashots_accounts
    `content` VARCHAR(1000),
    `attachments` TEXT,
    -- json array of attachments
    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`sender`) REFERENCES `yphone_instashots_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`recipient`) REFERENCES `yphone_instashots_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- * Instashots
-- * DarkChat
CREATE TABLE IF NOT EXISTS `yphone_darkchat_accounts` (
    `username` VARCHAR(20) NOT NULL,
    `display_name` VARCHAR(30) NOT NULL,
    `password` VARCHAR(50) NOT NULL,
    `profile_image` VARCHAR(4096) DEFAULT NULL,
    PRIMARY KEY (`username`)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `yphone_darkchat_loggedin` (
    `phone_imei` VARCHAR(255) NOT NULL,
    `username` VARCHAR(20) NOT NULL,
    PRIMARY KEY (`phone_imei`),
    FOREIGN KEY (`phone_imei`) REFERENCES `yphone_devices`(`imei`) ON DELETE CASCADE,
    FOREIGN KEY (`username`) REFERENCES `yphone_darkchat_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `yphone_darkchat_channels` (
    `name` VARCHAR(50) NOT NULL,
    `password` VARCHAR(50) DEFAULT NULL,
    `last_message` VARCHAR(100) DEFAULT NULL,
    `profile_picture` VARCHAR(4096) DEFAULT NULL,
    `anonymous` BOOLEAN DEFAULT FALSE,
    `owner` VARCHAR(20) NOT NULL,
    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`name`),
    FOREIGN KEY (`owner`) REFERENCES `yphone_darkchat_accounts`(`username`) ON DELETE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `yphone_darkchat_members` (
    `channel_name` VARCHAR(50) NOT NULL,
    `muted` BOOLEAN DEFAULT FALSE,
    `username` VARCHAR(20) NOT NULL,
    PRIMARY KEY (`channel_name`, `username`),
    FOREIGN KEY (`username`) REFERENCES `yphone_darkchat_accounts`(`username`) ON DELETE CASCADE,
    FOREIGN KEY (`channel_name`) REFERENCES `yphone_darkchat_channels`(`name`) ON DELETE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `yphone_darkchat_messages` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `channel` VARCHAR(50) NOT NULL,
    `sender` VARCHAR(20) NOT NULL,
    `content` VARCHAR(1000),
    `attachments` TEXT DEFAULT NULL,
    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`sender`) REFERENCES `yphone_darkchat_accounts`(`username`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`channel`) REFERENCES `yphone_darkchat_channels`(`name`) ON DELETE CASCADE ON UPDATE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Insert the default user for channel ownership
INSERT IGNORE INTO `yphone_darkchat_accounts` (`username`, `display_name`, `password`)
VALUES ('darkchat', 'Dark Chat', 'gT00746f&76"');

-- Insert the default channel 'general' with 'darkchat' as the owner
INSERT IGNORE INTO `yphone_darkchat_channels` (`name`, `owner`)
VALUES ('general', 'darkchat');

-- * DarkChat
-- * Promo Hub 
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

-- * Promo Hub