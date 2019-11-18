-- 1) Загрузка таблиц. Задания будут выполнены в новой схеме bonds. 
-- Создаем 3 таблицы с подходящими параметрами столбцов. Первая - listing_task

DROP TABLE if exists bonds.listing_task;

CREATE TABLE bonds.listing_task
(
    "ID" bigint NOT NULL,
    "ISIN" text COLLATE pg_catalog."default",
    "Platform" text COLLATE pg_catalog."default" NOT NULL,
    "Section" text COLLATE pg_catalog."default",
    CONSTRAINT listing_task_pkey PRIMARY KEY ("ID")
	-- Здесь ключ - уникальный ID
)
TABLESPACE pg_default;
ALTER TABLE bonds.listing_task
    OWNER to postgres;

-- Меняем формат данных в исходниках, где это требуется, сохраняем .csv
-- С помощью следующего кода загружаем данные
-- Танцы с бубном для корректного считывания дат на Mac OS опущу

COPY  bonds.listing_task
FROM '*source_folder*/listing_task.csv' 
	DELIMITERS ';' CSV HEADER ENCODING 'WIN 1251'

-- То же самое для таблицы quotes_task. Ключи - ID и TIME.

DROP TABLE if exists bonds.quotes_task;

CREATE TABLE bonds.quotes_task
(
    "ID" bigint NOT NULL,
    "TIME" date NOT NULL,
    "ACCRUEDINT" real,
    "ASK" real,
    "ASK_SIZE" real,
    "ASK_SIZE_TOTAL" bigint,
    "AVGE_PRCE" real,
    "BID" real,
    "BID_SIZE" real,
    "BID_SIZE_TOTAL" bigint,
    "BOARDID" text COLLATE pg_catalog."default",
    "BOARDNAME" text COLLATE pg_catalog."default",
    "BUYBACKDATE" date,
    "BUYBACKPRICE" real,
    "CBR_LOMBARD" real,
    "CBR_PLEDGE" real,
    "CLOSE" real,
    "CPN" real,
    "CPN_DATE" date,
    "CPN_PERIOD" bigint,
    "DEAL_ACC" bigint,
    "FACEVALUE" real,
    "ISIN" text COLLATE pg_catalog."default",
    "ISSUER" text COLLATE pg_catalog."default",
    "ISSUESIZE" bigint,
    "MAT_DATE" date,
    "MPRICE" real,
    "MPRICE2" real,
    "SPREAD" real,
    "VOL_ACC" bigint,
    "Y2O_ASK" real,
    "Y2O_BID" real,
	"YIELD_ASK" real,
    "YIELD_BID" real,
    CONSTRAINT quotes_task_pkey PRIMARY KEY ("ID", "TIME")
)

TABLESPACE pg_default;

ALTER TABLE bonds.quotes_task
    OWNER to postgres;

COPY bonds.quotes_task
FROM '*source_folder*/quotes_task.csv'
DELIMITERS ';' CSV HEADER ENCODING 'WIN 1251'

-- Таблица bonds.bond_description_task. Ключ - ISIN, RegCode, NRD Code.

DROP TABLE if exists bonds.bond_description_task;

