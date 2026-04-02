-- 1 - Criação da nova tabela
CREATE TABLE ATO_ator_novo (
    ato_cd_codigo INT IDENTITY(1,1) PRIMARY KEY,
    ato_nm_ator VARCHAR(50) NOT NULL,
    ato_sx_ator CHAR(1) NOT NULL CHECK (ato_sx_ator IN ('F', 'M')) DEFAULT 'M',
    ato_dt_nascimento SMALLDATETIME NOT NULL,
    ato_rg_ator INT NOT NULL UNIQUE,
    ato_cd_pais_nacionalidade INT NOT NULL,
    FOREIGN KEY (ato_cd_pais_nacionalidade) REFERENCES PAI_pais(pai_cd_pais) ON UPDATE CASCADE
);

-- Inserir na nova tabela apenas atores do sexo masculino (M)
INSERT INTO ATO_ator_novo (ato_nm_ator, ato_sx_ator, ato_dt_nascimento, ato_rg_ator, ato_cd_pais_nacionalidade)
SELECT ato_nm_ator, ato_sx_ator, ato_dt_nascimento, ato_rg_ator, ato_cd_pais_nacionalidade
FROM ATO_ator
WHERE ato_sx_ator = 'M';

-- 2

INSERT INTO ATO_ator_novo (ato_nm_ator, ato_sx_ator, ato_dt_nascimento, ato_rg_ator, ato_cd_pais_nacionalidade)
SELECT ato_nm_ator, ato_sx_ator, ato_dt_nascimento, ato_rg_ator, ato_cd_pais_nacionalidade
FROM ATO_ator
WHERE ato_sx_ator = 'F';

-- 3
DELETE FROM ATO_ator
where ato_nm_ator in (select ato_nm_ator from ATO_ator_novo);

-- 4 
SELECT A.ato_nm_ator, P.pai_dc_nacionalidade
FROM ATO_ator A
INNER JOIN PAI_pais P ON A.ato_cd_pais_nacionalidade = P.pai_cd_pais
ORDER BY A.ato_nm_ator;

select A.ato_nm_ator, P.pai_dc_nacionalidade
from ATO_ator A, PAI_pais P
where A.ato_cd_pais_nacionalidade = P.pai_cd_pais
ORDER BY A.ato_nm_ator;

-- 5 
select distinct ato_cd_pais_nacionalidade from ATO_ator

--6 
SELECT DISTINCT 
    ato_cd_pais_nacionalidade AS CODIGO,
    pai.pai_dc_nacionalidade AS NACIONALIDADE
FROM 
    ATO_ator ato
INNER JOIN 
    PAI_pais pai ON ato.ato_cd_pais_nacionalidade = pai.pai_cd_pais
ORDER BY 
    NACIONALIDADE ASC;
-- 7
SELECT AVG(cin_cp_lotacao) AS media_lotacao
FROM CIN_cinema
WHERE cin_cd_cidade = 1;
-- 8
SELECT SUM(cin_cp_lotacao) AS total_capacidade
FROM CIN_cinema
WHERE cin_cd_cidade = 1;

-- 9 
SELECT TOP 1 cin_nm_fantasia, cin_cp_lotacao
FROM CIN_cinema
WHERE cin_cd_cidade = 1
ORDER BY cin_cp_lotacao DESC;

	
-- 10
SELECT COUNT(*) AS quantidade_cinemas
FROM CIN_cinema
WHERE cin_cd_cidade = 1;

-- 11 
SELECT TOP 1 cin_nm_fantasia, cin_cp_lotacao
FROM CIN_cinema
WHERE cin_cd_cidade = 1
ORDER BY cin_cp_lotacao ASC;


-- 12
SELECT 
    cin_nm_fantasia,
    (cin_dc_logradouro + ', ' + 
     ISNULL(cin_dc_complemento, '') + ', ' +
     CAST(ISNULL(cin_nu_numero, '') AS VARCHAR(10)) + ', ' +
     cin_dc_bairro) AS ENDERECO,
    cid.cid_nm_cidade
FROM 
    CIN_cinema cin
INNER JOIN 
    CID_cidade cid ON cin.cin_cd_cidade = cid.cid_cd_cidade
WHERE 
    cin_cp_lotacao > 200
ORDER BY 
    cin_nm_fantasia ASC;

-- 13
SELECT cin_nm_fantasia, cin_cp_lotacao
FROM CIN_cinema
WHERE cin_cp_lotacao BETWEEN 200 AND 400;

