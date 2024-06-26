require "active_record"

ActiveRecord::Base.establish_connection :adapter => "sqlite3",
                                        :database => "Tabelas.sqlite3"

ActiveRecord::Base.connection.create_table :amigos_pessoas, id: false do |t|
  t.references :pessoa, :unique => true
  t.references :amigo, :unique => true
end
