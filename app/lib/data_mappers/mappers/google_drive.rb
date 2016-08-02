require 'models/budget/article'
require 'models/budget/item'

module DataMappers
  module Mappers
    module GoogleDrive
      include Model

      # for mapping worksheets to article
      def self.map_article(worksheet)
        helper = MapToArticleHelper.new
        year = helper.year_from_title worksheet.title
        Model::Budget::Article.new year, helper.get_items(worksheet)
      end

      class MapToArticleHelper
        def get_items(ws)
          expenses = map_expenses ws
          incomes = map_incomes ws
          expenses + incomes
        end

        # extract required rows
        def row_to_hash(worksheet, row)
          {
            title:     worksheet[row, 1],
            category:  worksheet[row, 2],
            occurance: worksheet[row, 3],
            amount:    worksheet[row, 4]
          }
        end

        # for mapping all cells in worksheet to a valid expense entries
        def map_expenses(worksheet)
          expenses = []
          skip = true # skip till we get expenses
          starting_range(worksheet).each do |row|
            if expense_header? worksheet[row, 1]
              skip = false
              next
            end
            next if skip || broken_hash_row?(row_to_hash(worksheet, row))
            expense = map_item worksheet, row, false
            expenses.push expense
          end
          expenses
        end

        # for mapping all cells in worksheet to a valid income entries
        def map_incomes(worksheet)
          incomes = []
          starting_range(worksheet).each do |row|
            break if expense_header? worksheet[row, 1]
            next if income_header? worksheet[row, 1]
            next if broken_hash_row? row_to_hash(worksheet, row)
            income = map_item worksheet, row
            incomes.push income
          end
          incomes
        end

        # map a row in a worksheeet into an item
        def map_item(worksheet, row, isIncome = true)
          row_data = row_to_hash worksheet, row
          mapped_item = Model::Budget::Item.new id:          row,
                                                description: row_data[:title],
                                                occurance:   row_data[:occurance].to_sym,
                                                amount:      row_data[:amount],
                                                category:    row_data[:category]
          mapped_item.as_credit! unless isIncome
          mapped_item
        end

        def starting_range(worksheet)
          (6..worksheet.num_rows) # first 5 lines are heaaders
        end

        def income_header?(header)
          header.downcase.eql? 'income'
        end

        def expense_header?(header)
          header.downcase.eql? 'expenses'
        end

        # row in hash with empty cells
        def broken_hash_row?(hash_row)
          hash_row.any? { |_, value| value.to_s.strip.empty? }
        end

        def year_from_title(title)
          title.downcase.delete('budget').delete('actual').strip
        end
      end
    end
  end
end
