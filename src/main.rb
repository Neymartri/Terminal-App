# set-up
require "csv"
require "terminal-table"
require "tty-prompt"
require "colorize"
require "tty-spinner"
require_relative "./classes/Office.rb"
require_relative "./classes/Reserve.rb"
require_relative "./classes/User.rb"
require_relative "./methods.rb"

application = true 
application_initialize

while application 
    system("clear")
    Reserve.print_table 
# Generate Main Menu
    prompt = TTY::Prompt.new
    options = ["Log-in Office/ Log-out Office", "Change Office Status", "Reserve Management", "User Management", "Office Management"]
    selection = prompt.select(tty_prompt_instruction, options)
    case selection 
# Generate Reserve Management Menu 
    when "Reserve Office / Log-out Office"
        reserve_id = Reserve.input_valid_id 
        if Reserve.get_reserve(reserve_id).status == "Log-out Office"
            puts "User already log-out of the Office".colorize(:salmon)
            enter_to_continue
        else 
            if Office.log_in_out(Reserve.get_office_id(reserve_id))
            Reserve.log_in_out(reserve_id)
            end 
        end 

    when "Change Office Status"
        system("clear")
        Office.print_table 
        Office.change_status(Office.input_valid_id)
    when "Reserve Management"
        management_loop = true 
        while management_loop
            system("clear")
            Reserve.print_table
            reserve_prompt = TTY:: Prompt.new
            options = ["Reserve Office / Log-out Office", "Create New Reserve", "Edit Reserve", "Back To Main Menu"]
            selection = reserve_prompt.select(tty_prompt_instruction, options)

            case selection 
            when "Reserve Office / Log-out Office"
                reserve_id = Reserve.input_valid_id
                if Reserve.get_reserve(reserve_id).status == "Log-out Office"
                    puts "User already log-out of the Office".colorize(:salmon)
                    enter_to_continue
                else 
                    if Office.log_in_out(Reserve.get_office_id(reserve_id))
                    Reserve.log_in_out(reserve_id)
                    end 
                end 
                when "Create New Reserve"
                    system("clear")
                    User.print_table_by_name
                    user_name = User.input_valid_name
                    accompanies = get_valid_input("Number of accompanies guests", "int")
                    log_in = get_valid_input("Log-in Time (HH:MM AM/PM)", "time")
                    log_out = get_valid_input("Log-Out Time (HH:MM AM/PM)", "time")

                    # Exit terminal and print out input values
                    system("clear")
                    puts "Please enter you're name: " + user_name 
                    puts "Number of accompanies guests: " + accompanies
                    puts "Log-in Time: " + log_in
                    puts "Log-out Time: " + log_out
                    Office.print_table 
                    office_id = Office.input_valid_id

                    Reserve.new(
                        Reserve.generate_next_id,
                        "Reserved",
                        user_name,
                        accompanies,
                        log_in,
                        log_out, 
                        office_id,
                        Office.get_temperature(office_id)
                    )
                    puts "New Reserve created!".colorize (:green)
                    enter_to_continue
                when "Edit reserve"
                    reserve = Reserve.get_reserve(Reserve.input_valid_id)
                    reserve_prompt = TTY::Prompt.new
                    option = reserve_prompt.select(tty_prompt_instruction, %w(Office_ID Log_In_Time Log_Out_Time Accompany_Guests)).downcase
                    # User Input New value 
                    print "Enter a new value for #{option}: " 
                    value = gets.chomp 
                    if prompt.yes?("Confirm changes?".colorize(:salmon))
                        reserve.edit_reserve(option, value)
                    end
                when "Back To Main Menu"
                    management_loop = false
                    # generate User Management Menu   
                when "User Management"
            management_loop = true 
                while management_loop 
                    system("clear")
                    User.print_table_by_id
                    user_prompt = TTY::Prompt.new
                    options = ["Create New User", "Edit User", "Back to Main Menu"]
                    selection = user_prompt.select(tty_prompt_instruction, options)
                end
            end
                case selection
                when "Create New User"
                    User.new
                        User.generate_next_id
                        get_valid_input("User Name", "string")
                        get_valid_input("User Email", "email")
                        get_valid_input("User Number", "number")
                    puts "New User Created, Welcome!".colorize(:green)
                    enter_to_continue
                when "Edit User"
                    User= User.get_user_by_id(User.input_valid_id)
                    user_prompt = TTY::Prompt.new
                    option = user_prompt.select(tty_prompt_instruction, %w(Name Email Number)).downcase
                    # Office user input for new value 
                    value = get_valid_input("Enter a new value for #{option}", option)

                    if prompt.yes?("Would you like to confirm change?".colorize(:light_yellow))
                        user.edit_user(option, value)
                    end
                when "user_list"
                    User.get_list
                    gets 
                when "Back To Main Menu"
                    management_loop = false
            # Create Office Management Menu 
                when "Office Management" 
                    management_loop = true 
                    while management_loop
                        system("clear")
                        Office.print_table
                        office_management_prompt =TTY::Prompt.new
                        options = office_management_prompt.select(tty_prompt_instruction,options)
                    end
                end 

                case selection
                when "Change Office Status"
                    Office.change_status(Office.input_valid_id)
                when "Create New Office"
                    Office.new(
                        Office.generate_next_id,
                        "Booking Available",
                        get_valid_input("Office Capacity", "int").to_i, 
                        get_valid_input("Office Temperature", "int").to_i,
                        get_valid_input("Office Description", "string")
                    )
                    puts "New Office Created!".colorize(:green)
                    enter_to_continue
                when "Edit Office Settings"
                    office = Office.get_office(Office.input_valid_id)
                    # Option for user to select 
                    office_prompt = TTY::Prompt.new
                    option = office_prompt.select(tty_prompt_instruction, %w(Capacity, Temperature Descriptiom)).downcase

                    # New Value user input
                    puts "Enter A New Value"
                    value = gets.chomp
                    if prompt.yes?("Confirm changes?".colorize(:salmon))
                        office.edit_office(option, value)
                    end 
                when "Back To Main Menu"
                    management_loop = false
                
                when "Exit"
                    Reserve.save_to_csv
                    User.save_to_csv
                    Office.save_to_csv
                    system ("clear")
                    puts "See you again! Exiting App..."
                    application = false
                end
        end
    end
end