CREATE TABLE bonds.bond_description_task
(
    "ISIN, RegCode, NRDCode" text COLLATE pg_catalog."default" NOT NULL,
    "FinToolType" text COLLATE pg_catalog."default",
    "SecurityType" text COLLATE pg_catalog."default",
    "SecurityKind" text COLLATE pg_catalog."default",
    "CouponType" text COLLATE pg_catalog."default",
    "RateTypeNameRus_NRD" text COLLATE pg_catalog."default",
    "CouponTypeName_NRD" text COLLATE pg_catalog."default",
    "HaveOffer" boolean,
    "AmortisedMty" boolean,
    "MaturityGroup" text COLLATE pg_catalog."default",
    "IsConvertible" boolean,
    "ISINCode" text COLLATE pg_catalog."default",
    "Status" text COLLATE pg_catalog."default",
    "HaveDefault" boolean,
    "IsLombardCBR_NRD" boolean,
    "IsQualified_NRD" boolean,
    "ForMarketBonds_NRD" boolean,
    "MicexList_NRD" text COLLATE pg_catalog."default",
    "Basis" text COLLATE pg_catalog."default",
    "Basis_NRD" text COLLATE pg_catalog."default",
    "Base_Month" text COLLATE pg_catalog."default",
    "Base_Year" text COLLATE pg_catalog."default",
    "Coupon_Period_Base_ID" bigint,
    "AccruedintCalcType" boolean,
    "IsGuaranteed" boolean,
    "GuaranteeType" text COLLATE pg_catalog."default",
    "GuaranteeAmount" text COLLATE pg_catalog."default",
	"GuarantVal" bigint,
    "Securitization" text COLLATE pg_catalog."default",
    "CouponPerYear" integer,
    "Cp_Type_ID" integer,
    "NumCoupons" integer,
    "NumCoupons_M" integer,
    "NumCoupons_NRD" integer,
    "Country" text COLLATE pg_catalog."default",
    "FaceFTName" text COLLATE pg_catalog."default",
    "FaceFTName_M" integer,
    "FaceFTName_NRD" text COLLATE pg_catalog."default",
    "FaceValue" real,
    "FaceValue_M" integer,
    "FaceValue_NRD" real,
    "CurrentFaceValue_NRD" real,
    "BorrowerName" text COLLATE pg_catalog."default",
    "BorrowerOKPO" bigint,
    "BorrowerSector" text COLLATE pg_catalog."default",
    "BorrowerUID" bigint,
    "IssuerName" text COLLATE pg_catalog."default",
    "IssuerName_NRD" text COLLATE pg_catalog."default",
    "IssuerOKPO" bigint,
    "NumGuarantors" integer,
    "EndMtyDate" date,
    "Issuer_ID" bigint,
    CONSTRAINT bond_description_task_pkey PRIMARY KEY ("ISIN, RegCode, NRDCode"),
   
)

TABLESPACE pg_default;
ALTER TABLE bonds.bond_description_task
    OWNER to postgres;
	
COPY bonds.bond_description_task
FROM '*source_folder*/bond_description_task.csv'
DELIMITERS ';' CSV HEADER ENCODING 'WIN 1251'

-- 2) Добавляем нужные столбцы в таблицу listing

ALTER TABLE bonds.listing_task
ADD COLUMN "IssuerName" text, 
ADD COLUMN "IssuerName_NRD" text, 
ADD COLUMN "IssuerOKPO" bigint;

-- Добавляем данные в новые столбцы

UPDATE bonds.listing_task
SET "IssuerName" = bonds.bond_description_task."IssuerName",
"IssuerName_NRD" = bonds.bond_description_task."IssuerName_NRD",
"IssuerOKPO" = bonds.bond_description_task."IssuerOKPO"
FROM bonds.bond_description_task
WHERE bonds.listing_task."ISIN" = bonds.bond_description_task."ISINCode";

-- Добавляем столбцы чтобы внести инфу о площадке

ALTER TABLE bonds.listing_task
ADD COLUMN "BOARDID" text, 
ADD COLUMN "BOARDNAME" text
 
-- Тем же способом добавляем данные 

UPDATE bonds.listing_task
SET "BOARDID" = bonds.quotes_task."BOARDID",
"BOARDNAME" = bonds.quotes."BOARDNAME"
FROM bonds.quotes_task
WHERE bonds.listing_task."ISIN" = bonds.quotes_task."ISIN";

-- 3. Главная таблица - listing_task, дочерняя - bond_description_task
-- Создаем новый столбец идентификатор эмитента и заполняем его.

ALTER TABLE bonds.bond_description_task
ADD COLUMN "Issuer_ID" bigint;
UPDATE bonds.bond_description_task
SET "Issuer_ID" = bonds.listing_task."ID"
FROM bonds.listing_task
WHERE bonds.listing_task."ISIN" = bonds.bond_description_task."ISINCode";

-- Делаем внешний ключ для таблицы bond_description_task

ALTER TABLE bonds.bond_description_task
ADD CONSTRAINT for_key_1 FOREIGN KEY ("Issuer_ID") REFERENCES bonds.listing_task ("ID");

-- В таблицах есть общий столбец, содержащий ISIN, можно связать их по этому столбцу.