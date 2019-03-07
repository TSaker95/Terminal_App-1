require 'json'
require 'terminal-table'
require 'io/console'
require 'colorize'
require './class'
require 'timeout'
question_class = Questions.new
#Intro table, welcoming user to the app
leaderboard_hash = "An App by: Aaron and Torryn!".light_red
leaderboard_table = Terminal::Table.new :style => { :border_x => "=".colorize(:light_green).on_black, :border_i => "*".colorize(:black).on_blue, :alignment => :center}, :title => "WELCOME TO: WHO WANTS TO BE A WEALTHY PERSON!".yellow do |t|
   t << [leaderboard_hash]
   t << :separator
   t << ["press any key to continue"]
end
puts leaderboard_table
STDIN.getch.chomp
system("clear")
question_class.select_topic #runs topic selection method
question_class.leaderboard #displays leaderboard when game is finished
    
    
