-- -----------------------------------------------------
-- Criação das Estruturas (DDL) - Portal QA (Revisão 2)
-- -----------------------------------------------------
USE qualidade_db;

-- -----------------------------------------------------
-- Table perfil
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS perfil (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(45) NOT NULL UNIQUE,
  ativo TINYINT NOT NULL,
  descricao VARCHAR(255) NOT NULL,
  codigo VARCHAR(45) NOT NULL UNIQUE
);

-- -----------------------------------------------------
-- Table cargo
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS cargo (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL UNIQUE,
  ativo TINYINT NOT NULL,
  descricao VARCHAR(255) NOT NULL,
  codigo VARCHAR(45) NOT NULL UNIQUE,
  perfil_codigo VARCHAR(45) NOT NULL,
  
  CONSTRAINT fk_cargo__perfil
    FOREIGN KEY (perfil_codigo)
    REFERENCES perfil (codigo)
);

-- -----------------------------------------------------
-- Table entidade_alterada
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS entidade_alterada (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  entidade_afetada VARCHAR(255) NOT NULL,
  id_entidade_afetada INT NOT NULL
);

-- -----------------------------------------------------
-- Table evento
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS evento (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  tipo_acao ENUM('CRIACAO', 'ALTERACAO', 'EXCLUSAO', 'EXECUCAO') NOT NULL,
  data_evento DATETIME NOT NULL,
  entidade_alterada_id INT NOT NULL,
  
  CONSTRAINT fk_evento__entidade_alterada
    FOREIGN KEY (entidade_alterada_id)
    REFERENCES entidade_alterada (id)
);

-- -----------------------------------------------------
-- Table usuario
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS usuario (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(255) NOT NULL UNIQUE,
  email VARCHAR(255) NOT NULL UNIQUE,
  data_admissao DATE NOT NULL,
  ativo TINYINT NOT NULL,
  situacao ENUM('ATIVO', 'INATIVO', 'BLOQUEADO', 'AGUARDANDO') NOT NULL,
  ultimo_login DATE NULL,
  data_criacao DATE NULL,
  perfil_codigo VARCHAR(45) NOT NULL UNIQUE,
  cargo_codigo VARCHAR(45) NOT NULL UNIQUE,
  evento_id INT NULL,
  
  CONSTRAINT fk_usuario__perfil
    FOREIGN KEY (perfil_codigo)
    REFERENCES perfil (codigo),
    
  CONSTRAINT fk_usuario__cargo
    FOREIGN KEY (cargo_codigo)
    REFERENCES cargo (codigo),
    
  CONSTRAINT fk_usuario__evento
    FOREIGN KEY (evento_id)
    REFERENCES evento (id)
);

-- -----------------------------------------------------
-- Table unidade_negocio
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS unidade_negocio (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL UNIQUE,
  observacao VARCHAR(255) NULL,
  ativo TINYINT NOT NULL,
  data_cadastro DATE NOT NULL,
  data_ultima_atualizacao DATE NOT NULL,
  usuario_id INT NOT NULL,
  
  CONSTRAINT fk_unidade_negocio__usuario
    FOREIGN KEY (usuario_id)
    REFERENCES usuario (id)
);

-- -----------------------------------------------------
-- Table tipo_produto
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS tipo_produto (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(45) NOT NULL UNIQUE
);

-- -----------------------------------------------------
-- Table produto
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS produto (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(255) NOT NULL UNIQUE,
  codigo VARCHAR(45) NOT NULL UNIQUE,
  observacao VARCHAR(255) NULL,
  ativo TINYINT NOT NULL,
  data_cadastro DATE NOT NULL,
  data_ultima_atualizacao DATE NOT NULL,
  unidade_negocio_id INT NOT NULL,
  tipo_produto_id INT NOT NULL,
  
  CONSTRAINT fk_produto__unidade_negocio
    FOREIGN KEY (unidade_negocio_id)
    REFERENCES unidade_negocio (id),
    
  CONSTRAINT fk_produto__tipo_produto
    FOREIGN KEY (tipo_produto_id)
    REFERENCES tipo_produto (id)
);

-- -----------------------------------------------------
-- Table ferramenta
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS ferramenta (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(45) NOT NULL UNIQUE
);

-- -----------------------------------------------------
-- Table tipo_teste
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS tipo_teste (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(45) NOT NULL UNIQUE
);

-- -----------------------------------------------------
-- Table suite_teste
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS suite_teste (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(45) NOT NULL UNIQUE,
  observacao TEXT NULL,
  observacao_externa TEXT NULL,
  data_ultima_atualizacao DATETIME NOT NULL,
  data_ultima_exec DATETIME NULL,
  url_repositorio VARCHAR(2048) NOT NULL,
  url_pipeline VARCHAR(2048) NOT NULL,
  url_relatorio VARCHAR(2048) NOT NULL,
  produto_id INT NOT NULL,
  ferramenta_id INT NULL,
  tipo_teste_id INT NULL,
  
  CONSTRAINT fk_suite_teste__produto
    FOREIGN KEY (produto_id)
    REFERENCES produto (id),
    
  CONSTRAINT fk_suite_teste__ferramenta
    FOREIGN KEY (ferramenta_id)
    REFERENCES ferramenta (id),
    
  CONSTRAINT fk_suite_teste__tipo_teste
    FOREIGN KEY (tipo_teste_id)
    REFERENCES tipo_teste (id)
);

