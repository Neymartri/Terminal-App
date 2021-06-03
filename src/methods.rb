# initialize data and file method 
    def application_initialize
        spinner("Office")
        # load and generate room from csv 
        begin 
            CSV.open("./data/office_list.csv") do |csv|
                csv.each do |office|
                    begin 
                        Office.new(office[0], office[1], office[2], office[3], office[4])
                        rescue
                            print "Invalid data: "
                            print office 
                            puts "\n Resume to next data"
                            sleep(0.7)
                        end 
                    end   
                 end
    rescue Errno::ENOENT
        puts "!! System cannot find the file ".colorize(:salmon) + "./data/office_list.csv"
        puts " An empty".colorize(:salmon) + "./data/office_list.csv" + "will be generated instead.".colorize(:salmon)
        enter_to_continue
    end  

    spinner ("User")
    #Load and generate user via csv file
    begin 
        CSV.open("./data/user_list.csv") do |csv|
            csv.each do |user|
                begin
                    User.new(user[0], user[1], user[2], user[3])
                rescue
                    print "Invalid data: "
                    print user
                    puts "\n Resume to next database"
                    sleep (0.7)
                end
            end
    end
rescue Errno::ENOENT
    puts "!! System cannot find the file ".colorize(:salmon) + "./data/user_list.csv"
    puts "An empty".colorize(:salmon) + "./data/user_list.csv" + "will be generated instead.".colorize(:salmon)
    enter_to_continue
end

    spinner("Reserve")

    # Load and generate reservation from csv 
    begin
        CSV.open("./data/reserve_list.csv") do |csv|
            csv.each do |reserve|
                begin
                    Reserve.new(reserve[0], reserve[1], reserve[2], reserve[3], reserve[4],reserve[5], reserve[6], reserve[7])
                rescue
                    print "Invalid data: "
                    print reserve
                    puts "\n Resume to next data"
                    sleep (0.7)
                end
            end
   end
    rescue Errno::ENOENT
        puts "Warning!! System cannot find the file ".colorize(:salmon) + "./data/reserve_list.csv"
        puts "An empty ".colorize(:salmon) + "./data/reserve_list.csv" + " will be generated instead.".colorize(:salmon)
        enter_to_continue
    end
end


def spinner (subject)
    subject = TTY:: Spinner.new("[:spinner] Loading #{subject} ...")
    10.times do 
        subject.spin
        sleep(0.1)
    end
end

# Verifying user input according to element type 
    def get_valid_input(message, type)
        input = ""
        while input == ""
            print ("#{message}: ")
            input = gets.chomp
            if input == ""
                print "Enter a value: ".colorize(:salmon)
            end
        end
    
    case type
    when "int"
        return input
    when "number"
        return input 
    when "string"
        return input
    when "name"
        return input
    when "time"
        return input
        # return time.striptime (input, "%I: %M %p")
    when "email"
        return input
    end 
end 

# Pause until user press enter key to continue method   
def enter_to_continue
    print "press enter to continue".colorize(:green)
    gets 
end 

# return tty-prompt instruction method   
def tty_prompt_instruction
    return "Select the following options:"
end