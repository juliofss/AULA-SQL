CREATE TABLE Usuario(
    ID INT NOT NULL IDENTITY (1,1)
    ,Login VARCHAR(100) NOT NULL
    ,Senha VARCHAR(20) NOT NULL
    ,DtExpiracao DATE NOT NULL CONSTRAINT df_DtExpiracao DEFAULT('19000101')
    ,CONSTRAINT pk_IDUsuario PRIMARY KEY(ID)
    ,CONSTRAINT uq_UserLogin UNIQUE(Login)
)

CREATE TABLE Coordenador (
    ID INT NOT NULL IDENTITY (1,1)
    ,Id_usuario INT NOT NULL
    ,Nome VARCHAR(255) NOT NULL
    ,Email VARCHAR(100) NOT NULL
    ,Celular CHAR(11) NOT NULL
    ,CONSTRAINT pkCoordenadorID PRIMARY KEY(ID)
    ,CONSTRAINT fkCoordenador_Id_usuario FOREIGN KEY(Id_usuario) REFERENCES Usuario(ID)
    ,CONSTRAINT uqCoordenadorEmail UNIQUE(Email)
    ,CONSTRAINT uqCoordenadorCelular UNIQUE(Celular)
)

CREATE TABLE Aluno (
    ID INT NOT NULL IDENTITY (1,1)
    ,Id_usuario INT NOT NULL
    ,Nome VARCHAR(255) NOT NULL
    ,Email VARCHAR(100) NOT NULL
    ,Celular CHAR(11) NOT NULL
    ,RA CHAR(7) NOT NULL
    ,Foto VARCHAR(255)
    ,CONSTRAINT pkAlunoID PRIMARY KEY(ID)
    ,CONSTRAINT fkAlunoId_usuario FOREIGN KEY(Id_usuario) REFERENCES Usuario(ID)
    ,CONSTRAINT uqAlunoEmail UNIQUE(Email)
    ,CONSTRAINT uqAlunoCelular UNIQUE(Celular)
)

CREATE TABLE Professor (
    ID INT NOT NULL IDENTITY (1,1)
    ,Id_usuario INT NOT NULL
    ,Email VARCHAR(100) NOT NULL
    ,Celular CHAR(11) NOT NULL
    ,Apelido VARCHAR(100) NOT NULL
    ,CONSTRAINT pkProfessorID PRIMARY KEY(ID)
    ,CONSTRAINT fkProfessorId_usuario FOREIGN KEY(Id_usuario) REFERENCES Usuario(ID)
    ,CONSTRAINT uqProfessorEmail UNIQUE(Email)
    ,CONSTRAINT uqProfessorCelular UNIQUE(Celular)
)

CREATE TABLE Disciplina(
    ID INT NOT NULL IDENTITY (1,1)
    ,Nome VARCHAR(100) NOT NULL
    ,Datadisciplina DATE NOT NULL CONSTRAINT dfDisciplinaDataDisciplina DEFAULT(GETDATE())
    ,StatusDisciplina CHAR(7) NOT NULL CONSTRAINT dfDisciplinaStatus DEFAULT('ABERTA')
    ,PlanoDeEnsino VARCHAR(255) NOT NULL
    ,CargaHoraria INT NOT NULL
    ,Competencias VARCHAR(255) NOT NULL
    ,Habilidades VARCHAR(255) NOT NULL
    ,Ementa VARCHAR(255) NOT NULL
    ,ConteudoProgramatico VARCHAR(255) NOT NULL
    ,BibliografiaBasica VARCHAR(255) NOT NULL
    ,BibliografiaComplementar VARCHAR(255) NOT NULL
    ,PercentualPratico INT NOT NULL
    ,PercentualTeorico INT NOT NULL
    ,IdCoordenador INT NOT NULL
    ,CONSTRAINT pkDisciplinaID PRIMARY KEY (ID)
    ,CONSTRAINT uqDisciplinaNome UNIQUE (Nome)
    ,CONSTRAINT ckDisciplinaCargaHoraria CHECK(CargaHoraria IN (40,80))
    ,CONSTRAINT ckDisciplinaStatus CHECK(StatusDisciplina IN ('Aberto','Fechado'))
    ,CONSTRAINT ckdisciplinaPercentualPratico CHECK (PercentualPratico BETWEEN 00 AND 100 )
    ,CONSTRAINT ckDisciplinaPercentualTeorico CHECK (PercentualTeorico BETWEEN 00 AND 100 )
    ,CONSTRAINT fkDiscipinaIdCoordenador FOREIGN KEY (IdCoordenador) REFERENCES Coordenador(ID)
)

