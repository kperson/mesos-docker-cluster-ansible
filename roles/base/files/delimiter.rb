require 'mustache'
require 'optparse'
require 'fileutils'

def write_file_at(file, content)
  FileUtils.mkdir_p(File.dirname(file))
  File.open(file, 'w') do |file|
    file.write(content)
  end
end

def file_at(path)
  file = File.open(path, "rb")
  contents = file.read
  file.close
  contents
end

options = { }
OptionParser.new do |opts|
 opts.banner = "Usage: demlimiter.rb --i=/tmp/infile --o=/tmp/outfile"
 opts.on('--i input_file', 'Sets the input file') do |input|
   options[:input] = input
 end 
 opts.on('--o output_file', 'Sets output file') do |output|
   options[:output] = output
 end 

 options[:delimiter] = ","
 opts.on('--d delimiter', 'Sets the delimiter') do |delimiter|
   options[:delimiter] = delimiter
 end  
end.parse!

contents = file_at(options[:input]).split(/\n/).select{|x| x.length > 0}
write_file_at(options[:output], contents.join(options[:delimiter]))