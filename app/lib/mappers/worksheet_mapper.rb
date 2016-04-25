require 'models/budget/article'
require 'models/budget/item'
require 'lib/common/worksheet_helpers'

module WorksheetMapper
  include Model
  extend Common::WorksheetHelpers

  # extract required rows
  def self.row_to_hash(worksheet, row)
    {
      title:     worksheet[row, 1],
      category:  worksheet[row, 2],
      occurance: worksheet[row, 3],
      amount:    worksheet[row, 4]
    }
  end

  # map a row in a worksheeet into an item
  def self.map_item(worksheet, row, isIncome = true)
    row_data = row_to_hash worksheet, row
    mapped_item = Model::Budget::Item.new id:          row,
                                          description: row_data[:title],
                                          occurance:   row_data[:occurance].to_sym,
                                          amount:      row_data[:amount],
                                          category:    row_data[:category]
    mapped_item.as_credit! unless isIncome
    mapped_item
  end

  # for mapping all cells in worksheet to a valid expense entries
  def self.map_expenses(worksheet)
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
  def self.map_incomes(worksheet)
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

  # for mapping worksheets to article
  def self.map_article(worksheet)
    year = year_from_title worksheet.title
    Model::Budget::Article.new year, get_items(worksheet)
  end

  def self.get_items(ws)
    expenses = map_expenses ws
    incomes = map_incomes ws
    expenses + incomes
  end
end
