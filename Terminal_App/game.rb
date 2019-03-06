require 'json'
require 'terminal-table'
require 'io/console'
require 'colorize'
require './class'
require 'ruby-progressbar'
question_class = Questions.new
question_class.select_topic
question_class.leaderboard 
    
    
