module Common
  module WorksheetHelpers
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
