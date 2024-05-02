rm -f Tabelas.sqlite3
echo -n "Criando novos amigos"
ruby amigo/criaAmigos.rb
echo "Novos amigos criados com sucesso."

echo -n "Criando novas casas."
ruby casa/criaCasas.rb
echo "Novas casas criadas com sucesso."

echo -n "Criando novas pessoas."
ruby pessoa/criaPessoas.rb
echo "Novas pessoas criadas com sucesso."

echo -n "Criando novos resumos."
ruby resumo/criaResumos.rb
echo "Novos resumos criados com sucesso."




echo -n "Populando..."
ruby populate.rb  
echo "Populado com sucesso."