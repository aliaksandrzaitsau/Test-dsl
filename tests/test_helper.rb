require 'minitest/pride'

def get_solution_file(num)
  home_dir = File.join(File.dirname(__FILE__), "..", "homeworks")
  solution = Dir.entries(home_dir).find { |f| f.match?(/\A\w+_\w+_l#{num}\.rb\z/) }
  puts "loading solution: #{solution}"

  unless solution
    puts "!!! Can not find the solution file, format: 'name_surname_l#{num}.rb !!!"
    puts "!!! Tests for homework_#{num} will be skipped !!!"
    return false
  end

  puts "loading solution: done"

  require_relative File.join(home_dir, solution)
end
