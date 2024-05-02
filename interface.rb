# -*- coding: utf-8 -*-
$:.push "./"
require "resumo/resumo.rb"
require "pessoa/pessoa.rb"
require "casa/casa.rb"
require "amigo/amigo.rb"

$todas_tabelas = {
  "amigos" => Amigo,
  "pessoas" => Pessoa,
  "resumos" => Resumo,
  "casas" => Casa,
}

# Transforma uma string de entrada em uma hash conforme o padrão
# dado de exemplo pelo professor.
# Exemplo de entrada: 'id="3" nome="Exemplo"'
# Saida: {"id"=>"3", "nome"=>"Exemplo"}
def strToHash(val)
  return nil if val == ""
  h = Hash.new

  while val != nil
    # vamos separar os valores para inserir entre campo e valor
    val = val.split("\" ", 2)
    separa = val[0].split("\=")

    campo = separa[0]
    valor = separa[1]
    # tira as aspas e pula linha do valor
    if not valor.is_a? String
      puts "Formatação incorreta"
      return nil
    end
    valor = valor.gsub("\"", "")
    valor = valor.gsub("\n", "")

    h[campo] = valor
    val = val[1]
  end
  return h
end

# Verifica se o resultado na busca do active_record é vazio
def resultadoVazio(res_busca)
  vazio = false
  # Se a hash de busca tiver erros, o método blank?
  # encerra o programa e joga erros na sua cara
  begin
    vazio = res_busca.blank?
  rescue => e
    vazio = true
  end
  return vazio
end

# Transforma a string de entrada em uma classe do active_record
# com base no hash definido em $todas_tabelas
def obtemTabela(nome_tabela)
  if not $todas_tabelas.has_key?(nome_tabela)
    puts "Tabela #{nome_tabela} não encontrada"
    return nil
  end
  return $todas_tabelas[nome_tabela]
end

def buscaTabela(nome_tabela, condicoes = "")
  tabela = obtemTabela(nome_tabela)
  return if tabela == nil

  entradas = tabela.all
  # busca por entradas que atendam à condição
  if condicoes != ""
    h = strToHash(condicoes)
    entradas = tabela.where(h)
  end

  # não tem o que listar
  if resultadoVazio(entradas)
    puts "Entrada(s) não encontrada(s)"
    return nil
  end
  return entradas
end

# Imprime na saida padrão os dados da tabela de nome nome_tabela.
# Opcionalmente pode ser passada uma String que se tornará hash
# com a função strToHash com condições para buscar entradas que as atendam
def listaTabela(nome_tabela, condicoes = "")
  tabela = obtemTabela(nome_tabela)
  return if tabela == nil

  entradas = buscaTabela(nome_tabela, condicoes)
  return if entradas == nil
  colunas = entradas.column_names

  entradas.each do |entrada|
    info = []
    colunas.each do |col|
      impressao = ""
      impressao << col
      impressao << ": "
      impressao << entrada[col].to_s
      info.push(impressao)
    end
    # lista ids dos amigos do pessoa
    if nome_tabela == "pessoas"
      amigos = []
      entrada.amigo.each do |amigo|
        amigos.push(amigo.id)
      end
      info.push("amigo_id: #{amigos.join(", ")}")
    end
    # lista ids dos pessoas do amigo
    if nome_tabela == "amigos"
      pessoas = []
      entrada.pessoa.each do |pessoa|
        pessoas.push(pessoa.id)
      end
      info.push("resumo.id: #{pessoas.join(", ")}")
    end
    # imprime utilizando join pra usar o char de separação mais facilmente
    puts "#{info.join(" | ")}"
  end
end

# Adiciona entrada na (classe da) tabela passada com a nova entrada desejada (formato em hash)
def insereTabela(nome_tabela, entrada)
  tabela = obtemTabela(nome_tabela)
  return if tabela == nil

  ids_pessoas = []

  if nome_tabela == "amigos"
    ids_pessoas = entrada["pessoas"]
    entrada.delete("pessoas")
    ids_pessoas = ids_pessoas.split(",")
  end

  insere = tabela.new(entrada)

  ids_pessoas.each do |id_l|
    l = Pessoa.find_by(id: id_l)
    if l == nil
      puts "Pessoa(s) não encontrado(s)"
      return
    end
    insere.pessoa << l 
  end

  if insere.valid?
    insere.save
    puts "ID da nova inserção: #{insere.id}"
  else
    puts "Inserção inválida. Erro(s) gerado(s):"
    puts insere.errors.full_messages
  end
