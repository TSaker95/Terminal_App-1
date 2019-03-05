require 'json'
# require 'progressbar'
require 'terminal-table'
questions = JSON.parse(File.read("questions.txt"))
correct_answer = 
answers = JSON.parse(File.read("answers.txt"))


# class Assist 
#     def initilize
#     end
#     def fifty_fifty
#         2.times 
# search hash if value isnt ans add to new ans hash 
class Questions
    attr_accessor :selected
    def random_question(q_array, a_array)
        @selected = rand(4)
        @q_array = q_array
        @a_array = a_array
        @table = Terminal::Table.new :title => @q_array[@selected] do |t|
            t << ["A: #{@a_array[@selected][0]}" , "B: #{@a_array[@selected][1]}"]
            t << :separator
            t << ["C: #{@a_array[@selected][2]}" , "D: #{@a_array[@selected][3]}"]
          end
        puts @table
        answer = gets.chomp.downcase
        case answer
        when "a"
        when "b"
        when "c"
        when "d"
    end
    
end
question = Questions.new
question.random_question(questions,answers)

# puts "A: #{answers[0][0]}","B: #{answers[0][1]}","C: #{answers[0][2]} ","D: #{answers[0][3]}" 