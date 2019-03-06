require 'json'
require 'terminal-table'
require 'io/console'
$points = 0
$score = 0
$selected = []
$clear = system("clear")
leaderboard_array = []
leaderboard_array = JSON.parse(File.read("leaderboard.txt"))
puts leaderboard_array
class Questions
    def random_question(topic,q_array, a_array, c_array)
        loop do
            @random = rand(4)
            if $selected.include? @random
                break
            else   
                $selected << @random
            end
            @topic = topic
            @q_array = q_array[$selected.last]
            @a_array = a_array[$selected.last]
            @c_array = c_array[$selected.last]
            answer_table = Terminal::Table.new :title => "#{@topic}: #{@q_array}" do |t|
                t << ["A: #{@a_array[0]}" , "B: #{@a_array[1]}"]
                t << :separator
                t << ["C: #{@a_array[2]}" , "D: #{@a_array[3]}"]
            end
            loop do
                puts answer_table
                answer = STDIN.getch.downcase
                    if answer.match? /\A[a-d]/ 
                        if answer == @c_array
                            system("clear")
                            puts "Correct!", "You now have #{$points += 10} points!"
                            $score += 1
                            break
                        else
                            system("clear")
                            puts "Incorrect", "You still have #{$points} points"
                            $score += 1
                            break
                        end
                    break
                    elsif answer == "q"
                        exit true
                    else
                        system("clear")
                        puts "Invalid answer - Please choose A, B, C, or D"
                    end
            end 
        end
    end
end
question = Questions.new
topics_table = Terminal::Table.new :title => "Select a topic:" do |t|
    t << ["History" , "Geography"]
    t << :separator
    t << ["Math" , "Space"]
end
loop do
    puts topics_table
    topic = gets.chomp.downcase
    finished = false
    case topic
        when "history"
            question_file = "questions.txt"
            answer_file = "answers.txt"
            correct_file = "correct.txt"
        when "math"
            question_file = "math_questions.txt"
            answer_file = "math_answers.txt"
            correct_file = "math_correct.txt"
    end
    questions = JSON.parse(File.read(question_file))
    answers = JSON.parse(File.read(answer_file))
    correct_answer = JSON.parse(File.read(correct_file))

    loop do
        system("clear")
        question.random_question(topic,questions,answers,correct_answer)
        if $selected.length == 4
            $selected.clear
            break
        end
    end
    if $score == 4
        break
    end
end
def leaderboard(leaderboard_array)
    @leaderboard_array = leaderboard_array
    system("clear")
    puts "Your total points is #{$points}!"
    puts "Please enter your name to save your score to the leaderboard"
    leaderboard_name = gets.chomp.upcase
    temp_array = [leaderboard_name, $points]  
    @leaderboard_array << temp_array
    @leaderboard_array.sort_by! {|k, v| [-v, k]}
    if @leaderboard_array.length == 10 
        @leaderboard_array.pop 
    end  
    leaderboard_table = Terminal::Table.new :title => "LEADERBOARD", :headings => ["Player", "Points"], :rows => @leaderboard_array
    puts leaderboard_table
    File.open("leaderboard.txt","w") do |file|
            file.write @leaderboard_array.to_json
    end
end
leaderboard(leaderboard_array)
# require 'progressbar'
