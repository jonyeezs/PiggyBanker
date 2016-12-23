# FIXME: This shouldn't be mapping to an item type. but a generic one
require 'models/article'
require 'models/ledger/item'
require 'lib/data_mappers/connectors/models/postgres'

module DataMappers
  module Mappers
    module Postgres
      def self.map_article(tables)
        tables.keys.map do |year|
          helper = MapToArticleHelper.new
          Model::Article.new year, helper.get_items(tables[year])
        end
      end

      def self.map_table_with_new_rows(table_name, year, items)
        MapToTableHelper.new.get_table table_name, year, items
      end
    end

    class MapToArticleHelper
      def get_items(rows)
        expenses = map_expenses rows
        incomes = map_incomes rows
        expenses + incomes
      end

      def map_expenses(rows)
        expenses = rows.select { |row| row['amount'] < 0 }
        expenses.map { |expense| map_item(expense) }
      end

      def map_incomes(rows)
        incomes = rows.select { |row| row['amount'] > 0 }
        incomes.map { |income| map_item(income) }
      end

      # map a row in a worksheeet into an item
      def map_item(row)
        Model::Ledger::Item.new id:          row['id'],
                                description: row['description'],
                                date:        row['date'],
                                amount:      row['amount'],
                                category:    row['category']
      end
    end

    class MapToTableHelper
      def get_table(table_name, year, items)
        rows = items.map { |item| hash_to_array(item, year) }
        DataMappers::Connectors::Model::Postgres::Table.new table_name, rows
      end

      def hash_to_array(item, year)
        attributes = %w(description category date amount)
        row = attributes.map { |attr| item[attr].to_s }.push(year)
        DataMappers::Connectors::Model::Postgres::Row.new row
      end
    end
  end
end
