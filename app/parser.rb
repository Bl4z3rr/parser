class Parser
  attr_accessor :pages

  def initialize(file_path)
    if !File.exist?(file_path)
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

    print_result(@pages)
  end

  def process_line(line)
    # puts line
    if line.length == 0
      return
    end

    adress, ip = line.split(' ')

    if (!@pages[adress])
      @pages[adress] = []
    end

    @pages[adress].push(ip)
  end

  def print_result(result)
    visits = {}
    unique_visits = {}

    result.each do |site, ips|
      visits[site] = ips.length
      unique_visits[site] = ips.uniq.length
    end

    puts 'Visits'
    sorted = visits.sort_by { |key, count| -count }
    sorted.each { |key, count| puts "#{key} #{count}" }

    puts 'Unique visits'
    uniue_sorted = unique_visits.sort_by { |key, count| -count }
    uniue_sorted.each { |key, count| puts "#{key} #{count}" }
  end
end

if ARGV[0]
  parser = Parser.new(ARGV[0])
else
  puts "Input file path!"
end
