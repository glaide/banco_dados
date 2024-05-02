### Pessoa

| Campo   | Tipo      | Restrições                                         |
|---------|-----------|----------------------------------------------------|
| ano     | Integer   | obrigatório, valor entre -1000 e 2023              |
| nome    | String    | obrigatório, tamanho entre 2 e 500 caracteres      |
| casa    | has_one   | Casa obrigatório                                   |
| resumo  | has_one   | Resumo obrigatório                                 |
| amigo   | has_and_belongs_to_many | Amigo                   |

- Caso uma pessoa seja excluída, todos os amigos que não tenham relação com outra pessoa devem ser excluídos, assim como o resumo relacionado à pessoa.

### Casa

| Campo   | Tipo   | Restrições                                         |
|---------|--------|----------------------------------------------------|
| endereco| String | obrigatório, tamanho entre 2 e 500, único          |
| pessoa  | has_many| Pessoa                                              |

- Caso seja excluída uma casa, todas as pessoas relacionadas a ela devem também ser excluídas.

### Amigo

| Campo   | Tipo   | Restrições                                         |
|---------|--------|----------------------------------------------------|
| nome    | String | obrigatório, tamanho entre 2 e 500 caracteres, único|
| pessoa  | has_and_belongs_to_many | Pessoa                    |

- Caso seja excluído um amigo, todas as pessoas que o possuam como único amigo devem ser excluídas.

### Resumo

| Campo   | Tipo   | Restrições                                         |
|---------|--------|----------------------------------------------------|
| texto   | Text   | obrigatório, tamanho entre 20 e 2000 caracteres, único|
| pessoa  | belongs_to| Pessoa obrigatório, único                          |



# Execução


Antes de iniciar o programa de interface, é necessário executar o script `criaTudo.sh`. 
Este script cria as relações do banco de dados e as preenche, utilizando o `populate.rb`. 
Ao finalizar, ele gera um arquivo chamado Tabelas.sqlite3, que armazena os dados do banco de dados.  Para interagir com o usuário, execute o programa `interface.rb`.
```bash
ruby interface.rb
```
Os comandos criados são listados a seguir:
# Comandos
Cada comando deve ser executado respeitando o seguinte padrão:

\<comando\> \<tabela\> campo="valor"

Ex:

    lista pessoas casa_id="1"



## tabelas

É o único comando que não utiliza nem tabela e em campos. Ele lista todas as tabelas presentes no arquivo gerado para o SQLite.

Ex:

    tabelas

Obs: apesar de imprimir a tabela amigoes_pessoas (que exite para a relação muitos para muitos), esta não poderá ser acessada diretamente.


## lista
Lista as entradas da tabela passada como parâmetro. Opcionalmente podem ser passados os campos que a entrada deve ter para ser listada. Caso sejam passados vários campos, são listadas as entradas que respeitem todas as condições.

Ex sem filtro:

    lista pessoas

Ex com fitros:

    lista pessoas ano="1968" casa_id="2"

## insere
Insere em dada tabela uma nova entrada especificada pelos campos passados. 
Porém, por conta das associações das tabelas, existem algumas limitações:

Como pessoas e resumos possuem uma relação um para um, ambos devem ser inseridos juntos, então também se deve adicionar um campo resumo durante a inserção de um pessoa.
Ex:

    insere pessoas nome="Bruna Garcia" ano="2000" casa_id="3" resumo="eu gosto de programar"

Como não é possível acessar diretamente a tabela amigoes_pessoas, esta associação é feita ao se inserir ou alterar um amigo. Ou seja, é necessário **primeiro ser inserido um pessoa para então se inserir seu amigo**. 
Para isso, ao se inserir um amigo, é necessário especificar seus pessoas, que devem ser declarados com um campo pessoas e passados os IDs dos pessoas separados por vírgula.
Ex:

    insere amigos nome="Bruno Souza" pessoas="0,3"

Faz com que seja inserido o amigo de nome Bruno Souza e associado as pessoas de IDs 0 - 3.

Então no caso de inserir uma casa, basta colocar seu nome:
Ex:

    insere casas nome="casa do jovem"

Caso seja válida a nova entrada, é retornado o seu ID de inserção. Caso contrário serão apresentados erros.

## exclui

Remove as entradas da tabela que possuam o valor dos campos passados. Caso sejam passados vários campos, são excluídas as entradas que respeitem todas as condições.

Ex:

    exclui pessoas ano="2000"
## altera
alias: `atualiza`

Atualiza os campos passados para serem atualizados de dada tabela. Serão atualizados todos os registros da tabela que atendam às condições dos campos passados. Para separar os valores de campo de busca e os novos valores, deve-se utilizar a palavra "para" e então o(s) novo(s) valor(es) dos campos devem ser passada.

Com isso, o padrão do comando é de:

\<comando\> \<tabela\> campo_busca="valor" **para** campo="novo valor"

Obs: é importante ressaltar que os valores dos campos de busca que precisam ser atendidos não precisam ser necessariamente aqueles a se atualizar.

Ex:

    altera pessoas ano="1968" para nome="pessoas de 1968 alterados"


## limpa
alias: `limpar`

Este é na verdade um comando auxiliar, usado para que possa limpar a tela do terminal. Ele só executa o comando ruby:
```ruby
puts `clear`
```

Ex:

    limpar
## sair
Encerra a execução do programa.
Ex:

    sair
