## Tabelas

### Pessoa

| Campo      | Tipo   | Restrições                                    |
| ---------- | ------ | --------------------------------------------- |
| last_name  | String | obrigatório, tamanho entre 2 e 500 caracteres |
| first_name | String | obrigatório, tamanho entre 2 e 500 caracteres |
| address    | String | obrigatório, tamanho entre 2 e 500 caracteres |
| city       | String | obrigatório, tamanho entre 2 e 500 caracteres |

### Endereço

| Campo    | Tipo   | Restrições                                    |
| -------- | ------ | --------------------------------------------- |
| street   | String | obrigatório, tamanho entre 2 e 500 caracteres |
| city     | String | obrigatório, tamanho entre 2 e 500 caracteres |
| state    | String | obrigatório, tamanho entre 2 e 500 caracteres |
| zip_code | String | obrigatório, tamanho entre 2 e 500 caracteres |

- Relação um para um com Pessoa

### Pedido

| Campo        | Tipo  | Restrições                     |
| ------------ | ----- | ------------------------------ |
| order_date   | Date  | obrigatório                    |
| total_amount | Float | obrigatório, valor maior que 0 |

- Relação um para muitos com Pessoa (uma pessoa pode fazer vários pedidos)

### Produto

| Campo | Tipo   | Restrições                                    |
| ----- | ------ | --------------------------------------------- |
| name  | String | obrigatório, tamanho entre 2 e 500 caracteres |
| price | Float  | obrigatório, valor maior que 0                |

- Relação muitos para muitos com Pedido (um pedido pode ter vários produtos e um produto pode estar em vários pedidos)
