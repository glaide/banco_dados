require "active_record"

ActiveRecord::Base.establish_connection :adapter => "sqlite3",
                                        :database => "Tabelas.sqlite3"

ActiveRecord::Base.connection.create_table :pessoas do |l|
  l.integer :ano
  l.string :nome
  l.references :casa, foreign_key: true
end
