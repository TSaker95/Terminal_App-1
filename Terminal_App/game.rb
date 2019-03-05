require 'json'
require 'terminal-table'
require 'io/console'
questions = JSON.parse(File.read("questions.txt"))
answers = JSON.parse(File.read("answers.txt"))
correct_answer = JSON.parse(File.read("correct.txt"))
class Questions
    def random_question(q_array, a_array, c_array)
        @selected = rand(4)
        @q_array = q_array
        @a_array = a_array
        @c_array = c_array
        @points = 0
        @table = Terminal::Table.new :title => @q_array[@selected] do |t|
            t << ["A: #{@a_array[@selected][0]}" , "B: #{@a_array[@selected][1]}"]
            t << :separator
            t << ["C: #{@a_array[@selected][2]}" , "D: #{@a_array[@selected][3]}"]
        end
        puts @table
        answer = STDIN.getch.to_s
        if answer == @c_array[@selected]
            # system("clear")
            puts "Correct!", "You have #{@points += 10} points!"
        
        else
            puts "incorrect"
        end
    end
end
question = Questions.new
question.random_question(questions,answers,correct_answer)

# puts "A: #{answers[0][0]}","B: #{answers[0][1]}","C: #{answers[0][2]} ","D: #{answers[0][3]}" 



# class Assist 
#     def initilize
#     end
#     def fifty_fifty
#         2.times 
# search hash if value isnt ans add to new ans hash 

# require 'progressbar'
