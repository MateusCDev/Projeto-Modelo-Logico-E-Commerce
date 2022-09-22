-- Criação do banco de dados para E-Commerce
DROP DATABASE ecommerce;
CREATE DATABASE ecommerce;
USE ecommerce;

-- Criando tabela cliente
CREATE TABLE cliente(
	idCliente INT AUTO_INCREMENT PRIMARY KEY,
    Fname VARCHAR(15) NOT NULL,
    Mname CHAR(3),
	Lname VARCHAR(20),
    TipoCliente ENUM('PJ','PF') NOT NULL,
    CPF CHAR(11),
    CNPJ CHAR(15),
    Endereco VARCHAR(500),
    CONSTRAINT unique_CPF_cliente UNIQUE (CPF),
	CONSTRAINT unique_CNPJ_cliente UNIQUE (CNPJ)
);

ALTER TABLE cliente AUTO_INCREMENT=1;
DESC cliente;

-- Criando tabela produto

CREATE TABLE produto(
	idProduto INT AUTO_INCREMENT PRIMARY KEY,
    Pname VARCHAR(15) NOT NULL,
    Classificacao_Kids BOOL DEFAULT FALSE,
    Categoria ENUM('Eletrônico', 'Vestimenta', 'Brinquedos', 'Alimentos', 'Moveis') NOT NULL,
	Avaliacao FLOAT DEFAULT 0,
    Dimensoes VARCHAR(10)
);

ALTER TABLE produto AUTO_INCREMENT=1;
DESC produto;

-- Criando tabela pedido
CREATE TABLE pedido(
	idPedido INT AUTO_INCREMENT PRIMARY KEY,
    idPedidoCliente INT,
    PedidoStatus ENUM('Cancelado','Confirmado','Em processamento') DEFAULT 'Em Processamento',
    Descricao VARCHAR(255),
    Frete FLOAT DEFAULT 10,
    CONSTRAINT fk_Pedido_Cliente FOREIGN KEY (idPedidoCliente) REFERENCES cliente(idCliente)
		ON UPDATE CASCADE
);

ALTER TABLE pedido AUTO_INCREMENT=1;
DESC pedido;

-- Criando tabela pagamento
CREATE TABLE pagamento(
	idPagamento INT AUTO_INCREMENT NOT NULL,
	idPagamentoPedido INT,
	TipoPagamento ENUM('Pix', 'Boleto', 'Credito', 'Debito') NOT NULL,
	Limite FLOAT,
	ValidadeCartao DATE,
    Valor FLOAT NOT NULL,
	PRIMARY KEY(idPagamento, idPagamentoPedido),
	CONSTRAINT fk_Pagamento_Pedido FOREIGN KEY (idPagamentoPedido) REFERENCES pedido(idPedido)
);

ALTER TABLE pagamento AUTO_INCREMENT=1;
DESC pagamento;

-- Criando tabela entrega
CREATE TABLE entrega(
	idEntrega INT AUTO_INCREMENT PRIMARY KEY,
    idEntregaPedido INT,
    entregaStatus ENUM ('Embalando','Em preparação','A caminho', 'Entregue') NOT NULL,
    codigoRastreio CHAR(13)NOT NULL,
    CONSTRAINT unique_codigo_entrega UNIQUE (codigoRastreio),
    CONSTRAINT fk_entrega_Pedido FOREIGN KEY (idEntregaPedido) REFERENCES pedido(idPedido)
);

ALTER TABLE entrega AUTO_INCREMENT=1;
DESC entrega;

-- Criando tabela estoque
CREATE TABLE estoque(
	idEstoque INT AUTO_INCREMENT PRIMARY KEY,
    Local_Estoque VARCHAR (255),
    Quantidade INT DEFAULT 0
);


ALTER TABLE estoque AUTO_INCREMENT=1;
DESC estoque;

-- Criando tabela fornecedor
CREATE TABLE fornecedor(
	idFornecedor INT AUTO_INCREMENT PRIMARY KEY,
    RazaoSocial VARCHAR(45) NOT NULL,
    CNPJ CHAR(15) NOT NULL,
    Contato CHAR(11) NOT NULL,
    CONSTRAINT unique_CNPJ_fornecedor UNIQUE(CNPJ)
);

ALTER TABLE fornecedor AUTO_INCREMENT=1;
DESC fornecedor;
    
-- Criando tabela vendedor

CREATE TABLE vendedor(
	idVendedor INT AUTO_INCREMENT PRIMARY KEY,
    RazaoSocial VARCHAR(45) NOT NULL,
	NomeFantasia VARCHAR (45),
    CNPJ CHAR(15),
    CPF CHAR(9),
    Local_Vendedor VARCHAR(255),
    Contato CHAR(11) NOT NULL,
    CONSTRAINT unique_Rsocial_vendedor UNIQUE(RazaoSocial),
    CONSTRAINT unique_CNPJ_vendedor UNIQUE(CNPJ),
    CONSTRAINT unique_CPF_vendedor UNIQUE(CPF)
);


ALTER TABLE vendedor AUTO_INCREMENT=1;
DESC vendedor;

-- Criando tabelas de relação
CREATE TABLE produtoVendedor(
	idPvendedor INT,
    idProduto INT,
    Quantidade INT DEFAULT 1,
    PRIMARY KEY(idPvendedor, idProduto),
    CONSTRAINT fk_produto_vendedor FOREIGN KEY (idPvendedor) REFERENCES vendedor(idVendedor),
    CONSTRAINT fk_produto_produto FOREIGN KEY (idProduto) REFERENCES produto(idProduto)
);

DESC produtoVendedor;

CREATE TABLE produtoPedido(
	idPPproduto INT,
    idPPpedido INT,
    ppQuantidade INT DEFAULT 1,
    ppStatus ENUM('Disponivel','Sem estoque') DEFAULT 'Disponivel',
    PRIMARY KEY(idPPproduto, idPPpedido),
    CONSTRAINT fk_produto_pedido FOREIGN KEY (idPPpedido) REFERENCES pedido(idPedido),
    CONSTRAINT fk_produtoPedido_produto FOREIGN KEY (idPPproduto) REFERENCES produto(idProduto)
);

DESC produtoPedido;

CREATE TABLE estoqueLocal(
	idLproduto INT,
    idLestoque INT,
    Local_estoque VARCHAR(255) NOT NULL,
    PRIMARY KEY(idLproduto, idLestoque),
    CONSTRAINT fk_produtoEstoque_produto FOREIGN KEY (idLproduto) REFERENCES produto(idProduto),
    CONSTRAINT fk_estoque_fornecedor FOREIGN KEY (idLestoque) REFERENCES estoque(idEstoque)
);

DESC estoqueLocal;

CREATE TABLE produtoFornecedor(
	idPFfornecedor INT,
    idPFproduto INT,
    Quantidade INT NOT NULL,
    PRIMARY KEY (idPFfornecedor, idPFproduto),
    CONSTRAINT fk_produtoFornecedor_fornecedor FOREIGN KEY (idPFfornecedor) REFERENCES fornecedor(idFornecedor),
    CONSTRAINT fk_produtoFornecedor_produto FOREIGN KEY (idPFproduto) REFERENCES produto(idProduto)
);

DESC produtoFornecedor;




