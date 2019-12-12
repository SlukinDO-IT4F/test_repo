select "IssuerName", bonds.listing."ISIN", zeros::decimal / days as num_ratio
from bonds.listing
INNER JOIN bonds.quotes ON bonds.listing."ISIN" = bonds.quotes."ISIN"
INNER JOIN
	(select "ISIN", count("TIME") as days
	 from bonds.quotes
	 group by "ISIN") as days_table
	 ON days_table."ISIN" = bonds.listing."ISIN"
INNER JOIN (select count("BID") as zeros, "ISIN"
				from bonds.quotes
				where "BID" = 0 or "BID" is null
				group by "ISIN") as zeros_table
				ON zeros_table."ISIN" = bonds.listing."ISIN"
where "Platform"='Московская Биржа '
and "Section"=' Основной'
and zeros::decimal / days <= 0.10
group by bonds.listing."ISIN", "IssuerName", "num_ratio";

--Комментарий:
-- Неверно! Запрос возвращает все облигации, который активно котируются, с указанием их эмитентов, а нужно список эмитентов, у которых ВСЕ торгуемые облигации, активно котируются.