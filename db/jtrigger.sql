CREATE OR REPLACE FUNCTION atualizar_titulacao_professor()
RETURNS TRIGGER AS $$
DECLARE
    ordem_titulacao INT;
    nova_ordem_titulacao INT;
BEGIN
    -- Definir a ordem das titulações
    SELECT CASE OLD.titulacao
        WHEN 'Bacharel' THEN 1
        WHEN 'Mestre' THEN 2
        WHEN 'Doutor' THEN 3
        WHEN 'Livre-docente' THEN 4
        WHEN 'Titular' THEN 5
        WHEN 'Catedrático' THEN 6
        ELSE 0
    END INTO ordem_titulacao;

    SELECT CASE NEW.titulacao
        WHEN 'Bacharel' THEN 1
        WHEN 'Mestre' THEN 2
        WHEN 'Doutor' THEN 3
        WHEN 'Livre-docente' THEN 4
        WHEN 'Titular' THEN 5
        WHEN 'Catedrático' THEN 6
        ELSE 0
    END INTO nova_ordem_titulacao;

    -- Verificar se a nova titulação é inferior à antiga
    IF nova_ordem_titulacao < ordem_titulacao THEN
        RAISE EXCEPTION 'Não é permitido uma titulação anterior';
    END IF;

    -- Caso a nova titulação seja válida, prosseguir com a atualização
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Criando o trigger para a tabela PROFESSOR
CREATE TRIGGER trigger_atualizar_titulacao_professor
BEFORE UPDATE ON PROFESSOR
FOR EACH ROW
WHEN (OLD.titulacao IS DISTINCT FROM NEW.titulacao)
EXECUTE FUNCTION atualizar_titulacao_professor();

CREATE OR REPLACE FUNCTION confere_creditos()
RETURNS TRIGGER AS $$
DECLARE
    creditos_atual int;
BEGIN
    SELECT SUM(d.ncred) INTO creditos_atual
    FROM matricula m
    JOIN turma t ON m.sigla = t.sigla AND m.letra = t.letra
    JOIN disciplina d ON t.sigla = d.sigla
    WHERE m.aluno = NEW.aluno AND m.ano = NEW.ano;

    -- Verificar se a nova matrícula excede o limite de 20 créditos
    IF creditos_atual + (SELECT NCred FROM Disciplina WHERE Sigla = NEW.Sigla) > 20 THEN
        RAISE EXCEPTION 'O aluno não pode ultrapassar 20 créditos';
    END IF;

    RETURN NEW;
END;

$$ LANGUAGE plpgsql;

-- CREATE TRIGGER confere_creditos
-- BEFORE INSERT ON Matricula
-- FOR EACH ROW EXECUTE FUNCTION confere_creditos();

ALTER TABLE Disciplina ADD COLUMN nota_media DECIMAL(5,2);


CREATE OR REPLACE FUNCTION media_disciplina() 
RETURNS TRIGGER AS $$
DECLARE
    media DECIMAL(5,2);
BEGIN
    -- Calcula a média das notas para a disciplina específica
    SELECT AVG(m.nota) INTO media
    FROM Matricula m
    WHERE m.sigla = NEW.sigla;

    -- Atualiza a nota média na tabela Disciplina
    UPDATE Disciplina
    SET nota_media = media
    WHERE Sigla = NEW.sigla;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER atualizar_media_disciplina
AFTER INSERT OR UPDATE OR DELETE ON Matricula
FOR EACH ROW
EXECUTE FUNCTION media_disciplina();


CREATE OR REPLACE FUNCTION adiciona_idade()
RETURNS TRIGGER AS $$
BEGIN
    -- Calcula a idade atual do aluno
    NEW.idade := DATE_PART('year', CURRENT_DATE) - DATE_PART('year', NEW.DataNasc);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER atualiza_idade_aluno
BEFORE INSERT OR UPDATE ON Aluno
FOR EACH ROW
EXECUTE FUNCTION adiciona_idade();


CREATE OR REPLACE FUNCTION deletea()
RETURNS TRIGGER AS $$
DECLARE
    counting INT;
BEGIN
    SELECT COUNT(*) INTO counting
    FROM Matricula;

    RAISE NOTICE 'Tuplas após remoção: %', counting;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER delete_trigger
BEFORE DELETE ON Matricula
EXECUTE FUNCTION deletea();



ALTER TABLE Matricula ADD COLUMN aprovado BOOLEAN DEFAULT FALSE;

CREATE OR REPLACE FUNCTION aprova()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.nota > 5 THEN
        NEW.aprovado := TRUE;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER aprova
BEFORE INSERT OR UPDATE ON Matricula
FOR EACH ROW
EXECUTE FUNCTION aprova()