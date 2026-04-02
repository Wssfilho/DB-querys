create database Listas
-- 1
-- Tabela PAI_pais
CREATE TABLE PAI_pais (
    pai_cd_pais INT IDENTITY PRIMARY KEY,
    pai_nm_pais VARCHAR(50) NOT NULL,
    pai_dc_nacionalidade VARCHAR(18) NOT NULL
);

-- Tabela ATO_ator
CREATE TABLE ATO_ator (
    ato_cd_codigo INT IDENTITY PRIMARY KEY,
    ato_nm_ator VARCHAR(50) NOT NULL,
    ato_sx_ator CHAR(1) NOT NULL CHECK (ato_sx_ator IN ('F', 'M')) DEFAULT 'M',
    ato_dt_nascimento SMALLDATETIME NOT NULL,
    ato_rg_ator INT NOT NULL UNIQUE,
    ato_cd_pais_nacionalidade INT NOT NULL,
    FOREIGN KEY (ato_cd_pais_nacionalidade) REFERENCES PAI_pais(pai_cd_pais) ON UPDATE CASCADE
);

-- Tabela TIP_tipo
CREATE TABLE TIP_tipo (
    tip_cd_tipo INT IDENTITY PRIMARY KEY,
    tip_dc_tipo VARCHAR(50) NOT NULL
);

-- Tabela GEN_genero
CREATE TABLE GEN_genero (
    gen_cd_genero INT IDENTITY PRIMARY KEY,
    gen_dc_genero VARCHAR(50) NOT NULL
);

-- Tabela FIL_filme
CREATE TABLE FIL_filme (
    fil_cd_filme INT IDENTITY PRIMARY KEY,
    fil_tl_original VARCHAR(85) NOT NULL,
    fil_tl_portugues VARCHAR(85),
    fil_cd_genero INT NOT NULL,
    fil_cd_duracao VARCHAR(20) NOT NULL,
    fil_dc_importancia VARCHAR(99),
    fil_dc_impropriedade VARCHAR(20) NOT NULL,
    fil_cd_pais_origem INT NOT NULL,
    fil_cd_diretor INT NOT NULL,
    FOREIGN KEY (fil_cd_genero) REFERENCES GEN_genero(gen_cd_genero) ON UPDATE CASCADE,
    FOREIGN KEY (fil_cd_pais_origem) REFERENCES PAI_pais(pai_cd_pais),
    FOREIGN KEY (fil_cd_diretor) REFERENCES ATO_ator(ato_cd_codigo) ON UPDATE CASCADE
);

-- Tabela EST_estado
CREATE TABLE EST_estado (
    est_cd_estado INT IDENTITY PRIMARY KEY,
    est_nm_estado VARCHAR(50) NOT NULL,
    est_cd_pais INT NOT NULL,
    FOREIGN KEY (est_cd_pais) REFERENCES PAI_pais(pai_cd_pais) ON UPDATE CASCADE
);

-- Tabela CID_cidade
CREATE TABLE CID_cidade (
    cid_cd_cidade INT IDENTITY PRIMARY KEY,
    cid_nm_cidade VARCHAR(50) NOT NULL,
    cid_cd_estado INT NOT NULL,
    FOREIGN KEY (cid_cd_estado) REFERENCES EST_estado(est_cd_estado) ON UPDATE CASCADE
);

-- Tabela CIN_cinema
CREATE TABLE CIN_cinema (
    cin_cd_cinema INT IDENTITY PRIMARY KEY,
    cin_nm_fantasia VARCHAR(50) NOT NULL,
    cin_dc_logradouro VARCHAR(30) NOT NULL,
    cin_dc_complemento VARCHAR(20),
    cin_nu_numero INT,
    cin_dc_bairro VARCHAR(20) NOT NULL,
    cin_cd_cidade INT NOT NULL,
    cin_cp_lotacao INT NOT NULL,
    FOREIGN KEY (cin_cd_cidade) REFERENCES CID_cidade(cid_cd_cidade) ON UPDATE CASCADE
);

-- Tabela FCI_filme_cinema (versão original que será excluída depois)
CREATE TABLE FCI_filme_cinema (
    fci_cd_filme INT,
    fci_cd_cinema INT,
    fci_dt_inicio SMALLDATETIME NOT NULL,
    fci_dt_fim SMALLDATETIME NOT NULL,
    PRIMARY KEY (fci_cd_filme, fci_cd_cinema),
    FOREIGN KEY (fci_cd_filme) REFERENCES FIL_filme(fil_cd_filme),
    FOREIGN KEY (fci_cd_cinema) REFERENCES CIN_cinema(cin_cd_cinema)
);
-- 2 Remover a tabela FCI_filme_cinema
DROP TABLE FCI_filme_cinema
-- 3. Adicionar coluna fil_cd_tipo à tabela FIL_filme
ALTER TABLE FIL_filme
ADD fil_cd_tipo INT; 
ALTER TABLE FIL_filme
ADD CONSTRAINT fk_filme_tipo FOREIGN KEY(fil_cd_tipo) REFERENCES TIP_tipo(tip_cd_tipo) ON UPDATE CASCADE;
-- Aqui a gente ver o alter table adicionando uma coluna e atribuindo a foreign key a aela


