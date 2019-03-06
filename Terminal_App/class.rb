class Questions
    attr_accessor :points, :topic, :questions_answered, :chosen_number, :questions, :answers, :correct_answer
    def initialize 
        @topic
        @points = 0
        @questions_answered = [0,0,0,0]
        @topic_complete = "You've already completed this topic, choose another one.".colorize(:cyan)
        # @progressbar = ProgressBar.create(:title => "Time Remaining", :starting_at => 0, :total => 60, :length => 60)
    end
    def select_topic
        until @questions_answered == [5,5,5,5]            
            @question_number = 0
            topics_table = Terminal::Table.new :title => "Select a topic:", :style => { :width => 40, :border_x => "=".colorize(:yellow).on_blue, :border_i => "*".colorize(:yellow).on_blue, :alignment => :center} do |t|
            t << ["History" , "Geography"]
            t << :separator
            t << ["Math" , "Popular"]
            end
            puts topics_table
            puts "Please select a topic or type 'exit' to quit"
            @topic = gets.chomp.downcase
            case @topic
                when "math"
                    math
                when "exit"
                    system("clear")
                    exit true
                when "history", "geography", "popular"
                    random_question_generator
                else
                    system("clear")
                    puts "Invalid selection"
            end
        end
    end
    def random_question_generator
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
                answer_table = Terminal::Table.new :title => "Topic: #{@topic.capitalize.light_blue}   Score: #{@points.to_s.colorize(:green)}\n#{@question}", :style => { :border_x => "=".colorize(:yellow).on_blue, :border_i => "*".colorize(:yellow).on_blue, :alignment => :center}  do |t|
                        t << ["A: #{@answer[0]}".colorize(:light_magenta), "B: #{@answer[1]}".colorize(:light_magenta)]
                        t << :separator
                        t << ["C: #{@answer[2]}".colorize(:light_magenta), "D: #{@answer[3]}".colorize(:light_magenta)]
                end
                until finished == true
                    system("clear")
                    # 60.times { @progressbar.increment; sleep 0.05  }
                    puts answer_table
                    input = STDIN.getch.downcase
                    # if @progressbar.finished? == false 
                        if input.match? /\A[a-d]/
                            # @progressbar.stop
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
                                # @progressbar.reset
                        else
                            system("clear")
                            puts "Invalid answer - Please choose A, B, C, or D".colorize(:red)
                            sleep(1)
                        end
                        if @question_number == 5 
                            finished = true 
                        end
                    # else
                    #     @progressbar.reset
                    #     puts "You ran out of time - press any key to continue to the next question"
                    #     anykey = STDIN.getch.downcase
                    #     finished = true
                    # end
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
                math_table = Terminal::Table.new :title => "Topic: #{@topic.capitalize.light_blue}   Score: #{@points.to_s.colorize(:green)}\nWhat is #{num1} #{syms} #{num2}", :style => {:width => 40, :border_x => "=".colorize(:yellow).on_blue, :border_i => "*".colorize(:yellow).on_blue, :alignment => :center} do |t|
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