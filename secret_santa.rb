def people_names(filename)
  file = File.open(filename)
  names = Array.new

  file.each_line do |line|
    names.push(line.split[0..1].join(' '))
  end

  return names
end

def create_santas(filename)
  names = people_names(filename)
  file = File.open(filename)
  file.each_line do |line|
    victim = line.split[0..1].join(' ')
    victim_info = line.split[2..-1].join(' ')
    while names[0] == victim do
      names.shuffle! 
    end
    santa = names[0]

    file = File.new("santa/#{santa}.txt", 'w')
    file.puts(victim)
    file.puts(victim_info)
    file.close
    names.delete(santa)
  end
end

Dir.mkdir 'santa' unless File.exist? 'santa'

people_file = 'list.txt'

names_count = people_names(people_file).count

folder_to_count = "santa"
file_count = Dir.glob(File.join(folder_to_count, '**', '*')).select { |file| File.file?(file) }.count

create_santas(people_file)
while file_count != names_count do
  Dir.foreach('santa/') do |f|
    fn = File.join('santa/', f)
    File.delete(fn) if f != '.' && f != '..'
  end
  create_santas(people_file)
  file_count = Dir.glob(File.join(folder_to_count, '**', '*')).select { |file| File.file?(file) }.count
end