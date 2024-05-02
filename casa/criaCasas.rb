require "active_record"

ActiveRecord::Base.establish_connection :adapter => "sqlite3",
                                        :database => "Tabelas.sqlite3"

ActiveRecord::Base.connection.create_table :casas do |e|
  e.string :nome
end
