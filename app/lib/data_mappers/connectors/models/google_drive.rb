module DataMappers
  module Connectors
    module Model
      module GoogleDrive
        class Worksheet
          attr_accessor :title, :cells
          def initialize(title, cells)
            @title = title
            @cells = cells
          end
        end

        class Cell
          attr_accessor :row, :column, :value
          def initialize(row, column, value)
            @row = row
            @column = column
            @value = value
          end
        end
      end
    end
  end
end
