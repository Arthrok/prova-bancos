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
