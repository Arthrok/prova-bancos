CREATE TABLE VENDEDOR (
    id_npc SERIAL PRIMARY KEY,
    nome VARCHAR(30) NOT NULL,
    dialogo TEXT NOT NULL
);

CREATE TABLE GUIA (
    id_npc SERIAL PRIMARY KEY,
    nome VARCHAR(30) NOT NULL,
    missao INT NOT NULL
);

CREATE TABLE NPC (
    id_npc INT NOT NULL,
    tipo VARCHAR(30) NOT NULL,
    PRIMARY KEY (id_npc, tipo)
);


-- CREATE TABLE SALA (
--     id_sala SERIAL PRIMARY KEY,
--     pre_req INT,
--     regiao VARCHAR(30) NOT NULL,
--     tipo VARCHAR(30) NOT NULL, -- NENHUM, GUERRA OU ARMADILHA
--     dificuldade INT, -- atributo de GUERRA
--     descricao VARCHAR(30), -- atributo de GUERRA
--     fator INT, -- atributo de ARMADILHA
--     status VARCHAR(10) -- atributo de ARMADILHA
-- );


CREATE TABLE SALA (
    id_sala SERIAL PRIMARY KEY,
    pre_req INT,
    regiao VARCHAR(30) NOT NULL,
    tipo VARCHAR(30) NOT NULL CHECK (tipo IN ('GUERRA', 'ARMADILHA'))
    -- 'tipo' determina se a sala é de GUERRA ou ARMADILHA
);

CREATE TABLE GUERRA (
    id_sala INT PRIMARY KEY REFERENCES SALA(id_sala),
    dificuldade INT NOT NULL,
    descricao VARCHAR(30)
);

CREATE TABLE ARMADILHA (
    id_sala INT PRIMARY KEY REFERENCES SALA(id_sala),
    fator INT NOT NULL,
    status VARCHAR(10)
);


CREATE OR REPLACE FUNCTION garantir_generico_NPC() RETURNS TRIGGER AS $$
DECLARE
    atributo_generico_nome VARCHAR;
BEGIN
    -- Verifica se o NPC já existe na tabela NPC
    IF (SELECT COUNT(*) FROM NPC WHERE id_npc = NEW.id_npc) >= 1 THEN
        -- Obtém o tipo do NPC existente
        SELECT COALESCE(g.nome, v.nome) INTO atributo_generico_nome 
        FROM NPC n
        LEFT JOIN GUIA g ON g.id_npc = n.id_npc
        LEFT JOIN VENDEDOR v ON v.id_npc = n.id_npc
        WHERE n.id_npc = NEW.id_npc
        LIMIT 1;

        IF NEW.nome <> atributo_generico_nome THEN
            RAISE EXCEPTION 'Atributo genérico diferente';
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Criar trigger para a tabela VENDEDOR
CREATE TRIGGER garantir_generico_vendedor
BEFORE INSERT OR UPDATE ON VENDEDOR
FOR EACH ROW
EXECUTE FUNCTION garantir_generico_NPC();

-- Criar trigger para a tabela GUIA
CREATE TRIGGER garantir_generico_guia
BEFORE INSERT OR UPDATE ON GUIA
FOR EACH ROW
EXECUTE FUNCTION garantir_generico_NPC();


-- CREATE OR REPLACE FUNCTION verificar_integridade_sala() 
-- RETURNS TRIGGER AS $$
-- BEGIN
--     -- Verifica se o tipo é 'GUERRA' e se os atributos correspondentes estão preenchidos
--     IF NEW.tipo = 'GUERRA' THEN
--         IF NEW.dificuldade IS NULL OR NEW.descricao IS NULL THEN
--             RAISE EXCEPTION 'Atributos de GUERRA não podem ser nulos';
--         END IF;
--         IF NEW.fator IS NOT NULL OR NEW.status IS NOT NULL THEN
--             RAISE EXCEPTION 'Atributos de ARMADILHA não devem ser preenchidos para tipo GUERRA';
--         END IF;
    
--     -- Verifica se o tipo é 'ARMADILHA' e se os atributos correspondentes estão preenchidos
--     ELSIF NEW.tipo = 'ARMADILHA' THEN
--         IF NEW.fator IS NULL OR NEW.status IS NULL THEN
--             RAISE EXCEPTION 'Atributos de ARMADILHA não podem ser nulos';
--         END IF;
--         IF NEW.dificuldade IS NOT NULL OR NEW.descricao IS NOT NULL THEN
--             RAISE EXCEPTION 'Atributos de GUERRA não devem ser preenchidos para tipo ARMADILHA';
--         END IF;
    
--     -- Verifica se o tipo é 'NENHUM' e se os atributos específicos estão todos nulos
--     ELSIF NEW.tipo is NULL THEN
--         IF NEW.dificuldade IS NOT NULL OR NEW.descricao IS NOT NULL OR NEW.fator IS NOT NULL OR NEW.status IS NOT NULL THEN
--             RAISE EXCEPTION 'Atributos específicos devem ser nulos para tipo NENHUM';
--         END IF;
--     END IF;

--     RETURN NEW;
-- END;
-- $$ LANGUAGE plpgsql;

-- CREATE TRIGGER trigger_verificar_integridade_sala
-- BEFORE INSERT OR UPDATE ON SALA
-- FOR EACH ROW
-- EXECUTE FUNCTION verificar_integridade_sala();

INSERT INTO VENDEDOR (id_npc, nome, dialogo) VALUES (1, 'Arthur', 'Bem-vindo à minha loja!');

-- Inserindo na tabela CEC para mapear o VENDEDOR
INSERT INTO NPC (id_npc, tipo) VALUES (1, 'VENDEDOR');

-- Inserindo na tabela GUIA
INSERT INTO GUIA (id_npc, nome, missao) VALUES (1, 'Arthur', 101);

-- Inserindo na tabela CEC para mapear o GUIA
INSERT INTO NPC (id_npc, tipo) VALUES (1, 'GUIA');


-- INSERT INTO SALA (pre_req, regiao, tipo, dificuldade, descricao)
-- VALUES (1, 'Floresta Proibida', 'GUERRA', 5, 'perigos ocultos');

-- CREATE OR REPLACE FUNCTION verifica_PE()
-- RETURNS TRIGGER AS $$
-- BEGIN
--     PERFORM 1 FROM SALA WHERE id_sala = NEW.id_sala;
--     IF FOUND THEN
--         RAISE EXCEPTION 'JÁ CADASTRADO';
--     END IF;

--     RETURN NEW;
-- END;

-- $$ LANGUAGE plpgsql;

-- CREATE TRIGGER verifica_PE_GUERRA
-- BEFORE INSERT OR UPDATE ON GUERRA
-- FOR EACH ROW
-- EXECUTE FUNCTION verifica_PE();

-- CREATE TRIGGER verifica_PE_ARMADILHA
-- BEFORE INSERT OR UPDATE ON ARMADILHA
-- FOR EACH ROW
-- EXECUTE FUNCTION verifica_PE();


-- Inserir uma sala do tipo GUERRA
INSERT INTO SALA (pre_req, regiao, tipo) VALUES (2, 'Norte', 'GUERRA');
-- INSERT INTO GUERRA (id_sala, dificuldade, descricao) VALUES (1, 5, 'Sala difícil de batalha');

-- Inserir uma sala do tipo ARMADILHA
-- INSERT INTO SALA (pre_req, regiao, tipo) VALUES (3, 'Sul', 'ARMADILHA');
INSERT INTO ARMADILHA (id_sala, fator, status) VALUES (1, 8, 'Ativada');
