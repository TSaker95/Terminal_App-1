require 'json'
require 'terminal-table'
require 'io/console'
leaderboard_array = []
leaderboard_array = JSON.parse(File.read("leaderboard.txt"))
class Files 
    attr_accessor :questions, :answers, :correct_answer
    def set_filename(topic)
        @topic = topic
        @questions = JSON.parse(File.read("#{@topic}_questions.txt"))
        @answers = JSON.parse(File.read("#{@topic}_answers.txt"))
        @correct_answer = JSON.parse(File.read("#{@topic}_correct.txt"))
    end
end
class Questions
    attr_accessor :points, :questions_answered, :question_number, :chosen_number
       def initialize 
        @points = 0
        @questions_answered = [0,0,0,0]
        @chosen_number = []
        @question_number = 0
       end
    def random_question_generator(topic,q_array, a_array, c_array)
        @question_number = 0
        5.times do
            @random_number = rand(5)
            if @chosen_number.include? @random_number
                redo
            else   
                @chosen_number << @random_number
            end
            @topic = topic
            @q_array = q_array[@chosen_number.last]
            @a_array = a_array[@chosen_number.last]
            @c_array = c_array[@chosen_number.last]
            answer_table = Terminal::Table.new :title => "#{@topic.upcase}\n#{@q_array}", :style => { :border_x => "=", :border_i => "x", :alignment => :center}  do |t|
                    t << ["A: #{@a_array[0]}" , "B: #{@a_array[1]}"]
                    t << :separator
                    t << ["C: #{@a_array[2]}" , "D: #{@a_array[3]}"]
            end
            puts @question_number
            puts answer_table
            answer = STDIN.getch.downcase
                if answer.match? /\A[a-d]/ 
                    system("clear")
                    if answer == @c_array.downcase
                        puts "Correct!", "You now have #{@points += 10} points!"
                    else
                        puts "Incorrect"   
                    end
                    case @topic
                        when "history"
                            @questions_answered.delete_at(0)
                            @questions_answered.insert(0, @question_number += 1)  
                        when "geography"
                            @questions_answered.delete_at(1)

                            @questions_answered.insert(1, @question_number += 1)
                            
                        when "popular"
                            @questions_answered.delete_at(3)

                            @questions_answered.insert(3, @question_number += 1)
                    end
                    
                elsif answer == "q"
                    exit true
                else
                    puts "Invalid answer - Please choose A, B, C, or D"
                end
             
        end
    end
    def math_question
        @math_array = []
        @question_number = 0

        5.times do
            @math_array.clear
            num1 = rand(1...100)
            num2 = rand(1...100)
            syms = [:+, :-, :*].sample    
            ans = num1.send(syms, num2)
            @math_array << ans
                3.times do 
                    @math_array << rand(1...1000)
                end
                @math_array.shuffle!
                case @math_array.index(ans)
                    when 0 
                        @math_array.insert(4, "A") 
                    when 1 
                        @math_array.insert(4, "B") 
                    when 2 
                        @math_array.insert(4, "C") 
                    when 3 
                        @math_array.insert(4, "D") 
                end
                    puts @math_array[4]
                
            
            math_table = Terminal::Table.new :title => "Maths:\nWhat is #{num1} #{syms} #{num2}", :style => {:width => 40, :border_x => "=", :border_i => "x", :alignment => :center} do |t|
                t << ["A: #{@math_array[0]}" , "B: #{@math_array[1]}"]
                t << :separator
                t << ["C: #{@math_array[2]}" , "D: #{@math_array[3]}"]
            end
            loop do
                puts math_table
                @math_array[4]
                math_answer = STDIN.getch.downcase
                    if math_answer.match? /\A[a-d]/ 
                        system("clear")
                        if math_answer == @math_array[4].downcase
                            puts "Correct!", "You now have #{@points += 10} points!"
                        else
                            puts "Incorrect", "You still have #{@points} points"
                        end
                        @questions_answered.delete_at(2)
                        @questions_answered.insert(2, @question_number += 1)
                        break
                    elsif math_answer == "q"
                        exit true
                    else
                        system("clear")
                        puts "Invalid answer - Please choose A, B, C, or D"
                    end
            end 
        end 
    end
end
question_class = Questions.new
topics_table = Terminal::Table.new :title => "Select a topic:", :style => {:width => 40, :border_x => "=", :border_i => "x", :alignment => :center} do |t|
    t << ["History" , "Geography"]
    t << :separator
    t << ["Math" , "Popular"]
end
filename = Files.new
finished = false
until finished == true
    puts topics_table
    puts question_class.questions_answered
    topic = gets.chomp.downcase
    # loop do
        case topic
            when "history"
                filename.set_filename(topic)
                if question_class.question_number[2] == 5
                    puts "You've already completed this topic, choose another one."
                else
                    question_class.random_question_generator(topic,filename.questions,filename.answers,filename.correct_answer)
                end
            when "geography"
                filename.set_filename(topic)
                if question_class.question_number[2] == 5
                    puts "You've already completed this topic, choose another one."
                else
                    question_class.random_question_generator(topic,filename.questions,filename.answers,filename.correct_answer)
                end
            when "popular"
                filename.set_filename(topic)
                if question_class.question_number[2] == 5
                    puts "You've already completed this topic, choose another one."
                else
                    question_class.random_question_generator(topic,filename.questions,filename.answers,filename.correct_answer)
                end
            when "math"
                if question_class.question_number[2] == 5
                    puts "You've already completed this topic, choose another one."
                else
                    system("clear")
                        question_class.math_question 
                end
        end
        if question_class.question_number == [5,5,5,5]
            finished = true
        end
    # end
    puts "complete"

    if question_class.questions_answered == 20
        finished = true
        break
    end
end
def leaderboard(leaderboard_array)
    @leaderboard_array = leaderboard_array
    system("clear")
    puts "Your total score is #{question_class.points}!"
    puts "Please enter your name to save your score to the leaderboard"
    leaderboard_name = gets.chomp.upcase
    temp_array = [leaderboard_name, question_class.points]  
    @leaderboard_array << temp_array
    @leaderboard_array.sort_by! {|k, v| [-v, k]}
    if @leaderboard_array.length == 10 
        @leaderboard_array.pop 
    end  
    leaderboard_table = Terminal::Table.new :title => "LEADERBOARD", :headings => ["Player", "Score"], :rows => @leaderboard_array
    puts leaderboard_table
    File.open("leaderboard.txt","w") do |file|
            file.write @leaderboard_array.to_json
    end
end
leaderboard(leaderboard_array)
# require 'progressbar'
