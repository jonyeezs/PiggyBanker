require 'openssl'
OpenSSL::SSL::VERIFY_PEER &&= OpenSSL::SSL::VERIFY_NONE # FIXME: use SSL
require 'google/api_client'
require 'google_drive'

# TODO: figure out how to make constants
# TODO: write spec
module Spreadsheet
  class Adapter
    include Budget

    def initialize(spreadsheet_key = nil)
      @nil_key_msg = 'Nil key provided'
      # config_path = PiggyBanker.root + '/' + PiggyBanker.settings['googledrive_settings']
      config_path = 'C:/Development/PiggyBanker/configurations/googledrive_config.json'
      @session = GoogleDrive.saved_session(config_path)
      load_spreadsheet(spreadsheet_key)
    end

    def load_spreadsheet(spreadsheet_key)
      fail ArgumentError, @nil_key_msg if spreadsheet_key.nil?
      @spreadsheet = @session.spreadsheet_by_key(spreadsheet_key)
    end

    def budgets
      budgets = @spreadsheet.worksheets.select { |ws| !ws.title.downcase.include? 'actual' }
      budgets.map! do |ws|
        Budget::Article.new ws.title, get_items(ws)
      end
    end

    private

    def get_items(ws)
      incomes = get_incomes ws
      expenses = get_expenses ws
      incomes + expenses
    end

    def get_incomes(ws)
      incomes = []
      starting_range(ws).each do |row|
        next if income_header? ws[row, 1]
        next if empty_row? ws, row
        break if expense_header? ws[row, 1]
        income = map_item ws, row, :income
        incomes.push income
      end
      incomes
    end

    def get_expenses(ws)
      expenses = []
      skip = true # skip till we get expenses
      starting_range(ws).each do |row|
        if expense_header? ws[row, 1]
          skip = false
          next
        end
        next if skip || empty_row?(ws, row)
        puts row
        expense = map_item ws, row, :expense
        expenses.push expense
      end
      expenses
    end

    def starting_range(worksheet)
      # first 5 lines are heaaders
      (6..worksheet.num_rows)
    end

    def income_header?(header)
      header.downcase.eql? 'income'
    end

    def expense_header?(header)
      header.downcase.eql? 'expenses'
    end

    def empty_row?(ws, row)
      (1..4).to_a.any? { |col| ws[row, col].empty? }
    end

    def map_item(worksheet, row, type)
      title = worksheet[row, 1]
      category = worksheet[row, 2]
      occurance = worksheet[row, 3]
      if type == :expenses
        multiplier = -1
      else
        multiplier = 1
      end
      amount = worksheet[row, 4] * multiplier
      Budget::Item.new description: title,
                       occurance:   occurance.to_sym,
                       amount:      amount,
                       category:    category
    end
  end
end
