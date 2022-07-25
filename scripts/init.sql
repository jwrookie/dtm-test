CREATE DATABASE IF NOT EXISTS dtm
/*!40100 DEFAULT CHARACTER SET utf8mb4 */
;
drop table IF EXISTS dtm.trans_global;
CREATE TABLE if not EXISTS dtm.trans_global (
    `id` bigint(22) NOT NULL AUTO_INCREMENT,
    `gid` varchar(128) NOT NULL COMMENT 'global transaction id',
    `trans_type` varchar(45) not null COMMENT 'transaction type: saga | xa | tcc | msg',
    `status` varchar(12) NOT NULL COMMENT 'tranaction status: prepared | submitted | aborting | finished | rollbacked',
    `query_prepared` varchar(1024) NOT NULL COMMENT 'url to check for msg|workflow',
    `protocol` varchar(45) not null comment 'protocol: http | grpc | json-rpc',
    `create_time` datetime DEFAULT NULL,
    `update_time` datetime DEFAULT NULL,
    `finish_time` datetime DEFAULT NULL,
    `rollback_time` datetime DEFAULT NULL,
    `options` varchar(1024) DEFAULT 'options for transaction like: TimeoutToFail, RequestTimeout',
    `custom_data` varchar(1024) DEFAULT '' COMMENT 'custom data for transaction',
    `next_cron_interval` int(11) default null comment 'next cron interval. for use of cron job',
    `next_cron_time` datetime default null comment 'next time to process this trans. for use of cron job',
    `owner` varchar(128) not null default '' comment 'who is locking this trans',
    `ext_data` TEXT comment 'extended data for this trans',
    `rollback_reason` varchar(1024) DEFAULT '' COMMENT 'rollback reason for transaction',
    PRIMARY KEY (`id`),
    UNIQUE KEY `gid` (`gid`),
    key `owner`(`owner`),
    key `status_next_cron_time` (`status`, `next_cron_time`) comment 'cron job will use this index to query trans'
    ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;
drop table IF EXISTS dtm.trans_branch_op;
CREATE TABLE IF NOT EXISTS dtm.trans_branch_op (
    `id` bigint(22) NOT NULL AUTO_INCREMENT,
    `gid` varchar(128) NOT NULL COMMENT 'global transaction id',
    `url` varchar(1024) NOT NULL COMMENT 'the url of this op',
    `data` TEXT COMMENT 'request body, depreceated',
    `bin_data` BLOB COMMENT 'request body',
    `branch_id` VARCHAR(128) NOT NULL COMMENT 'transaction branch ID',
    `op` varchar(45) NOT NULL COMMENT 'transaction operation type like: action | compensate | try | confirm | cancel',
    `status` varchar(45) NOT NULL COMMENT 'transaction op status: prepared | succeed | failed',
    `finish_time` datetime DEFAULT NULL,
    `rollback_time` datetime DEFAULT NULL,
    `create_time` datetime DEFAULT NULL,
    `update_time` datetime DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `gid_uniq` (`gid`, `branch_id`, `op`)
    ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;
drop table IF EXISTS dtm.kv;
CREATE TABLE IF NOT EXISTS dtm.kv (
    `id` bigint(22) NOT NULL AUTO_INCREMENT,
    `cat` varchar(45) NOT NULL COMMENT 'the category of this data',
    `k` varchar(128) NOT NULL,
    `v` TEXT,
    `version` bigint(22) default 1 COMMENT 'version of the value',
    create_time datetime default NULL,
    update_time datetime DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE key `uniq_k`(`cat`, `k`)
    ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

-- //////////////////////////////////////////// --
create database if not exists dtm_barrier
/*!40100 DEFAULT CHARACTER SET utf8mb4 */
;
drop table if exists dtm_barrier.barrier;
create table if not exists dtm_barrier.barrier(
    id bigint(22) PRIMARY KEY AUTO_INCREMENT,
    trans_type varchar(45) default '',
    gid varchar(128) default '',
    branch_id varchar(128) default '',
    op varchar(45) default '',
    barrier_id varchar(45) default '',
    reason varchar(45) default '' comment 'the branch type who insert this record',
    create_time datetime DEFAULT now(),
    update_time datetime DEFAULT now(),
    key(create_time),
    key(update_time),
    UNIQUE key(gid, branch_id, op, barrier_id)
    ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;
-- //////////////////////////////////////////// --


CREATE database if NOT EXISTS `service_a` default character set utf8mb4 collate utf8mb4_unicode_ci;
use `service_a`;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

CREATE TABLE service_a.a (
    `a_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
    `created_at` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
    `updated_at` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '修改时间',
    `deleted_at` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '删除时间',
    PRIMARY KEY (`a_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='a表';

-- //////////////////////////////////////////// --

CREATE database if NOT EXISTS `service_b` default character set utf8mb4 collate utf8mb4_unicode_ci;
use `service_b`;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

CREATE TABLE service_b.b (
    `b_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
    `created_at` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
    `updated_at` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '修改时间',
    `deleted_at` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '删除时间',
    PRIMARY KEY (`b_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='b表';

