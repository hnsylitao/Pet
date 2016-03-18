/*==============================================================*/
/* DBMS name:      Microsoft SQL Server 2008                    */
/* Created on:     2016/3/18 15:11:04                           */
/*==============================================================*/


if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('log') and o.name = 'FK_LOG_REFERENCE_USER')
alter table log
   drop constraint FK_LOG_REFERENCE_USER
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('log_content') and o.name = 'FK_LOG_CONT_REFERENCE_LOG')
alter table log_content
   drop constraint FK_LOG_CONT_REFERENCE_LOG
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('lose') and o.name = 'FK_LOSE_REFERENCE_USER')
alter table lose
   drop constraint FK_LOSE_REFERENCE_USER
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('lost_content') and o.name = 'FK_LOST_CON_REFERENCE_LOSE')
alter table lost_content
   drop constraint FK_LOST_CON_REFERENCE_LOSE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('log')
            and   type = 'U')
   drop table log
go

if exists (select 1
            from  sysobjects
           where  id = object_id('log_content')
            and   type = 'U')
   drop table log_content
go

if exists (select 1
            from  sysobjects
           where  id = object_id('lose')
            and   type = 'U')
   drop table lose
go

if exists (select 1
            from  sysobjects
           where  id = object_id('lost_content')
            and   type = 'U')
   drop table lost_content
go

if exists (select 1
            from  sysobjects
           where  id = object_id('"user"')
            and   type = 'U')
   drop table "user"
go

/*==============================================================*/
/* Table: log                                                   */
/*==============================================================*/
create table log (
   logId                int                  not null,
   uid                  int                  null,
   type                 int                  null,
   tableId              int                  null,
   tableName            varchar(1)           null,
   comment              varchar(1)           null,
   createTime           datetime             null,
   createIp             char(10)             null,
   constraint PK_LOG primary key (logId)
)
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sys.sp_addextendedproperty 'MS_Description', 
   '日志',
   'user', @CurrentUser, 'table', 'log'
go

/*==============================================================*/
/* Table: log_content                                           */
/*==============================================================*/
create table log_content (
   logid                int                  null,
   tableKey             varchar(1)           null,
   tableValue           varchar(1)           null,
   currentTableValue    varchar(1)           null,
   comment              varchar(512)         null
)
go

/*==============================================================*/
/* Table: lose                                                  */
/*==============================================================*/
create table lose (
   loseId               int                  not null,
   loseTime             datetime             null,
   lostAddress          varchar(512)         null,
   lostPhonenumber      varchar(512)         null,
   lostComment          varchar(1)           null,
   uid                  int                  null,
   createTime           datetime             null,
   constraint PK_LOSE primary key (loseId)
)
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sys.sp_addextendedproperty 'MS_Description', 
   '丢失记录',
   'user', @CurrentUser, 'table', 'lose'
go

/*==============================================================*/
/* Table: lost_content                                          */
/*==============================================================*/
create table lost_content (
   lostContentId        int                  not null,
   loseId               int                  null,
   lostId               int                  null,
   imgUrl               varchar(1)           null,
   createTime           datetime             null,
   constraint PK_LOST_CONTENT primary key (lostContentId)
)
go

/*==============================================================*/
/* Table: "user"                                                */
/*==============================================================*/
create table "user" (
   uid                  int                  not null,
   name                 varchar(32)          null,
   username             varchar(32)          null,
   password             varchar(32)          null,
   phonenumber          varchar(32)          null,
   avatar               varchar(512)         null,
   createTime           datetime             null,
   createIp             varchar(100)         null,
   lastTime             datetime             null,
   lastIp               varchar(100)         null,
   address              varchar(512)         null,
   token                char(36)             null,
   constraint PK_USER primary key (uid)
)
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sys.sp_addextendedproperty 'MS_Description', 
   '用户',
   'user', @CurrentUser, 'table', 'user'
go

alter table log
   add constraint FK_LOG_REFERENCE_USER foreign key (uid)
      references "user" (uid)
go

alter table log_content
   add constraint FK_LOG_CONT_REFERENCE_LOG foreign key (logid)
      references log (logId)
go

alter table lose
   add constraint FK_LOSE_REFERENCE_USER foreign key (uid)
      references "user" (uid)
go

alter table lost_content
   add constraint FK_LOST_CON_REFERENCE_LOSE foreign key (loseId)
      references lose (loseId)
go

