-- ПУНКТ №1: Создание таблицы Bonds_description из данных файла Bonds_description_task

DROP TABLE IF EXISTS public.bond_description_task;

CREATE TABLE public.bond_description_task
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
    "CurrentFaceValue_NRD" real,
    "BorrowerName" text NOT NULL,
    "BorrowerOKPO" bigint,
    "BorrowerSector" text,
    "BorrowerUID" bigint NOT NULL,
    "IssuerName" text NOT NULL,
    "IssuerName_NRD" text,
    "IssuerOKPO" bigint,
    "NumGuarantors" smallint NOT NULL,
    "EndMtyDate" date,
    CONSTRAINT bond_description_task_pkey PRIMARY KEY ("ISIN, RegCode, NRDCode")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.bond_description_task
    OWNER to postgres;

-- Код для копирования данных в БД. Данные предварительно необходимо подготовить и сохранить в правильную
-- директорию на компьютере (см. Инструкция.docx)
COPY public.bond_description_task
FROM 'C:\Users\Public\bond_description_task.csv' 
DELIMITER ';' CSV HEADER ENCODING 'WIN 1251';

-- Результат: создана таблица bond_description_task, состоящая из 2934 строк

-- Создание таблицы котировок Quotes из данных файла quotes_task
DROP TABLE if exists public.quotes_task;

CREATE TABLE public.quotes_task
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
    "BOARDID" text,
    "BOARDNAME" text,
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
    "ISIN" text,
    "ISSUER" text,
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
WITH (
    OIDS = FALSE
)

TABLESPACE pg_default;

ALTER TABLE public.quotes_task
    OWNER to postgres;

-- Код для копирования данных в БД.
COPY public.quotes_task
FROM 'C:\Users\Public\quotes_task.csv' 
DELIMITER ';' CSV HEADER ENCODING 'WIN 1251';

-- Результат: создана таблица quotes_task, состоящая из 1047800 строк

-- Создание таблицы листинга Listing из данных файла listing_task

DROP TABLE if exists public.listing_task;

CREATE TABLE public.listing_task
(
    "ID" integer NOT NULL,
    "ISIN" text NOT NULL,
    "Platform" text NOT NULL,
    "Section" text NOT NULL,
    CONSTRAINT listing_task_pkey PRIMARY KEY ("ID")
)
WITH (
    OIDS = FALSE
)

TABLESPACE pg_default;

ALTER TABLE public.listing_task
    OWNER to postgres;

-- Код для копирования данных в БД.
COPY public.listing_task
FROM 'C:\Users\Public\listing_task.csv' 
DELIMITER ';' CSV HEADER ENCODING 'WIN 1251';

-- Результат: создана таблица listing_task, состоящая из 20680 строк
-- Таким образом, в нашей СУБД теперь есть три таблицы, и мы можем приступить к выполнению пункта 2

-- В ПУНКТЕ №2 от нас требуется дополнить таблицу listing_task соответствующими столбцами из других таблиц
ALTER TABLE public.listing_task
ADD "IssuerName" text,
ADD "IssuerName_NRD" text,
ADD "IssuerOKPO" bigint;

-- Заполним добавленные столбцы информацией из таблицы bond_description_task
UPDATE public.listing_task
SET "IssuerName"=public.bond_description_task."IssuerName",
"IssuerName_NRD"=public.bond_description_task."IssuerName_NRD",
"IssuerOKPO"=public.bond_description_task."IssuerOKPO"
FROM public.bond_description_task
WHERE public.listing_task."ISIN"=public.bond_description_task."ISINCode";

-- Аналогично для информации о площадках
ALTER TABLE public.listing_task
ADD "BOARDID" text, 
ADD "BOARDNAME" text;

UPDATE public.listing_task
SET "BOARDNAME"=public.quotes_task."BOARDNAME",
"BOARDID"=public.quotes_task."BOARDID"
FROM public.quotes_task
WHERE public.listing_task."ID"=public.quotes_task."ID";

-- Результат: таблица listing_task обновлена, это можно проверить, раскрыв список колонок в меню слева в Postgre

-- ПУНКТ №3:
ALTER TABLE public.bond_description_task
ADD COLUMN "Issuer_ID" bigint;
UPDATE public.bond_description_task
SET "Issuer_ID" = public.listing_task."ID"
FROM public.listing_task
WHERE public.listing_task."ISIN" = public.bond_description_task."ISINCode";

-- Делаем внешний ключ для таблицы bond_description_task

ALTER TABLE public.bond_description_task
ADD CONSTRAINT for_key_1 FOREIGN KEY ("Issuer_ID") REFERENCES public.listing_task ("ID");

-- Результат: внешние ключи для таблицы quotes заданы

-- ПУНКТ №4
select "IssuerName", public.listing_task."ISIN", zeros::decimal / days as num_ratio
from public.listing_task
INNER JOIN public.quotes_task ON public.listing_task."ISIN" = public.quotes_task."ISIN"
INNER JOIN
	(select "ISIN", count("TIME") as days
	 from public.quotes_task
	 group by "ISIN") as days_table
	 ON days_table."ISIN" = public.listing_task."ISIN"
INNER JOIN (select count("BID") as zeros, "ISIN"
				from public.quotes_task
				where "BID" = 0 or "BID" is null
				group by "ISIN") as zeros_table
				ON zeros_table."ISIN" = public.listing_task."ISIN"
where "Platform"='Московская Биржа '
and "Section"=' Основной'
and zeros::decimal / days <= 0.10
group by public.listing_task."ISIN", "IssuerName", "num_ratio";
