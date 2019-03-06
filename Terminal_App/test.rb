require 'terminal-table'

leaderboard_hash = {"AARON"=>20, "DANIEL"=>10, "LARRY"=>40, "KIRK"=>20}
leaderboard_table = Terminal::Table.new :title => "LEADERBOARD" do |t|
    t << rows << [leaderboard_hash[0][0], leaderboard_hash[1][1]]
    t << rows << ['Two', 2]
    rows << ['Three', 3]
        t << :separator
end

puts leaderboard_table