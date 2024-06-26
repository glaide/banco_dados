require "active_record"

ActiveRecord::Base.establish_connection :adapter => "sqlite3",
                                        :database => "Tabelas.sqlite3"

ActiveRecord::Base.connection.create_table :resumos do |r|
  r.text :texto
  r.references :pessoa, index: { unique: true }, foreign_key: true
end
