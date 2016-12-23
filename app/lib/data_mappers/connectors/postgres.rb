require 'pg'

module DataMappers
  module Connectors
    class PostgresConnector
      attr_reader :table_name

      def initialize(table_name)
        @table_name = table_name
      end

      def tables
        conn = create_conn
        conn.type_map_for_results = PG::BasicTypeMapForResults.new conn
        result = conn.exec "SELECT id, description, category, date::Date, amount::numeric::float8 as amount, year FROM #{@table_name} ORDER BY year, date"
        conn.close
        result.group_by { |item| item['year'] }
      end

      def add_row(table)
        conn = create_conn
        table.rows.each do |row|
          values = row.columns.map { |value| "'#{value}'" }.join(',')
          conn.exec "INSERT INTO #{table.title} VALUES(DEFAULT,#{values})"
        end
        conn.close
      end

      private

      def create_conn
        PGconn.connect host: 'localhost', port: '5432', dbname: 'piggybank', user: 'postgres', password: 'admin'
      end
    end
  end
end
