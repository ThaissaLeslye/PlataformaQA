-- -----------------------------------------------------
-- Carga de domínios e tabelas básicas
-- -----------------------------------------------------
USE qualidade_db;

-- Perfis de Acesso
INSERT INTO perfil (nome, ativo, descricao, codigo) VALUES 
('Administrador', 1, 'Acesso total ao sistema', 'ADM'),
('Analista', 1, ' Acesso a funções específicas e dados', 'ANL'),
('Gestor', 1, 'Acesso e gerenciamento de grupos ou áreas', 'GTR');

-- Cargos
INSERT INTO cargo (nome, ativo, descricao, perfil_codigo) VALUES 
('Analista de Qualidade 3', 1, '', 'analista-de-qualidade-3', 'ANL'),
('Analista de Qualidade 1', 1, '', 'analista-de-qualidade-1', 'ANL'),
('Lider de Qualidade', 1, '', 'lider-de-qualidade', 'GTR');

-- Tipos de Produto
INSERT INTO tipo_produto (nome) VALUES 
('Aplicação Web'),
('Desktop'),
('Mobile App');

-- Ferramentas de Teste
INSERT INTO ferramenta (nome) VALUES 
('Cypress'),
('Appium'),
('TestComplete'),
('FlowMobile');

-- Tipos de Teste
INSERT INTO tipo_teste (nome) VALUES 
('WEB'),
('API'),
('Desktop'),
('Mobile');

-- Permissões Iniciais
INSERT INTO permissao (nome, descricao, ativo, criticidade, codigo) VALUES 
('Visualizar Relatórios', 'Permite ver dashboards', 1, 'BAIXA', 'VIEW_REP'),
('Executar Pipeline', 'Permite trigger no Jenkins', 1, 'MEDIA', 'EXEC_PIPE');

-- Vínculo Perfil Admin com Permissões (Exemplo)
INSERT INTO perfil__permissao (perfil_id, permissao_id) 
SELECT p.id, perm.id FROM perfil p, permissao perm WHERE p.codigo = 'ADM';