CREATE TABLE Curso (
    Id INT NOT NULL IDENTITY (1,1)
    ,Nome VARCHAR(100) NOT NULL
    ,CONSTRAINT pkCursoID PRIMARY KEY (ID)
    ,CONSTRAINT uqCursoNome UNIQUE (Nome)
)

CREATE TABLE DisciplinaOfertada (
    ID INT NOT NULL IDENTITY (1,1)
    ,IdCoordenador INT NOT NULL
    ,DtInicioMatricula DATE 
    ,DtFimMatricula DATE
    ,IdDisciplina INT NOT NULL
    ,IdCurso INT NOT NULL
    ,Ano INT NOT NULL
    ,Semestre TINYINT NOT NULL
    ,Turma CHAR(2) NOT NULL
    ,IdProfessor INT 
    ,Metodologia VARCHAR(255)
    ,Recursos VARCHAR(255)
    ,CriterioAvaliacao VARCHAR(255)
    ,PlanoDeAulas VARCHAR(255)   
    ,CONSTRAINT pkDisciplinaOfertadaID PRIMARY KEY(ID)
    ,CONSTRAINT fkDisciplinaOfertadaIdCoordenador FOREIGN KEY(IdCoordenador) REFERENCES Coordenador(ID)
    ,CONSTRAINT fkDisciplinaOfertadaIdDisciplina FOREIGN KEY(IdDisciplina) REFERENCES Disciplina(ID)
    ,CONSTRAINT fkDisciplinaOfertadaIdCurso FOREIGN KEY(IdCurso) REFERENCES Curso(ID)
    ,CONSTRAINT ckDisciplinaOfertadaAno CHECK(Ano BETWEEN YEAR('1900/01/01') AND YEAR('2100/12/31'))
    ,CONSTRAINT ckDisciplinaOfertadaSemestre CHECK(Semestre IN(1,2))
    ,CONSTRAINT ckDisciplinaOfertadaTurma CHECK (Turma BETWEEN 'A' and 'Z')
    ,CONSTRAINT fkDisciplinaOfertadaIdProfessor FOREIGN KEY(IdProfessor) REFERENCES Professor(ID)
	,CONSTRAINT uqDisciplinaOfertadaDiscCurAnoSemTur UNIQUE(IdDisciplina,IdCurso,Ano,Semestre,Turma)
)

CREATE TABLE SolicitacaoMatricula (
    ID INT NOT NULL IDENTITY (1,1)
    ,Idaluno INT NOT NULL
    ,IdDisciplinaOfertada INT NOT NULL
    ,DtSolicitacao DATE NOT NULL CONSTRAINT dfSolicitacaoMatriculaDtsolicitacao DEFAULT(GETDATE())
    ,IdCoordenador INT 
    ,Status VARCHAR(10) CONSTRAINT dfSolicitacaoMatriculaStatus DEFAULT ('Solicitada')
    ,CONSTRAINT pksolicitacaoMatriculaID PRIMARY KEY(ID)
    ,CONSTRAINT fkSolicitacaoMatriculaIdDisciplinaOfertada FOREIGN KEY(IdDisciplinaOfertada) REFERENCES DisciplinaOfertada(ID) 
    ,CONSTRAINT fkSolicitacaoMatriculaIdCoordenador FOREIGN KEY(IdCoordenador) REFERENCES Coordenador(ID)
    ,CONSTRAINT ckSolicitacaoMatriculaStatus CHECK(Status IN('Solicitada', 'Aprovada', 'Cancelada', 'Rejeitada'))  
	,CONSTRAINT uqSolicitacaoMatriculaAluDisc UNIQUE(Idaluno,IdDisciplinaOfertada)
)

