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
 opts.on('--k keys', 'Sets the keys') do |keys|
   options[:keys] = keys
 end
 opts.on('--v values as files', 'Sets values (files)') do |values|
   options[:values] = values
 end
 opts.on('--t template file', 'Sets the template file') do |template|
   options[:template] = template
 end
end.parse!

keys = options[:keys].split(",")
values = options[:values].split(",")

bind = { }
kvs = keys.zip(values)

kvs.each do |kv|
  bind[kv[0].to_sym] = file_at(kv[1])
end
template = file_at(options[:template])
puts Mustache.render(template, bind)