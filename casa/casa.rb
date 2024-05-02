# -*- coding: utf-8 -*-
require "active_record"

ActiveRecord::Base.establish_connection :adapter => "sqlite3",
                                        :database => "Tabelas.sqlite3"

class Casa < ActiveRecord::Base
  has_many :pessoa, dependent: :delete_all
  validates :nome, presence: true, length: { minimum: 2, maximum: 500 }, uniqueness: true

  before_validation :corrige_tipos

  private

  def corrige_tipos
    nome = nome.to_s
  end
end
