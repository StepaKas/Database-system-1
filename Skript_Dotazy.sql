

-- dotazy se zakladnim vypisem hodnot



-- Skupina 1
/*1;1;43;
Z�kladn� v�pis v�ech jmen z tabulky brig�dn�k. */
select *
from pracovnik 
order by prijmeni


/*1;2;9;
Se�ad� �ichty sestupn� podle data a kon�n�*/
select sichta_id, convert (date, datum) as Datum_Konani , Smena_ID
from sichta
order by datum desc ,sichta_id desc

/*1;3;9;
Vyp�e celkovou pracovn� dobu jednotliv�ch smen*/
select sichta_ID, (datediff(hour,zacatek, konec)) as DobaSichty
from sichta
order by DobaSichty

/*1;4;1;
Vr�ti mi pr�m�rnou d�lku textu*/
select avg(len(text)) Prumerna_Delka
from komentar

/*2;1;4;
Vr�ti mi jm�no, p�ijmen� a pozici od pracovn�k�, kte�� se jmenuj� Lukas nebo se jmenuji Tereza a jsou na pozici obsluha*/
select jmeno, prijmeni , pozice
from pracovnik
where jmeno = 'Lukas' or (jmeno = 'Tereza' and pozice = 'Obsluha')







/*2;2;31;
Vyp�e jm�na v�ech lid�, kte�� nemaj� na konci jm�na ova */
select jmeno, prijmeni 
from pracovnik
where prijmeni not like '%ova'

/*2;3;30;
Vr�t� jm�na v�ech u�ivatel�, kte�� nepracuj� v kuchyni*/
select jmeno, prijmeni 
from pracovnik
where pozice != 'Kuchyn�'

/*2;4;5;
Vyp�e mi v�echny atributy sichet kter� se konaly v �ervnu*/
select sichta_id
from sichta
where month(datum) = 6
order by sichta_id


/*3;1;5;
Vr�t� mi ID �ichet, na kter� je p�ihl�en� u�ivatel se jm�nem Petr*/
select distinct (s.sichta_id)
from prihlaseni s
join pracovnik p on s.pracovnik_id = p.pracovnik_id
where Jmeno = 'Petr'

/*3;2;5;
Vr�t� mi ID �ichet, na kter� je p�ihl�en� u�ivatel se jm�nem Petr*/
select distinct (p.sichta_id)
from prihlaseni p
where p.pracovnik_id in (select pracovnik_id from pracovnik b where  b.jmeno = 'Petr')


/*3;3;5;
Vr�t� mi ID �ichet, na kter� je p�ihl�en� u�ivatel se jm�nem Petr*/
select distinct (p.sichta_id)
from prihlaseni p
where exists (select * from pracovnik b where  b.pracovnik_id = p.pracovnik_id and b.jmeno = 'Petr' )

/*3;4;5;
Vr�t� mi ID �ichet, na kter� je p�ihl�en� u�ivatel se jm�nem Petr*/
select distinct (p.sichta_id)
from prihlaseni p
where pracovnik_id = ANY (select pracovnik_id from pracovnik b where  b.jmeno = 'Petr' )



/*4;1;3;
Vr�t� mi pocet lid� na pozici obsluha na jedn� sm�n�*/
select sm.smena_id, count (b.pracovnik_id) as Pocet_Obsluhy
from smena sm
left join sichta si on si.smena_ID = sm.smena_id
left join prihlaseni p on p.sichta_id = si.sichta_id
left join pracovnik b on b.pracovnik_id = p.pracovnik_id
where pozice = 'Obsluha'
group by sm.smena_id


/*4;2;2;
Vr�t� mi ID sichet ve kter�ch se kon� koncert kapely*/
select su.sichta_id , count(su.udalost_id) as UdalostiNaSichte
from sichta s
join sichta_udalost su on s.sichta_id= su.sichta_id
group by su.sichta_id
having count(su.udalost_id) >1

/*4;3;31;
Vr�t� mi ID pracovniku kte�� jsou p�ihl�en� k v�ce n� jedn� �icht� */
select b.pracovnik_id , count(p.sichta_id) as Sichty
from pracovnik b
join prihlaseni p on p.pracovnik_id = b.pracovnik_id
group by b.pracovnik_id
having count(p.sichta_id) >1

/*4;4;2;
Vyselektuje mi id smen, na kter�ch je p�ihl�eno v�c ne� 8 �en, tedy pracovniku s p��jmenim kon��c�m na ova*/
select s.smena_Id,count(pr.Jmeno) as PocelZen
from smena s
join sichta si on s.smena_id=si.Smena_ID
join prihlaseni p on p.sichta_id = si.sichta_id
join pracovnik pr on p.pracovnik_id = pr.pracovnik_id
where pr.Prijmeni like '%ova'
group by s.smena_Id
having (count(pr.Jmeno)) >8


/*5;1;10;
Ziska jmeno a p��ijmen� z�kazn�k� p�ihla�en�ch na ��chtu s ID jedna*/
select pr.Jmeno , Prijmeni
from pracovnik pr 
left join prihlaseni p on p.pracovnik_id = pr.pracovnik_id
where p.sichta_id = 1

/*5;2;10;
Ziska jmeno a p��ijmen� z�kazn�k� p�ihla�en�ch na ��chtu s ID jedna*/
select pr.Jmeno , Prijmeni
from  pracovnik pr 
where pr.pracovnik_id in (select k.pracovnik_id from prihlaseni k where k.sichta_id = 1)


/*5;3;7;
Ke ka�d�mu nazvu ud�losti p�i�ad� po�et kolikr�t se tato ud�lost vyskytla na �icht�ch*/
select u.nazev , count(su.sichta_id) as Pocet
from udalost u
left join sichta_udalost su on su.udalost_id = u.udalost_id
group by u.nazev 
 
/*5;4;4;
Ziska pocet lidi ktery se jmenuji Petr k jednotlive udalosti*/
select u.Nazev , count (p.pracovnik_id) as PocetLidi
from udalost u
right join sichta_udalost su on su.udalost_id = u.udalost_id
right join sichta s on s.sichta_id = su.sichta_id
right join prihlaseni p on p.sichta_id = s.sichta_id
right join pracovnik pr on pr.pracovnik_id = p.pracovnik_id
where Jmeno = 'Petr'
group by u.Nazev


/*6;1;1;
Vyp�e id, jmeno a prijmeni nejstar��ho pracovn�ka*/
select p1.pracovnik_id , p1.Jmeno , p1.prijmeni
from pracovnik p1
where p1.pracovnik_id in (select p2.pracovnik_id from pracovnik p2 where p2.vek >= (select max(p3.vek) from pracovnik p3 )) 

/*6;2;23;
Vrati mi jmena a prijmeni pracovniku, kteri jsou prihlaseni prumerny pocet sichet a mene */
select p1.Jmeno , p1.Prijmeni , count (pr.pracovnik_id) as PocetPrihlaseni
from pracovnik p1
left join prihlaseni pr on pr.pracovnik_id = p1.pracovnik_id
group by p1.Jmeno , p1.Prijmeni
having count (pr.pracovnik_id) <= (

	select avg(t.Pocet )from (
		select  count (pr.pracovnik_id) as Pocet
		from pracovnik p1
		left join prihlaseni pr on pr.pracovnik_id = p1.pracovnik_id
		group by p1.Jmeno , p1.Prijmeni
	)t
)