-- 14
SELECT 
    cin_nm_fantasia,
    cin_cp_lotacao,
    cin_cp_lotacao * 2 AS capacidade_dobrada
FROM CIN_cinema
WHERE cin_cd_cidade = 1;

-- 15
SELECT 
    F.fil_cd_filme,
    F.fil_tl_original,
    F.fil_tl_portugues,
    F.fil_cd_duracao,
    G.gen_dc_genero
FROM FIL_filme F
INNER JOIN GEN_genero G ON F.fil_cd_genero = G.gen_cd_genero
WHERE F.fil_tl_original LIKE 'A%'
  AND F.fil_tl_portugues IS NOT NULL
  AND F.fil_cd_genero = 1
ORDER BY F.fil_tl_original DESC;

-- 16
SELECT fil_tl_portugues
FROM FIL_filme
WHERE fil_tl_portugues LIKE '[C-H]%';

-- 17
SELECT fil_tl_portugues
FROM FIL_filme
WHERE fil_tl_portugues LIKE '[^C-H]%';
-- ou podemos utilizar NOT LIKE 

--18 
SELECT fil_tl_portugues
FROM FIL_filme
WHERE fil_tl_portugues LIKE '[__R%]'

-- 19
SELECT ato_nm_ator, ato_cd_pais_nacionalidade
FROM ATO_ator
UNION
(SELECT ato_nm_ator, ato_cd_pais_nacionalidade from ATO_ator_novo)


SELECT ato_nm_ator, ato_cd_pais_nacionalidade
FROM ATO_ator

UNION ALL

SELECT ato_nm_ator, ato_cd_pais_nacionalidade
FROM ATO_ator_novo;

-- 20
SELECT ato_nm_ator, ato_cd_pais_nacionalidade
FROM ATO_ator
WHERE ato_nm_ator
NOT IN (SELECT ato_nm_ator
FROM ATO_ator_novo);

--21
SELECT ato_nm_ator, ato_cd_pais_nacionalidade
FROM ATO_ator
WHERE ato_nm_ator
IN (SELECT ato_nm_ator
FROM ATO_ator_novo);

--22
SELECT 
    P.pai_dc_nacionalidade,
    A.ato_sx_ator,
    COUNT(*) AS total_atores
FROM ATO_ator A
INNER JOIN PAI_pais P ON A.ato_cd_pais_nacionalidade = P.pai_cd_pais
GROUP BY P.pai_dc_nacionalidade, A.ato_sx_ator
ORDER BY P.pai_dc_nacionalidade;
-- 23
SELECT ato_nm_ator, ato_sx_ator
FROM ATO_ator
WHERE ato_nm_ator
in (SELECT ato_nm_ator FROM ATO_ator_novo );

SELECT A.ato_nm_ator, A.ato_sx_ator
FROM ATO_ator A
WHERE EXISTS (SELECT * from ATO_ator_novo N where A.ato_nm_ator = N.ato_nm_ator);

-- 24
SELECT ato_nm_ator, ato_sx_ator
FROM ATO_ator
WHERE ato_nm_ator NOT IN (SELECT ato_nm_ator FROM ATO_ator_novo);

SELECT ato_nm_ator, ato_sx_ator
FROM ATO_ator A
WHERE NOT EXISTS (SELECT * FROM ATO_ator_novo N WHERE A.ato_nm_ator = N.ato_nm_ator);

-- 25

SELECT cin_nm_fantasia, cin_cp_lotacao
FROM CIN_cinema
where cin_cp_lotacao < (select avg(cin_cp_lotacao) from CIN_cinema)

-- 26
CREATE VIEW View_cinema AS
SELECT cin_cd_cinema, cin_nm_fantasia, cin_cp_lotacao
FROM CIN_cinema;

-- 27
SELECT cin_nm_fantasia
FROM view_cinema
ORDER BY cin_nm_fantasia;

-- 28
CREATE VIEW View_media_cinema AS
SELECT 
    C.cin_cd_cinema,
    CI.cid_nm_cidade,
    AVG(C.cin_cp_lotacao) AS media_capacidade
FROM CIN_cinema C
JOIN CID_cidade CI ON C.cin_cd_cidade = CI.cid_cd_cidade
WHERE CI.cid_cd_cidade != 1
GROUP BY C.cin_cd_cinema, CI.cid_nm_cidade
-- ORDER BY CI.cid_nm_cidade DESC; orderby dá erro no meu sql, falando que não podemos fazer order com view

DROP View View_media_cinema

-- 29 
DROP VIEW view_cinema;
