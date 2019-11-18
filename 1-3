-- Создание таблицы Bonds_description из данных файла Bonds_description_task
-- Обратите внимание на комментарий в строках 67, 119, 142 касательно пути к файлу с данными!!!

DROP TABLE if exists public.bonds_description;

CREATE TABLE public.bonds_description
(
	"ISIN, RegCode, NRDCode" text NOT NULL,
    "FinToolType" text NOT NULL,
	"SecurityType" text,
	"SecurityKind" text,
	"CouponType" text,
	"RateTypeNameRus_NRD" text,
    "CouponTypeName_NRD" text,
    "HaveOffer" boolean NOT NULL,
    "AmortisedMty" boolean NOT NULL,
    "MaturityGroup" text,
    "IsConvertible" boolean NOT NULL,
    "ISINCode" text NOT NULL,
    "Status" text NOT NULL,
    "HaveDefault" boolean NOT NULL,
    "IsLombardCBR_NRD" boolean,
    "IsQualified_NRD" boolean,
    "ForMarketBonds_NRD" boolean,
    "MicexList_NRD" text,
    "Basis" text,
    "Basis_NRD" text,
    "Base_Month" text,
    "Base_Year" text,
    "Coupon_Period_Base_ID" smallint,
    "AccruedintCalcType" boolean NOT NULL,
    "IsGuaranteed" boolean NOT NULL,
    "GuaranteeType" text,
    "GuaranteeAmount" text,
    "GuarantVal" bigint,
    "Securitization" text,
    "CouponPerYear" smallint,
    "Cp_Type_ID" smallint,
	"NumCoupons" smallint,
    "NumCoupons_M" smallint,
    "NumCoupons_NRD" smallint,
    "Country" text NOT NULL,
    "FaceFTName" text NOT NULL,
    "FaceFTName_M" smallint NOT NULL,
    "FaceFTName_NRD" text,
    "FaceValue" real NOT NULL,
    "FaceValue_M" smallint NOT NULL,
    "FaceValue_NRD" bigint,
    "CurrentFaceValue_NRD" money,
    "BorrowerName" text NOT NULL,
    "BorrowerOKPO" bigint,
    "BorrowerSector" text,
    "BorrowerUID" bigint NOT NULL,
    "IssuerName" text NOT NULL,
    "IssuerName_NRD" text,
    "IssuerOKPO" bigint,
    "NumGuarantors" smallint NOT NULL,
    "EndMtyDate" date,
    CONSTRAINT bonds_description_pkey PRIMARY KEY ("ISIN, RegCode, NRDCode")
)

TABLESPACE pg_default;

ALTER TABLE public.bonds_description
    OWNER to postgres;

-- Код для копирования данных в БД. ОБРАТИТЕ ВНИМАНИЕ НА ПУТЬ К ФАЙЛУ - ПАПКА ДОЛЖНА СООТВЕТСТВОВАТЬ РАСПОЛОЖЕНИЮ ФАЙЛА НА ВАШЕМ КОМПЬЮТЕРЕ!
COPY public.bonds_description  
FROM 'C:\Users\IT4F\Data\Облигации\bond_description_task.csv' 
DELIMITER ';' CSV HEADER ENCODING 'WIN 1251';

-- Создание таблицы котировок Quotes из данных файла quotes_task
DROP TABLE if exists public.quotes;

CREATE TABLE public.quotes
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
    "CPN_PERIOD" integer,
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
    "YIELD_BID" real
)

TABLESPACE pg_default;

ALTER TABLE public.quotes
    OWNER to postgres;

-- Код для копирования данных в БД. ОБРАТИТЕ ВНИМАНИЕ НА ПУТЬ К ФАЙЛУ - ПАПКА ДОЛЖНА СООТВЕТСТВОВАТЬ РАСПОЛОЖЕНИЮ ФАЙЛА НА ВАШЕМ КОМПЬЮТЕРЕ!
COPY public.quotes 
FROM 'C:\Users\IT4F\Data\Облигации\quotes_task.csv' 
DELIMITER ';' CSV HEADER ENCODING 'WIN 1251';

-- Создание таблицы листинга Listing из данных файла listing_task

DROP TABLE if exists public.listing;

CREATE TABLE public.listing
(
    "ID" integer NOT NULL,
    "ISIN" text COLLATE pg_catalog."default" NOT NULL,
    "Platform" text COLLATE pg_catalog."default" NOT NULL,
    "Section" text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT listing_pkey PRIMARY KEY ("ID")
)

TABLESPACE pg_default;

ALTER TABLE public.listing
    OWNER to postgres;

-- Код для копирования данных в БД. ОБРАТИТЕ ВНИМАНИЕ НА ПУТЬ К ФАЙЛУ - ПАПКА ДОЛЖНА СООТВЕТСТВОВАТЬ РАСПОЛОЖЕНИЮ ФАЙЛА НА ВАШЕМ КОМПЬЮТЕРЕ!
COPY public.listing 
FROM 'C:\Users\IT4F\Data\Облигации\listing_task.csv' 
DELIMITER ';' CSV HEADER ENCODING 'WIN 1251';