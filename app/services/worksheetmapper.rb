module WorksheetMapper

  # FIXME: how to change this into a class?
  def self.map_expenses(worksheet)
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

  # FIXME: how to change this into a class?
  def self.map_incomes(worksheet)
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

  # TODO: have the common definitions into an includable module

  def self.starting_range(worksheet)
    # first 5 lines are heaaders
    (6..worksheet.num_rows)
  end

  def self.income_header?(header)
    header.downcase.eql? 'income'
  end

  def self.expense_header?(header)
    header.downcase.eql? 'expenses'
  end

  # row with empty cells
  def self.broken_row?(ws, row)
    [1, 2, 3, 4].any? { |col| ws[row, col].strip.empty? }
  end

  def self.map_item(worksheet, row, multiplier)
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
end
