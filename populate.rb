# -*- coding: utf-8 -*-
$:.push "./"
require "resumo/resumo.rb"
require "pessoa/pessoa.rb"
require "casa/casa.rb"
require "amigo/amigo.rb"

pessoas = [
  {
    nome: "Josefina de Santos",
    amigos: ["Bruno dos Santos"],
    casa: "Casa 1",
    ano: 1968,
    resumo: 'Josefina de Santos é uma pessoa muito legal, ela conheceu seu amigo Bruno dos Santos em 1980 e desde então são amigos inseparáveis.',
  },
  {
    nome: "Bruno dos Santos",
    amigos: ["Josefina de Santos"],
    casa: "Casa 2",
    ano: 1968,
    resumo: 'Bruno dos Santos é uma pessoa muito legal, ele conheceu sua amiga Josefina de Santos em 1980 e desde então são amigos inseparáveis.',
  },
  {
    nome: "Maria da Silva",
    amigos: ["João da Silva"],
    casa: "Casa 3",
    ano: 1970,
    resumo: 'Maria da Silva é uma pessoa muito legal, ela conheceu seu amigo João da Silva em 1980 e desde então são amigos inseparáveis.',
  },
  {
    nome: "João da Silva",
    amigos: ["Maria da Silva"],
    casa: "Casa 4",
    ano: 1970,
    resumo: 'João da Silva é uma pessoa muito legal, ele conheceu sua amiga Maria da Silva em 1980 e desde então são amigos inseparáveis.',
  },

]

pessoas.each do |pessoa|
  # pessoa já cadastrado
  next if not Pessoa.find_by(nome: pessoa[:nome]).blank?

  l = Pessoa.new({ :nome => pessoa[:nome], :ano => pessoa[:ano] })

  casa = Casa.find_or_create_by(nome: pessoa[:casa])
  # Adiciona amigos
  pessoa[:amigos].each do |nome_autor|
    amigo = Amigo.find_or_create_by(nome: nome_autor)
    l.amigo << amigo
  end
  
  s = Resumo.new({ :texto => pessoa[:resumo] })
  s.pessoa = l
  l.casa = casa
  l.save
  s.save
end
