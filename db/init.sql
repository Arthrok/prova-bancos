-- Tabela Aluno
CREATE TABLE Aluno (
    NMatr INT PRIMARY KEY,  -- Número de Matrícula
    Nome VARCHAR(100) NOT NULL,
    Idade INT,
    DataNasc DATE,
    CidadeOrigem VARCHAR(100)
);

-- Tabela Professor
CREATE TABLE Professor (
    NFunc INT PRIMARY KEY,  -- Número do Funcionário
    Nome VARCHAR(100) NOT NULL,
    Idade INT,
    Titulacao VARCHAR(50)  -- Titulação do Professor
);

-- Tabela Disciplina
CREATE TABLE Disciplina (
    Sigla CHAR(6) PRIMARY KEY,  -- Sigla da Disciplina
    Nome VARCHAR(100) NOT NULL,
    NCred INT,  -- Número de Créditos
    Professor INT,  -- Chave estrangeira para a tabela Professor
    Livro VARCHAR(100),
    FOREIGN KEY (Professor) REFERENCES Professor(NFunc)
);

-- Tabela Turma
CREATE TABLE Turma (
    Sigla CHAR(6),  -- Sigla da Disciplina
    Letra CHAR(1),  -- Letra da Turma
    NAlunos INT,  -- Número de Alunos na Turma
    PRIMARY KEY (Sigla, Letra),
    FOREIGN KEY (Sigla) REFERENCES Disciplina(Sigla)
);

-- Tabela Matrícula
CREATE TABLE Matricula (
    Sigla CHAR(6),  -- Sigla da Disciplina
    Letra CHAR(1),  -- Letra da Turma
    Aluno INT,  -- Número de Matrícula do Aluno
    Ano INT,
    Nota DECIMAL(5,2),
    PRIMARY KEY (Sigla, Letra, Aluno, Ano),
    FOREIGN KEY (Sigla, Letra) REFERENCES Turma(Sigla, Letra),
    FOREIGN KEY (Aluno) REFERENCES Aluno(NMatr)
);
