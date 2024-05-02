# -*- coding: utf-8 -*-
require "active_record"

ActiveRecord::Base.establish_connection :adapter => "sqlite3",
                                        :database => "Tabelas.sqlite3"

class Amigo < ActiveRecord::Base
  self.table_name = "autores"
  has_and_belongs_to_many :livro

  before_destroy do |autor|
    # pega cada pessoa do amigo
    autor.livro.each do |l|
      # apaga o amigo do pessoa, exclui a relação
      l.autor.each do |a|
        a.delete if a.id == autor.id
      end
      # se o pessoa não tiver mais autores, apaga o pessoa
      l.destroy if l.autor.count == 0
    end
  end

  # validações
  validates :nome, presence: true, length: { minimum: 2, maximum: 500 }, uniqueness: true

  # antes da validação, corrige os tipos dos dados
  before_validation :corrige_tipos


  private

  def corrige_tipos
    nome = nome.to_s
  end

end
