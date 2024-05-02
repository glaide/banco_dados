# -*- coding: utf-8 -*-
require "active_record"

ActiveRecord::Base.establish_connection :adapter => "sqlite3",
                                        :database => "Tabelas.sqlite3"

class Pessoa < ActiveRecord::Base
  has_one :resumo, dependent: :destroy
  belongs_to :casa
  has_and_belongs_to_many :amigo, dependent: :destroy_all

  before_destroy do |pessoa|
    pessoa.amigo.each do |a|
      a.pessoa.each do |l|
        l.delete if l == pessoa
      end
      a.destroy if a.pessoa.count == 0
    end
  end

  validates :casa, presence: true
  validates :nome, presence: true, length: { minimum: 2, maximum: 500 }
  validates :ano, presence: true, numericality: { only_integer: true, less_than_or_equal_to: 2024, greater_than_or_equal_to: -1000 }
  validates :resumo, presence: true

  validates_associated :casa

  before_validation :corrige_tipos

  private

  def corrige_tipos
    ano = ano.to_i
    nome = nome.to_s
    casa_id = casa_id.to_i
  end
end
