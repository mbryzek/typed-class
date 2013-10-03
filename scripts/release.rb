#!/usr/bin/env ruby

def is_valid_version?(version)
  pieces = version.split(".")
  if pieces.size != 3
    return false
  end
  pieces.each do |value|
    if value.to_i.to_s != value
      return false
    end
  end
  true
end

def update_gemspec!(version)
  found = false
  lines = []
  IO.readlines("typed-class.gemspec").each do |l|
    key, value = l.strip.split("=", 2).map(&:strip)
    puts l
    if key == "s.version"
      lines << l.sub(/#{value}/, "'#{version}'")
      found = true
    else
      lines << l
    end
  end
  if !found
    raise "failed to find version in gemspec"
  end
  File.open('typed-class.gemspec', 'w') { |out| out << lines.join('') }
end

def get_current_version
  IO.readlines("typed-class.gemspec").each do |l|
    key, value = l.strip.split("=", 2).map(&:strip)
    if key == "s.version"
      return value
    end
  end

  raise "No version found"
end

def increment_version(version)
  pieces = version.split(".").map(&:to_i)
  pieces[pieces.size-1] += 1
  pieces.join(".")
end

def ask(message, opts={})
  default = opts.delete(:default)
  if opts.size > 0
    raise "Invalid opts: #{opts.inspect}"
  end

  puts message
  answer = STDIN.gets.to_s.strip
  puts "ans[%s]" % answer
  if answer == ""
    if default.to_s.strip == ""
      puts ""
      return ask(message)
    else
      default
    end
  else
    answer
  end
end

def ask_boolean(message)
  puts "%s? (y/n)" % message
  answer = STDIN.gets
  if answer.to_s.strip.downcase.match(/^y/)
    true
  elsif answer.to_s.strip.downcase.match(/^n/)
    false
  else
    puts ""
    ask_boolean(message)
  end
end

def run(command)
  puts command
  system(command) || raise("Command failed: %s" % command)
end

current_version = get_current_version
default_next_version = increment_version(current_version)
next_version = ''

while !is_valid_version?(next_version)
  next_version = ask("Enter next version (default: %s): " % default_next_version, :default => default_next_version)
end

update_gemspec!(next_version)
run("gem build typed-class.gemspec")
run("git commit -m \"Update version\" typed-class.gemspec")

if ask_boolean("Push gem")
  run("gem push typed-class-%s.gem" % next_version)
end
