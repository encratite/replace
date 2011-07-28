require 'nil/file'

def processDirectory(path, target, replacement)
  targets = Nil.readDirectory(path, true)
  if targets == nil
    raise "Unable to read path #{path}"
  end
  directories, files = targets
  directories.each do |entry|
    if entry.name == '.git'
      next
    end
    processDirectory(entry.path, target, replacement)
  end

  files.each do |entry|
    path = entry.path
    input = Nil.readFile(path)
    output = input.gsub(target, replacement)
    if input != output
      puts "Replaced a string in #{path}"
      Nil.writeFile(path, output)
    end
  end
end

if ARGV.size != 2
  puts 'Usage:'
  puts "ruby #{File.basename(__FILE__)} <target> <replacement>"
  exit
end

target = Regexp.new(ARGV[0])
replacement = ARGV[1]

processDirectory('.', target, replacement)
