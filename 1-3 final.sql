-- 1) Загрузка таблиц. Задания будут выполнены в новой схеме bonds. 
-- Создаем 3 таблицы с подходящими параметрами столбцов. Первая - listing_task

DROP TABLE if exists bonds.listing;

CREATE TABLE bonds.listing
(
    "ID" bigint NOT NULL,
    "ISIN" text COLLATE pg_catalog."default",
    "Platform" text COLLATE pg_catalog."default" NOT NULL,
    "Section" text COLLATE pg_catalog."default",
    CONSTRAINT listing_pkey PRIMARY KEY ("ID")
	-- Здесь ключ - уникальный ID
)
TABLESPACE pg_default;
ALTER DATABASE postgres SET datestyle TO "ISO, DMY";
ALTER TABLE bonds.listing
    OWNER to postgres;
	

-- Меняем формат данных в исходниках, где это требуется, сохраняем .csv
-- С помощью следующего кода загружаем данные
-- Танцы с бубном для корректного считывания дат на Mac OS опущу

COPY  bonds.listing
FROM '/Users/danis/anaconda3/pkgs/conda-4.7.10-py37_0/info/test/tests/data/tar_traversal/dirsym/tmp/listing.csv' 
	DELIMITERS ';' CSV HEADER ENCODING 'UTF8';

-- То же самое для таблицы quotes_task. Ключи - ID и TIME.

DROP TABLE if exists bonds.quotes;

CREATE TABLE bonds.quotes
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
    CONSTRAINT quotes_pkey PRIMARY KEY ("ID", "TIME")
)

TABLESPACE pg_default;

ALTER TABLE bonds.quotes
    OWNER to postgres;

COPY bonds.quotes
FROM '/Users/danis/anaconda3/pkgs/conda-4.7.10-py37_0/info/test/tests/data/tar_traversal/dirsym/tmp/quotes.csv'
DELIMITERS ';' CSV HEADER ENCODING 'UTF8';

-- Таблица bonds.bond_description. Ключ - ISIN, RegCode, NRD Code.

DROP TABLE if exists bonds.bond_description;

CREATE TABLE bonds.bond_description
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
    CONSTRAINT bond_description_pkey PRIMARY KEY ("ISIN, RegCode, NRDCode")
)
TABLESPACE pg_default;
	ALTER TABLE bonds.bond_description
    OWNER to postgres;
	
COPY bonds.bond_description
FROM '/Users/danis/anaconda3/pkgs/conda-4.7.10-py37_0/info/test/tests/data/tar_traversal/dirsym/tmp/bond_description.csv'
DELIMITERS ';' CSV HEADER ENCODING 'UTF8';

-- 2) Добавляем нужные столбцы в таблицу listing

ALTER TABLE bonds.listing
ADD COLUMN "IssuerName" text, 
ADD COLUMN "IssuerName_NRD" text, 
ADD COLUMN "IssuerOKPO" bigint;

-- Добавляем данные в новые столбцы

UPDATE bonds.listing
SET "IssuerName" = bonds.bond_description."IssuerName",
"IssuerName_NRD" = bonds.bond_description."IssuerName_NRD",
"IssuerOKPO" = bonds.bond_description."IssuerOKPO"
FROM bonds.bond_description
WHERE bonds.listing."ISIN" = bonds.bond_description."ISINCode";

-- Добавляем столбцы чтобы внести инфу о площадке

ALTER TABLE bonds.listing
ADD COLUMN "BOARDID" text, 
ADD COLUMN "BOARDNAME" text;
 
-- Тем же способом добавляем данные 

UPDATE bonds.listing
SET "BOARDID" = bonds.quotes."BOARDID",
"BOARDNAME" = bonds.quotes."BOARDNAME"
FROM bonds.quotes
WHERE bonds.listing."ISIN" = bonds.quotes."ISIN";

-- 3. Главная таблица - listing, дочерняя - bond_description
-- Создаем новый столбец идентификатор эмитента и заполняем его.

ALTER TABLE bonds.bond_description
ADD COLUMN "Issuer_ID" bigint;
UPDATE bonds.bond_description
SET "Issuer_ID" = bonds.listing."ID"
FROM bonds.listing
WHERE bonds.listing."ISIN" = bonds.bond_description."ISINCode";

-- Делаем внешний ключ для таблицы bond_description

ALTER TABLE bonds.bond_description
ADD CONSTRAINT for_key_1 FOREIGN KEY ("Issuer_ID") REFERENCES bonds.listing ("ID");

-- В таблицах есть общий столбец, содержащий ISIN, можно связать их по этому столбцу.

-- Комментарий:
-- А где связь listing и quotes?