CREATE TABLE Atividade (
	ID INT NOT NULL IDENTITY(1,1)
	,Titulo VARCHAR(100) NOT NULL
	,Descricao VARCHAR(255)
	,Conteudo VARCHAR(100) NOT NULL
	,Tipo VARCHAR(100) NOT NULL
	,Extras VARCHAR(255)
	,IdProfessor INT NOT NULL
	CONSTRAINT pkAtividade PRIMARY KEY(ID),
	CONSTRAINT fkAtividadeIdProfessor FOREIGN KEY(IdProfessor) REFERENCES Professor(ID),
	CONSTRAINT uqAtividadeTitulo UNIQUE(Titulo),
	CONSTRAINT ckAtividadeTipo CHECK(Tipo IN ('Resposta Aberta', 'Teste'))
)

CREATE TABLE AtividadeVinculada (
    ID INT NOT NULL IDENTITY (1,1)
    ,IdAtividade INT NOT NULL
    ,IdProfessor INT NOT NULL
    ,IdDisciplinaOfertada INT NOT NULL
    ,Rotulo VARCHAR(100) NOT NULL
    ,Status VARCHAR(15) NOT NULL
    ,DtInicioRespostas DATE NOT NULL
    ,dtFimRespostas DATE NOT NULL
    ,CONSTRAINT pkAtividadeVinculadaID PRIMARY KEY(ID)
    ,CONSTRAINT fkAtividadeVinculadaIdatividade FOREIGN KEY(IdAtividade) REFERENCES Atividade(ID)
    ,CONSTRAINT fkAtividadeVinculadaIdProfessor FOREIGN KEY(IdProfessor) REFERENCES Professor(ID)
    ,CONSTRAINT fkAtividadeVinculadaIdDisciplinaOfertada FOREIGN KEY (IdDisciplinaOfertada) REFERENCES DisciplinaOfertada(ID)
	,CONSTRAINT uqAtividadeVinculadaAtivDisciRot UNIQUE(IdAtividade,IdDisciplinaOfertada,Rotulo)
)

CREATE TABLE Entrega (
	ID INT NOT NULL IDENTITY(1,1),
	IdAluno INT NOT NULL,
	IdAtividadeVinculada INT NOT NULL,
	Titulo VARCHAR(100) NOT NULL,
	Resposta VARCHAR(100) NOT NULL,
	DtEntrega DATE NOT NULL CONSTRAINT dfEntregaDtEntrega DEFAULT(GETDATE()),
	Status VARCHAR(9) NOT NULL CONSTRAINT dfEntregaStatus DEFAULT('Entregue'),
	IdProfessor INT,
	Nota NUMERIC(4,2),
	DtAvaliacao DATE,
	Obs VARCHAR(255),
	CONSTRAINT pkEntrega PRIMARY KEY(ID),
	CONSTRAINT fkEntregaIdAluno FOREIGN KEY(IdAluno) REFERENCES Aluno(ID),
	CONSTRAINT fkEntregaIdAtividadeVinculada FOREIGN KEY(IdAtividadeVinculada) REFERENCES AtividadeVinculada(ID),
	CONSTRAINT fkEntregaIdProfessor FOREIGN KEY(IdProfessor) REFERENCES Professor(ID),
	CONSTRAINT ckEntregaStatus CHECK(Status IN ('Entregue', 'Corrigido')),
	CONSTRAINT ckEntregaNota CHECK(Nota >= 0.00 and Nota <= 10.00),
	CONSTRAINT uqEntregaIdAlunoIdAtiVinc UNIQUE(IdAluno, IdAtividadeVinculada)
)

CREATE TABLE Mensagem (
	ID INT NOT NULL IDENTITY(1,1),
	IdAluno INT NOT NULL,
	IdProfessor INT NOT NULL,
	Assunto VARCHAR(100) NOT NULL,
	Referencia VARCHAR(255) NOT NULL,
	Conteudo VARCHAR(255) NOT NULL,
	Status VARCHAR(10) NOT NULL CONSTRAINT dfMensagemAssunto DEFAULT('Enviado'),
	DtEnvio DATE NOT NULL CONSTRAINT dfMensagemDtEnvio DEFAULT(GETDATE()),
	DtResposta DATE,
	Resposta VARCHAR(255),
	CONSTRAINT pkMensagem PRIMARY KEY(ID),
	CONSTRAINT fkMensagemIdAluno FOREIGN KEY(IdAluno) REFERENCES Aluno(ID),
	CONSTRAINT fkMensagemIdProfessor FOREIGN KEY(IdProfessor) REFERENCES Professor(ID),
	CONSTRAINT ckMensagemStatus CHECK(Status IN ('Enviado','Lido','Respondido'))
)
