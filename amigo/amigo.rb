# -*- coding: utf-8 -*-
require "active_record"

ActiveRecord::Base.establish_connection :adapter => "sqlite3",
                                        :database => "Tabelas.sqlite3"

class Amigo < ActiveRecord::Base
  self.table_name = "amigos"
  has_and_belongs_to_many :pessoa

  before_destroy do |amigo|
    amigo.pessoa.each do |l|
      l.amigo.each do |a|
        a.delete if a.id == amigo.id
      end
      l.destroy if l.amigo.count == 0
    end
  end

  validates :nome, presence: true, length: { minimum: 2, maximum: 500 }, uniqueness: true

  before_validation :corrige_tipos

  private

  def corrige_tipos
    nome = nome.to_s
  end

end
