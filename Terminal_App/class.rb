class Questions
    attr_accessor :points, :topic, :questions_answered, :chosen_number, :questions, :answers, :correct_answer
    def initialize 
        @topic
        @points = 0
        @questions_answered = [0,0,0,0]
        @topic_complete = "You've already completed this topic, choose another one.".colorize(:cyan)
    end
    def select_topic #method controlling the topic selection screen
        until @questions_answered == [5,5,5,5]            
            @question_number = 0            
            topics_table = Terminal::Table.new :title => "Select a topic:", :style => { :width => 40, :border_x => "=".colorize(:yellow).on_blue, :border_i => "*".colorize(:yellow).on_blue, :alignment => :center} do |t|
            t << ["History".colorize(:light_red) , "Geography".colorize(:light_green)]
            t << :separator
            t << ["Math".colorize(:light_blue) , "Popular".colorize(:yellow)]
            end #table contains topics to choose from
            puts topics_table 
            puts "Please select a topic or type 'exit' to quit"
            @topic = gets.chomp.downcase
            @topic_colour =""
            case @topic #case to run method and change colour of variable depending on topic selected
                when "math"
                    @topic_colour = @topic.capitalize.colorize(:light_blue)
                    math   
                when "history"
                    @topic_colour = @topic.capitalize.colorize(:light_red)
                    random_question_generator
                when "geography"
                    @topic_colour = @topic.capitalize.colorize(:light_green)
                    random_question_generator
                when "popular"
                    @topic_colour = @topic.capitalize.colorize(:yellow)
                    random_question_generator
                when "exit"
                    system("clear")
                    exit true
                else
                    system("clear")
                    puts "Invalid selection"
            end            
        end
    end
    def random_question_generator #method controls the non-math topics
        system("clear")
        @chosen_number= []
        case
        when @topic == "history" && @questions_answered[0] == 5
            puts @topic_complete
            sleep(1)
        when @topic == "geography" && @questions_answered[1] == 5
            puts @topic_complete
            sleep(1)

        when @topic == "popular" && @questions_answered[3] == 5
            puts @topic_complete
            sleep(1)
        else
            #this section controls random selection of questions and matching answer from file
            @questions = JSON.parse(File.read("#{@topic}_questions.txt"))
            @answers = JSON.parse(File.read("#{@topic}_answers.txt"))
            @correct_answer = JSON.parse(File.read("#{@topic}_correct.txt"))
            until @question_number == 5 
                finished = false
                @random_number = rand(5)
                if @chosen_number.include? @random_number
                    redo
                else   
                    @chosen_number << @random_number
                end
                @question = @questions[@chosen_number.last]
                @answer = @answers[@chosen_number.last]
                @correct = @correct_answer[@chosen_number.last]                
                answer_table = Terminal::Table.new :title => "Topic: #{@topic_colour}   Score: #{@points.to_s.colorize(:light_green)}\n#{@question}", :style => { :border_x => "=".colorize(:yellow).on_blue, :border_i => "*".colorize(:yellow).on_blue, :alignment => :center}  do |t|
                        t << ["A: #{@answer[0]}", "B: #{@answer[1]}"]
                        t << :separator
                        t << ["C: #{@answer[2]}", "D: #{@answer[3]}"]
                end
                until finished == true
                    system("clear")
                    puts answer_table
                    input = STDIN.getch.downcase
                        if input.match? /\A[a-d]/
                            system("clear")
                            if input == @correct.downcase
                                puts "#{input.chomp.upcase} is correct! You now have #{@points += 10} points!".colorize(:green) 
                            else
                                puts "#{input.chomp.upcase} is incorrect. The correct answer is #{@correct.chomp.upcase}".colorize(:yellow)   
                            end
                            sleep(1)
                            @question_number += 1
                            case @topic
                                when "history"
                                    @questions_answered.delete_at(0)
                                    @questions_answered.insert(0, @question_number)  
                                when "geography"
                                    @questions_answered.delete_at(1)
                                    @questions_answered.insert(1, @question_number)
                                when "popular"
                                    @questions_answered.delete_at(3)
                                    @questions_answered.insert(3, @question_number)
                            end
                                finished = true
                        else
                            system("clear")
                            puts "Invalid answer - Please choose A, B, C, or D".colorize(:red)
                            sleep(1)
                        end
                        if @question_number == 5 
                            finished = true 
                        end
                end
            end
        end
    end
    def math
        system("clear")
        if @questions_answered[2] == 5
        puts @topic_complete
        sleep(1)
        else
            math_array = []
            5.times do
                finished = false
                math_array.clear
                num1 = rand(1...100)
                num2 = rand(1...100)
                syms = [:+, :-, :*].sample    
                ans = num1.send(syms, num2)
                math_array << ans
                    3.times do 
                        math_array << rand(1...1000)
                    end
                    math_array.shuffle!
                    case math_array.index(ans)
                        when 0 
                            math_array.insert(4, "A") 
                        when 1 
                            math_array.insert(4, "B") 
                        when 2 
                            math_array.insert(4, "C") 
                        when 3 
                            math_array.insert(4, "D") 
                    end                    
                math_table = Terminal::Table.new :title => "Topic: #{@topic_colour}   Score: #{@points.to_s.colorize(:light_green)}\nWhat is #{num1} #{syms} #{num2}", :style => {:width => 40, :border_x => "=".colorize(:yellow).on_blue, :border_i => "*".colorize(:yellow).on_blue, :alignment => :center} do |t|
                    t << ["A: #{math_array[0]}" , "B: #{math_array[1]}"]
                    t << :separator
                    t << ["C: #{math_array[2]}" , "D: #{math_array[3]}"]
                end
                loop do                    
                    system("clear")
                    puts math_table
                    math_array[4]
                    math_answer = STDIN.getch.downcase
                    if math_answer.match? /\A[a-d]/ 
                        system("clear")
                        if math_answer == math_array[4].downcase
                            puts "#{math_answer.capitalize} is correct! You now have #{@points += 10} points!".colorize(:green) 
                        else
                            puts "#{math_answer.capitalize} is incorrect. The correct answer is #{math_array[4]}".colorize(:yellow)   
                        end
                        sleep(1)
                        @question_number += 1
                        @questions_answered.delete_at(2)
                        @questions_answered.insert(2, @question_number)
                        break
                    else
                        system("clear")
                        puts "Invalid answer - Please choose A, B, C, or D".colorize(:red)
                        sleep(1)
                    end
                end
            end 
        end 
    end
    def leaderboard
        @leaderboard_array = JSON.parse(File.read("leaderboard.txt"))
        system("clear")
        puts "Your total score is #{@points}!"
        puts "Please enter your name to save your score to the leaderboard"
        leaderboard_name = gets.chomp.upcase
        temp_array = [leaderboard_name, @points]  
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
end