end

# Faz o mesmo de insereTabela, mas como um pessoa precisa ter necessariamente
# uma resumo e amigos, foi feita uma função própria para tal
def inserePessoas(entrada)
  resumo = Resumo.new(texto: entrada["resumo"])
  entrada.delete("resumo")

  pessoa = Pessoa.new(entrada)
  pessoa.resumo = resumo

  if resumo.valid? and pessoa.valid?
    resumo.save
    pessoa.save
    puts "ID da nova inserção: #{pessoa.id}"
  else
    puts "Inserção inválida. Erro(s) gerado(s):"
    puts pessoa.errors.full_messages
    puts resumo.errors.full_messages
  end
end

# Faz o mesmo de insereTabela, mas como não podemos acessar diretamente a tabela
# de associação entre amigos e pessoas, foi feita uma função própria para tal
def insereAmigosPessoas(hash)
  ids_amigos = hash["amigos"].split(",")
  ids_pessoas = hash["pessoas"].split(",")

  ids_pessoas.each do |id_pessoa|
    pessoa = Pessoa.find_by(id: id_pessoa.to_i)
    ids_amigos.each do |id_amigo|
      amigo = Amigo.find_by(id: id_amigo.to_i)
      amigo.pessoa << pessoa if pessoa != nil and amigo != nil
    end
  end
end

# Exclui entradas da tabela que atendam à condição da hash passada em
# valores_chaves
def excluiTabela(tabela, valores_chaves)
  return if tabela == nil

  if valores_chaves == nil
    puts "Não é permitida a exclusão sem condições"
    return
  end
  itens = tabela.where(valores_chaves)

  if resultadoVazio(itens)
    puts "Item(s) para exclusão não encontrado(s)"
  else
    itens.each do |item|
      item.destroy
      puts "Item(s) excluído(s)"
    end
  end
end

# Impre as colunas de dada tabela
def printColunasTabela(tabela)
  colunas = tabela.options.includes(:model_options)
  colunas.each do |col|
    puts col
  end
end

# Imprime as tabelas existentes no banco
def getTabelas()
  tabelas = ActiveRecord::Base.connection.tables

  tabelas.each do |tabela|
    puts tabela
  end
end

def alteraTabela(nome_tabela, dados)
  dados = "" if dados == nil
  campos = dados.split(" para ")
  if campos.length != 2
    puts "Condição de alteração não encontrada"
    return
  end
  entradas = buscaTabela(nome_tabela, campos[0])
  hash = strToHash(campos[1])

  return if entradas == nil or hash == nil

  entradas.each do |e|
    e.update(hash)
  end
end

def trataComando(comando, restante)
  case comando
  when "lista"
    listaTabela(restante[0], restante[1])
  when "exclui", "remove"
    tabela = obtemTabela(restante[0])
    h = strToHash(restante[1])
    excluiTabela(tabela, h)
  when "tabelas"
    getTabelas()
  when "colunas", "campos"
    tabela = obtemTabela(restante[0])
    printColunasTabela(tabela)
  when "limpa", "limpar"
    print `clear`
  when "insere"
    h = strToHash(restante[1])

    case restante[0]
    when "pessoas"
      inserePessoas(h)
    else
      insereTabela(restante[0], h)
    end
  when "associa"
    tabela = obtemTabela(restante[0])
    associaTabelas(tabela, restante[1])
  when "altera"
    alteraTabela(restante[0], restante[1])
  when "sair"
    puts "Saindo..."
    exit 0
  else
    puts "Comando \"#{comando}\" não reconhecido"
  end

end

loop do
  entrada = gets.split(" ", 3)
  comando = entrada[0]
  entrada.delete_at(0)
  trataComando(comando, entrada)
end
