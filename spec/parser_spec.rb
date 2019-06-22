require './lib/parser'

describe "Parser", :parser do
  it "should not run parser when no path supplied" do
    expect { Parser.new }.to output(/Input file path!/).to_stdout
  end

  it "should not start when file does not exist" do
    non_existent_file = 'random_file_name.log'
    expect { Parser.new(non_existent_file) }.to output(/Could not find file: random_file_name.log/).to_stdout
  end

  describe "output" do
    before(:all) do
      mock_stream = StringIO.new
      original_output = $stdout
      $stdout = mock_stream

      Parser.new('./spec/mock.log')
      @result = $stdout.string.split(/\n/)
      $stdout = original_output
    end

    it "should print duration warning" do
      expect(@result).to include("Processing file. It may take a while.")
      expect(@result).to include("Processing finished!")
    end

    it "should print Visists" do
      visits_index = @result.find_index('Visits')
      expect(visits_index).not_to be(nil)
      expect(@result[visits_index + 1]).to match('help 3')
      expect(@result[visits_index + 2]).to match('test 2')
    end

    it "should print Unique visists" do
      unique_visits_index = @result.find_index('Unique visits')
      expect(unique_visits_index).not_to be(nil)
      expect(@result[unique_visits_index + 1]).to match('test 2')
      expect(@result[unique_visits_index + 2]).to match('help 1')
    end
  end
end
