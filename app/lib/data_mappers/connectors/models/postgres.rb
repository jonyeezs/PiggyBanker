module DataMappers
  module Connectors
    module Model
      module Postgres
        class Table
          attr_accessor :title, :rows
          def initialize(title, rows)
            @title = title
            @rows = rows
          end
        end

        class Row
          # Array of values. array index will be the column's index
          attr_accessor :columns
          def initialize(columns)
            @columns = columns
          end
        end
      end
    end
  end
end
