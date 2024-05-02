# -*- coding: utf-8 -*-
require "active_record"

ActiveRecord::Base.establish_connection :adapter => "sqlite3",
                                        :database => "Tabelas.sqlite3"

class Resumo < ActiveRecord::Base
  belongs_to :pessoa
  # validações
  validates :pessoa, presence: true, uniqueness: true
  validates :texto, presence: true, length: { minimum: 20, maximum: 2000 }

  validates_associated :pessoa

  before_validation :corrige_tipos

  private

  def corrige_tipos
    texto = texto.to_s
    pessoa.id = pessoa_id.to_i
  end
end