-- -----------------------------------------------------
-- Table execucao_suite
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS execucao_suite (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  data_hora DATETIME NOT NULL,
  duracao TIME NOT NULL,
  resultado ENUM('PASSOU', 'FALHOU', 'IGNORADO') NOT NULL,
  suite_teste_id INT NULL,
  
  CONSTRAINT fk_execucao_suite__suite_teste
    FOREIGN KEY (suite_teste_id)
    REFERENCES suite_teste (id)
);

-- -----------------------------------------------------
-- Table resultado_cenario
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS resultado_cenario (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  id_cenario INT NOT NULL,
  titulo VARCHAR(255) NOT NULL,
  resultado ENUM('PASSOU', 'FALHOU', 'IGNORADO') NOT NULL,
  execucao_suite_id INT NOT NULL,
  
  CONSTRAINT fk_resultado_cenario__execucao_suite
    FOREIGN KEY (execucao_suite_id)
    REFERENCES execucao_suite (id)
);

-- -----------------------------------------------------
-- Table resultado_caso_teste
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS resultado_caso_teste (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  id_caso_teste INT NOT NULL,
  titulo VARCHAR(255) NOT NULL,
  resultado ENUM('PASSOU', 'FALHOU', 'IGNORADO') NOT NULL,
  log_erro TEXT NOT NULL,
  resultado_cenario_id INT NOT NULL,
  
  CONSTRAINT fk_resultado_caso_teste__resultado_cenario
    FOREIGN KEY (resultado_cenario_id)
    REFERENCES resultado_cenario (id)
);

-- -----------------------------------------------------
-- Table demanda_jira
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS demanda_jira (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  url_demanda VARCHAR(2048) NOT NULL,
  suite_teste_id INT NOT NULL,
  
  CONSTRAINT fk_demanda_jira__suite_teste
    FOREIGN KEY (suite_teste_id)
    REFERENCES suite_teste (id)
);

-- -----------------------------------------------------
-- Table palavra_chave
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS palavra_chave (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  palavra VARCHAR(45) NOT NULL UNIQUE,
  oficial TINYINT NOT NULL
);

-- -----------------------------------------------------
-- Table cenario_teste
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS cenario_teste (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  titulo VARCHAR(255) NOT NULL,
  ultimo_resultado ENUM('PASSOU', 'FALHOU', 'IGNORADO') NOT NULL,
  suite_teste_id INT NULL,
  
  CONSTRAINT fk_cenario_teste__suite_teste
    FOREIGN KEY (suite_teste_id)
    REFERENCES suite_teste (id)
);

-- -----------------------------------------------------
-- Table caso_teste
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS caso_teste (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  titulo VARCHAR(255) NOT NULL,
  ultimo_resultado ENUM('PASSOU', 'FALHOU', 'IGNORADO') NOT NULL,
  cenario_teste_id INT NULL,
  
  CONSTRAINT fk_caso_teste__cenario_teste
    FOREIGN KEY (cenario_teste_id)
    REFERENCES cenario_teste (id)
);

-- -----------------------------------------------------
-- Table propriedade_alterada
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS propriedade_alterada (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  propriedade VARCHAR(255) NOT NULL, 
  valor_antigo TEXT NOT NULL,
  valor_novo TEXT NOT NULL,
  evento_id INT NOT NULL,
  
  CONSTRAINT fk_propriedade_alterada__evento
    FOREIGN KEY (evento_id)
    REFERENCES evento (id)
);

-- -----------------------------------------------------
-- Table permissao
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS permissao (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL UNIQUE,
  descricao VARCHAR(255) NOT NULL,
  ativo TINYINT NOT NULL,
  criticidade ENUM('BAIXA', 'MEDIA', 'ALTA', 'CRITICA') NOT NULL,
  codigo VARCHAR(45) NOT NULL UNIQUE
);

-- -----------------------------------------------------
-- Table palavra_chave__suite_teste
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS palavra_chave__suite_teste (
  palavra_chave_id INT NOT NULL,
  suite_teste_id INT NOT NULL,
  
  CONSTRAINT fk_palavra_chave__suite_teste___palavra_chave
    FOREIGN KEY (palavra_chave_id)
    REFERENCES palavra_chave (id),
    
  CONSTRAINT fk_palavra_chave__suite_teste___suite_teste
    FOREIGN KEY (suite_teste_id)
    REFERENCES suite_teste (id)
);

-- -----------------------------------------------------
-- Table usuario__produto
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS usuario__produto (
  usuario_id INT NOT NULL,
  produto_id INT NOT NULL,
  
  CONSTRAINT fk_usuario__produto___usuario
    FOREIGN KEY (usuario_id)
    REFERENCES usuario (id),
    
  CONSTRAINT fk_usuario__produto___produto
    FOREIGN KEY (produto_id)
    REFERENCES produto (id)
);

-- -----------------------------------------------------
-- Table perfil__permissao
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS perfil__permissao (
  perfil_id INT NOT NULL,
  permissao_id INT NOT NULL,
  
  CONSTRAINT fk_perfil__permissao___perfil
    FOREIGN KEY (perfil_id)
    REFERENCES perfil (id),
    
  CONSTRAINT fk_perfil__permissao___permissao
    FOREIGN KEY (permissao_id)
    REFERENCES permissao (id)
);