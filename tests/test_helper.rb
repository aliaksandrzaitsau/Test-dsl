require 'minitest/pride'

def get_solution_file(num)
  home_dir = File.join(File.dirname(__FILE__), "..", "homeworks")
  solution = Dir.entries(home_dir).find { |f| f.match?(/\A\w+_\w+_l#{num}\.rb\z/) }
  puts "loading solution: #{solution}"

  unless solution
    puts "!!! CAN NOT FIND THE SOLUTION FILE, format: 'name_surname_l#{num}.rb !!!"
    exit 0
  end

  solution = File.join(home_dir, solution)
  puts "loading solution: done"

  solution
end
