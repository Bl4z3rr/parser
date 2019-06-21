require './app/parser'

describe "Parser", :parser do
  it "should be initialized with id and file path" do
    File.open('./test_file.log', 'w') { |file| file.write("
      test one
      test two
      help one
      help one
      help one
    ") }

    parser = Parser.new('test_file.log')
    result = parser.pages

    expect(parser.results['test'][:visits]).to eq(2)
    expect(parser.results['test'][:unique]).to eq(2)

    expect(parser.results['help'][:visits]).to eq(3)
    expect(parser.results['help'][:unique]).to eq(1)
    # TODO: check permissions
    # File.delete('./test_file.log')
  end

  it "should not start when file does not exist" do
    non_existent_file = 'random_file_name.log'
    test = allow_any_instance_of(Parser)
      .to receive(:process_file)
      .and_return(nil)

    parser = Parser.new(non_existent_file)

    expect(test).not_to have_received(:process_file)
    # TODO: check permissions
    # File.delete('./test_file.log')
  end
end

#   describe "#file_path" do
#     it "should return the file path" do
#       parser = Parser.new({ file_path: "webserver.log" })
#       expect(parser.file_path).to eq("webserver.log")
#     end
#   end

#   describe "#id" do
#     it "should return the parser id" do
#       parser = Parser.new({ id: 42 })
#       expect(parser.id).to eq(42)
#     end
#   end
# end
