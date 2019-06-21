class Parser
  attr_accessor :pages, :results

  def initialize(file_path)
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

    print_result(@pages)
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

  def print_result(result)
    visits = {}
    unique_visits = {}

    @results = {}
    result.each do |site, ips|

      @results[site] = {
        visits: ips.length,
        unique: ips.uniq.length
      }

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

# Don't run script in test
if $0 == __FILE__
  if ARGV[0]
    parser = Parser.new(ARGV[0])
    parser.parse_file(ARGV[0])
  else
    puts "Input file path!"
  end
end