-- 4  Alterar tipo da coluna fil_tl_original
ALTER TABLE FIL_filme
ALTER COLUMN fil_tl_original VARCHAR(100);

-- 5 Excluir a coluna fil_dc_impropriedade
ALTER TABLE FIL_filme
DROP COLUMN fil_dc_impropriedade;

-- 6 Criar tabela FCI_filme_cinema

CREATE TABLE FCI_filme_cinema(
	fci_cd_filme int not null,
	fci_cd_cinema int not null,
	fci_dt_inicio smalldatetime not null,
	fci_dt_fim smalldatetime not null,
 
);

-- 7 Adicionar com alter fci_cd_filme e fci_cd_cinema como chave primaria
ALTER TABLE FCI_filme_cinema
ADD CONSTRAINT pk_fci PRIMARY KEY (fci_cd_filme, fci_cd_cinema);

-- 8 alter table fci_cd_filme como chave estrangeira referenciando FIL_filme.

ALTER TABLE FCI_filme_cinema
ADD CONSTRAINT fk_fci_filme FOREIGN KEY (fci_cd_filme) references FIL_filme(fil_cd_filme)

-- 9 Adicionar chave estrangeira para fci_cd_cinema

ALTER TABLE FCI_filme_cinema
ADD CONSTRAINT fk_fci_cinema FOREIGN KEY (fci_cd_cinema) references CIN_cinema (cin_cd_cinema)

-- 10 Inserir 5 tuplas

-- PAI_pais
INSERT INTO PAI_pais (pai_nm_pais, pai_dc_nacionalidade) VALUES
('Brasil', 'brasileiro'),
('França', 'francês'),
('EUA', 'americano'),
('Japão', 'japonês'),
('China', 'chines');

-- EST_estado
INSERT INTO EST_estado (est_nm_estado, est_cd_pais) VALUES
('São Paulo', 1),
('Rio de Janeiro', 2),
('Londres', 3),
('Washington', 4),
('Toronto', 5);

-- CID_cidade
INSERT INTO CID_cidade (cid_nm_cidade, cid_cd_estado) VALUES
('Ilheus', 1),
('Nova York', 2),
('Itabuna', 3),
('Los Angeles', 4),
('Paris', 5);

-- GEN_genero
INSERT INTO GEN_genero (gen_dc_genero) VALUES
('Ação'),
('Drama'),
('Comédia'),
('Terror'),
('Documentário');

-- TIP_tipo
INSERT INTO TIP_tipo (tip_dc_tipo) VALUES
('Longa-Metragem'),
('Curta-Metragem'),
('Série'),
('Animação'),
('Documentário');

-- 11
INSERT INTO ATO_ator (ato_nm_ator, ato_sx_ator, ato_dt_nascimento, ato_rg_ator, ato_cd_pais_nacionalidade) VALUES
('Wilson Filho', 'M', 1985-04-10, 11111111, 1),
('Milena Barbosa', 'F', 1990-12-01, 22222222, 2),
('Camila França', 'F', 1995-07-15, 33333333, 3),
('Stefanie Costa', 'F', 1980-03-20, 44444444, 4),
('Eduardo Ferreira', 'M', 1975-06-30, 55555555, 5);

-- Como já utilizei japão vou colocar argentina
-- 12 
UPDATE PAI_pais 
SET pai_nm_pais = 'Argentina', pai_dc_nacionalidade = 'argetino'
where pai_cd_pais = 1;

--13

DELETE from ATO_ator
where ato_sx_ator = 'M'

-- 14
SELECT pai_cd_pais, pai_nm_pais from PAI_pais
where pai_cd_pais = 1

--15 
SELECT ato_nm_ator, ato_sx_ator, ato_dt_nascimento from ATO_ator
where ato_sx_ator = 'F'

-- 16 
SELECT fil_tl_original FROM FIL_filme
WHERE fil_tl_portugues is null order by fil_tl_original



--prova
insert into Curso_inativo (nome_curso, status)
select nome_curso, status from Curso
where status = 'I'


select n.Nome, n.Sexo, n.RG, (n.Logradouro + ',' + n.Complemento + ',' + n.Numero + ',' + n.Bairro + ','
+ c.cidade) as ENDERECO
from Aluno n
inner join Cidade c on n.Cod_cidade = c.Codigo_cidade
where n.Status = 2


select Codigo_cidade, Codigo_curso, count(*) as total_aluno from Aluno
group by codigo_cidade, Codigo_curso
order by Codigo_cidade desc


select nome_curso from Curso
UNION 
select nome_curso from Curso_inativo

select nome_curso from Curso where nome_curso in 
(select nome_curso from Curso_inativo)

select nome_curso from Curso where nome_curso not exists
(select nome_curso from Curso_inativo)


select Nome, Sexo from Aluno where Nome like '[A-D]%'

select Nome from Aluno 
where Codigo_Cidade between 5 and 8

