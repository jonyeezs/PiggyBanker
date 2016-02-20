module WorksheetMapper
  # TODO: Find out how to break these into nested modules (or classes)
  def starting_range(worksheet)
    (6..worksheet.num_rows) # first 5 lines are heaaders
  end

  def income_header?(header)
    header.downcase.eql? 'income'
  end

  def expense_header?(header)
    header.downcase.eql? 'expenses'
  end

  # row with empty cells
  def broken_row?(ws, row)
    [1, 2, 3, 4].any? { |col| ws[row, col].strip.empty? }
  end

  def map_item(worksheet, row, multiplier)
    title = worksheet[row, 1]
    category = worksheet[row, 2]
    occurance = worksheet[row, 3]
    amount = worksheet[row, 4].to_f * multiplier
    Budget::Item.new id:          row,
                     description: title,
                     occurance:   occurance.to_sym,
                     amount:      amount,
                     category:    category
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
      next if skip || broken_row?(worksheet, row)
      expense = map_item worksheet, row, -1
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
      next if broken_row? worksheet, row
      income = map_item worksheet, row, 1
      incomes.push income
    end
    incomes
  end

  # for mapping worksheets to article
  def map_article(worksheet)
    year = year_from_title worksheet.title
    Budget::Article.new year, get_items(ws)
  end

  def year_from_title(title)
    title.downcase.delete('budget').delete('actual').strip
  end

  def get_items(ws)
    expenses = map_expenses ws
    incomes = map_incomes ws
    expenses + incomes
  end
end
