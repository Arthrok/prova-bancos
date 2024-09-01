-- Inserindo dados na tabela Aluno
INSERT INTO Aluno (NMatr, Nome, Idade, DataNasc, CidadeOrigem)
VALUES 
(1001, 'Alice Silva', 20, '2003-05-14', 'São Paulo'),
(1002, 'Bruno Pereira', 22, '2001-08-09', 'Rio de Janeiro'),
(1003, 'Carlos Souza', 21, '2002-11-23', 'Belo Horizonte'),
(1004, 'Diana Costa', 19, '2004-02-17', 'Salvador'),
(1005, 'Eduardo Lima', 23, '2000-06-30', 'Curitiba');

-- Inserindo dados na tabela Professor
INSERT INTO Professor (NFunc, Nome, Idade, Titulacao)
VALUES 
(2001, 'Prof. João Mendes', 45, 'Doutor'),
(2002, 'Prof. Maria Clara', 50, 'Titular'),
(2003, 'Prof. Pedro Almeida', 39, 'Mestre'),
(2004, 'Prof. Ana Beatriz', 55, 'Catedrático'),
(2005, 'Prof. Lucas Oliveira', 48, 'Livre-docente');

-- Inserindo dados na tabela Disciplina
INSERT INTO Disciplina (Sigla, Nome, NCred, Professor, Livro)
VALUES 
('MAT101', 'Matemática Básica', 4, 2001, 'Cálculo I'),
('FIS102', 'Física I', 5, 2002, 'Física Moderna'),
('QUI103', 'Química Orgânica', 3, 2003, 'Química Orgânica para Leigos'),
('BIO104', 'Biologia Celular', 4, 2004, 'Biologia Molecular'),
('HIS105', 'História do Brasil', 2, 2005, 'Brasil: Uma História');

-- Inserindo dados na tabela Turma
INSERT INTO Turma (Sigla, Letra, NAlunos)
VALUES 
('MAT101', 'A', 30),
('MAT101', 'B', 25),
('FIS102', 'A', 35),
('QUI103', 'A', 20),
('BIO104', 'B', 28),
('HIS105', 'A', 22);  -- Adicionando a turma HIS105-A para evitar erro de chave estrangeira

-- Inserindo dados na tabela Matrícula
INSERT INTO Matricula (Sigla, Letra, Aluno, Ano, Nota)
VALUES 
('MAT101', 'A', 1001, 2024, 8.5),
('MAT101', 'B', 1002, 2024, 7.0),
('FIS102', 'A', 1001, 2024, 9.0),
('QUI103', 'A', 1003, 2024, 6.5),
('BIO104', 'B', 1004, 2024, 7.8),
('HIS105', 'A', 1005, 2024, 8.2);  -- Este insert agora será bem-sucedido, pois a turma HIS105-A existe
