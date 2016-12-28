require 'spec_helper'
require 'lib/common/occurance'

describe Common::Occurances do
  before do
    @stubbed = [{ name: 'bob', ratio: 1 },
                { name: 'sam', ratio: 2 },
                { name: 'tim', ratio: 1 }]
  end

  describe 'occurances_to_s' do
    it 'should display as a class method' do
      Common::Occurances.stub_const(:LIST, @stubbed) do
        Common::Occurances.to_s.must_equal 'bob, sam, and tim'
      end
    end
  end

  describe 'list' do
    it 'should be able to view list' do
      Common::Occurances.stub_const(:LIST, @stubbed) do
        Common::Occurances.list[1][:ratio].must_equal 2
      end
    end
  end

  describe 'get_index' do
    it 'should get index off the name' do
      Common::Occurances.stub_const(:LIST, @stubbed) do
        Common::Occurances.get_index('sam').must_equal 1
      end
    end
  end

  describe 'get_ratio' do
    it 'should get ratio off the name' do
      Common::Occurances.stub_const(:LIST, @stubbed) do
        Common::Occurances.get_ratio('sam').must_equal 2
      end
    end
  end
end

describe Common::Occurance do
  describe 'invalid entry' do
    it 'should raise an ArgumentError exception' do
      assert_raises ArgumentError do
        Common::Occurance.new 'future'
      end
    end
  end

  describe 'valid entry' do
    before do
      @subject = Common::Occurance.new 'monthly'
    end

    describe 'initialize' do
      it 'should be succesful' do
        @subject.occurance.must_equal 'monthly'
      end
    end

    describe 'to_s' do
      it 'should display occurance' do
        text = "#{@subject}"
        assert text == 'monthly'
      end
    end

    describe 'to_sym' do
      it 'should display correctly' do
        @subject.to_sym.must_equal :monthly
      end
    end

    describe 'generate_price_conversion' do
      describe 'invalid argument' do
        before do
          @not_obj = 'notaoccuranceobj'
        end
        it 'should raise an ArgumentError exception' do
          assert_raises ArgumentError do
            @subject.generate_price_conversion(@not_obj)
          end
        end
      end

      describe 'valid argument' do
        describe 'buildup_price' do
          before do
            @test_case = Common::Occurance.new 'semiannual'
          end
          it 'should return the correct proc' do
            proc_result = @subject.generate_price_conversion(@test_case)
            result = proc_result.call(13)
            result.must_equal 78
          end
        end
        describe 'breakdown_price' do
          before do
            @test_case = Common::Occurance.new 'weekly'
          end
          it 'should return the correct proc' do
            proc_result = @subject.generate_price_conversion(@test_case)
            result = proc_result.call(40)
            result.must_equal 10
          end
        end
      end

      describe 'same occurance' do
        before do
          @test_case = Common::Occurance.new 'monthly'
        end
        it 'should not change the amount' do
          proc_result = @subject.generate_price_conversion(@test_case)
          result = proc_result.call(100)
          result.must_equal 100
        end
      end
    end
  end
end
