def calculate(num1, op, num2)
    if op == "+"
        return num1 + num2
    elsif op== "-"
        return num1 - num2
    elsif op == "*"
        return num1 * num2
    end
 end
 loop do
 num1 = rand(100)
 num2 = rand(100)
 operators = ["+", "-", "*"]
 op = operators.sample
  puts "What is #{num1} #{op} #{num2} ?"
 correctanswer = calculate(num1, op, num2)
  answer = gets.chomp
  break if answer == "quit"
  if answer.to_i == correctanswer
    puts "Correct!"
  else
    puts "Wrong!"
  end
 end #loop end