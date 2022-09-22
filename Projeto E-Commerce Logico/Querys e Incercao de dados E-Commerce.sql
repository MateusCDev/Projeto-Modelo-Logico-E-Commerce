USE ecommerce;

-- Persistindo de dados
INSERT INTO cliente(Fname, Mname, Lname, TipoCliente, CPF, CNPJ, endereco)
           VALUES('Maria', 'E', 'Cesar','PF', '46588915433',null,'Rua: A Conjunto Stanta Cruz 12, BR-BA/Candeias'),
				 ('Mateus', 'C', 'Araujo','PF', '08567796584',null, 'Rua: A Conjunto Stanta Cruz 12, BR-BA/Candeias'),
				 ('Silvia', 'C', 'Jesus','PJ', null ,'26621352000158', 'Av: Augusto Vital Brasil, BR-SP/São Caetano do SUL');
				
                    
INSERT INTO produto (Pname, Classificacao_Kids, Categoria, Avaliacao, Dimensoes)				
			VALUES('PlayStation 5',false,'Eletrônico','5',null),
				  ('Martelo do THor',false,'Brinquedos','4',null),
                  ('Beterraba',false,'Alimentos','2',null);

INSERT INTO pedido(idPedidoCliente, PedidoStatus, Descricao, Frete)
			VALUES(1,'Cancelado','Compra via APP', 50.0),
				  (2,default,'Compra via APP', 70.0),
                  (3,'Confirmado','Compra via WEB',null);

INSERT INTO pagamento(idPagamentoPedido, TipoPagamento, Limite, ValidadeCartao, Valor)
			VALUES(1,'Debito','5000',20280802,350),
                  (2,'PIX',null,null,1500),
                  (3,'Credito','10000',20301225,5050);

INSERT INTO entrega(idEntregaPedido, entregaStatus, codigoRastreio)
			VALUES(1,'Embalando','SL123456789BR'),
				  (2,'Entregue','SB123456789EU'),
                  (3,'A caminho','AA123456789BR');
                  
INSERT INTO produtoPedido(idPPproduto, idPPpedido, ppQuantidade, ppStatus)
			VALUES(1,1,2,null),	
				  (2,2,1,null),
                  (3,3,1,null);
                  
INSERT INTO estoque(Local_Estoque, Quantidade)
			VALUES('Bahia',2000),
				  ('São Paulo',550),
                  ('Parana',1050);
                  
INSERT INTO estoqueLocal(idLproduto, idLestoque, Local_estoque)
			VALUES(1,1,'BA'),
				  (2,2,'SP'),
                  (3,3,'PR');
                  
INSERT INTO fornecedor(RazaoSocial,CNPJ,Contato)
			VALUES('Cometa & CIA',123456789123456,'12345678'),
				  ('Pardal Alimentos',987654321987656,'12345678');
                  
INSERT INTO  produtoFornecedor(idPFfornecedor,idPFproduto, Quantidade)
			VALUES(1,1,1000),
				  (1,2,2000),
                  (2,2,500);

INSERT INTO vendedor(RazaoSocial, NomeFantasia, CNPJ, CPF, Local_Vendedor, Contato)
			VALUES('BIG BIG LTDA',null,123456789123456,0846779658,'Bahia',7191404976);
            
INSERT INTO produtoVendedor(idPvendedor,idProduto,Quantidade)
			VALUES(1,1,50),
				  (1,2,10);	
                  
DESC produtoVendedor; 

-- Verificação das tabelas e constraints
SHOW TABLES;
SHOW DATABASES;
USE information_schema;
DESC referential_constraints;
SELECT * FROM referential_constraints WHERE constraint_schema = 'ecommerce'; 
 
-- QUERYS
SELECT * FROM produtoVendedor;

SELECT count(*) FROM cliente;
SELECT * FROM cliente c, pedido p WHERE c.idCliente = idPedidoCliente;

SELECT Fname, Lname, idPedido, PedidoStatus FROM cliente c, pedido p WHERE c.idCliente = idPedidoCliente;
SELECT concat(Fname,' ',Lname) AS Cliente, idPedido AS Pedido, PedidoStatus AS Status_Pedido 
	FROM cliente c, pedido p WHERE c.idCliente = idPedidoCliente;
    
SELECT * FROM cliente
	LEFT OUTER JOIN pedido ON idCliente = idPedidoCliente;

-- Recuperando quantos pedidos foram realizados por cliente
SELECT idCliente, Fname,  count(*) AS Nunero_de_pedidos FROM cliente
	INNER JOIN pedido ON idCliente = idPedidoCliente
	GROUP BY idCliente;  
    
--  Algum vendedor também é fornecedor? 
SELECT  V.RazaoSocial AS Vendedor,  F.RazaoSocial AS Fornecedor FROM fornecedor AS F, vendedor AS V 
		WHERE V.CNPJ = F.CNPJ;
        
-- Valor por produto comprado, o nome do produto e a quantidade comprada?
SELECT  Valor AS ValorDoProduto, Pname AS Produto, count(ppQuantidade) AS Quantidade, Valor * ppQuantidade AS Total 
		FROM pagamento, produtoPedido, produto
		WHERE idPagamento = idPPpedido AND idProduto = idPPproduto; 
 
-- Quantidade de Clientes que tenham um limite de pagamento maior ou igual 3000 onde o cliente seja PF ?
SELECT * FROM pagamento;
SELECT DISTINCT Count(idCliente) AS Quantidade_de_clientes, Limite, TipoCliente FROM pagamento, cliente 
		WHERE limite>=3000 GROUP BY idCliente
        HAVING TipoCliente = 'PF'
        ORDER BY Limite; 
 
-- Relacionamento estoque - produto?
SELECT Local_estoque AS Localização ,Pname AS Produto, Categoria, Avaliacao
	FROM  estoqueLocal 
    LEFT OUTER JOIN  produto ON  idLproduto = idProduto 
    GROUP BY Avaliacao;


	