require 'spec_helper'
require 'routes/budgets_router'
require 'models/budget/article'
include Rack::Test::Methods

def app
  Budgets
end

describe 'budgets router' do
  before do
    @mockbudgets = mock('Adapter::Spreadsheet')
    Adapter::Budgets.stubs(:new).returns(@mockbudgets)
  end
  describe 'get /' do
    before do
      @mockbudgets.expects(:articles).once.returns('somevalue')
    end
    it 'should return all articles' do
      get '/'
      assert last_response.ok?
      assert last_response.body.include? 'items'
    end
  end
  describe 'get /years' do
    before do
      @mockbudgets.expects(:available_years).once.returns(%w(one two))
    end
    it 'should return all articles' do
      get '/years'
      assert last_response.ok?
      assert last_response.body.include? 'years'
    end
  end
  describe 'get /years/{value}' do
    before do
      @expected_year = '2016'
      @mockbudget = stub_everything('Model::Budget::Article') # so we don't have to stub 'budget.items = ...'
      @mockbudgets.expects(:by_year).with(@expected_year).returns(@mockbudget)
    end
    it 'should return all articles' do
      get "/years/#{@expected_year}"
      assert last_response.ok?
      assert last_response.body.include? 'items'
    end
    it 'should take in query for occurance' do
      @mockbudget.expects(:change_occurances!).once.with 'century'
      get "/years/#{@expected_year}", occurance: 'century'
    end
    it 'should take in query for transaction_type of debit' do
      @mockbudget.expects(:debit_items).once.returns ['newitems']
      get "/years/#{@expected_year}", transaction_type: 'debit'
    end
    it 'should take in query for transaction_type of credit' do
      @mockbudget.expects(:credit_items).once.returns ['newitems']
      get "/years/#{@expected_year}", transaction_type: 'credit'
    end
  end
end
