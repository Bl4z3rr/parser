class Parser
  attr_accessor :pages

  def initialize(file_path = nil)
    unless file_path
      puts 'Input file path!'
      return
    end

    unless File.exist?(file_path)
      puts 'Could not find file: ' + file_path
      return
    end

    @pages = {}
    process_file(file_path)
  end

  def process_file(file_path)
    puts 'Processing file. It may take a while.'
    File.open(file_path,'r').each { |line| process_line(line) }
    puts 'Processing finished!'

    process_result(@pages)
  end

  def process_line(line)
    # puts line
    if line.gsub(/\s+/, "").length == 0
      return
    end

    adress, ip = line.split(' ')

    unless @pages[adress]
      @pages[adress] = []
    end

    @pages[adress].push(ip)
  end

  def process_result(result)
    visits = {}
    unique_visits = {}

    result.each do |site, ips|
      visits[site] = ips.length
      unique_visits[site] = ips.uniq.length
    end

    print_block('Visits', visits)
    print_block('Unique visits', unique_visits)
  end

  def print_block(title, data)
    puts title
    sorted = data.sort_by { |key, count| -count }
    sorted.each { |key, count| puts "#{key} #{count}" }
  end
end

# Don't run script autamatically in test
if $0 == __FILE__
  Parser.new(ARGV[0])
end
