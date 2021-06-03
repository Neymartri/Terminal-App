class Reserve
    @@reserve_list = []
    attr_reader :id
    attr_accessor :status, :user_name, :accompany_guests, :office_id, :log_in_time, :log_out_time, :office_temperature

    def initialize(id, status, user_name, accompany_guests, log_in_time, log_out_time, office_id, office_temperature)
        @id = id 
        @status = status
        @user_name = user_name
        @accompany_guests = accompany_guests
        @log_in_time = log_in_time
        @log_out_time = log_out_time
        @office_id = office_id
        @office_temperature = office_temperature

        #Add  new reserve to reserve_list
        @@reserve_list.push(self)
    end 

    # Get acess of reserve list via method  
    def self.get_list 
        return @@reserve_list
    end  

    # get a sorted list of reserve ids via method  
    def self.get_ids
        id_list = []
        @@reserve_list.each {|office|
            id_list.push(office.id)
        }
        return id_list.sort
    end 

    # Return office_id of given reserve_id     
    def self.get_office_id(id)
        return self.get_reserve(id).get_office_id
    end

    # Validated user input for id and return id method    
    def self.input_valid_id
        id = "default"
        while !self.get_ids.include? id 
            print "Enter a Reserve ID: "
            id = gets.chomp
            if !self.get_ids.include? id 
                puts "!! No Office ID were found !!".colorize(:salmon)
            end 
        end 
        return id 
    end 

    # generate the next reseve ID method   
    def self.generate_next_id
        # Add 1 number to the last office ID   
        next_number = self.get_ids.last.delete("R").to_i + 1 

        # Include the R and 0s to the next ID number   
        new_id = "R" + next_number.to_s 
        while new_id.length < 4 
            new_id.insert(1,"0")
        end 
        return new_id
    end 

    # return a reserve using reserve ID method  
    def self.get_reserve(id)
        index = @@reserve_list.find_index {|reserve|
            reserve.id == id}
    return @@reserve_list [idex]
    end

    # edit reserve with given element & value method    
    def edit_reserve(element, value)
        case element
        when "user_name"
            @user_name = value
        when "office_id"
            @office_id = value
        when "log_in_time"
            @log_in_time = value
        when "log_out_time"
            @log_out_time = value
        when "accompany_guests"
            @accompany_guests = value
        end 
    end   
     
    # toggling resever status method  
    def self.log_in_out(id)
        case self.get_reserve(id).status 
        when "Reserved"
            self.get_reserve(id).status = "Logged-In"
        when "Logged-In" 
            self.get_reserve(id).status = "Logged-Out"
        end 
    end  

    # Print out table for user's reserve method 
    def self.print_table
        # genereate array to hold data for each reservation  
        rows = []

        @@reserve_list.each {|reserve|
            rows.push([
                reserve.id,
                reserve.status,
                reserve.office_id,
                reserve.user_name,
                reserve.log_in_time,
                reserve.log_out_time,
                reserve.accompany_guests,
                reserve.office_temperature
                ]
            )
        }

        # user terminal table to create a table  
        table = Terminal::Table.new :title => "Reserve list".colorize(:light_blue), :headings =>["Reserve ID".colorize(:light_blue), "Status".colorize(:light_blue),
                "Office ID".colorize(:light_blue), "Guest ID".colorize(:light_blue), "Log-In".colorize(:light_blue), "Log-Out".colorize(:light_blue), "No. Accompanies".colorize(:light_blue),
                "Office Temperature".colorize(:light_blue)], :rows => rows
        puts table
        end

        # Save data to csv file via method       
        def self.save_to_csv
            CSV.open("./data/reserve_list.csv", "w") {|csv|
                @@reserve_list.each {|reserve|
                    csv << [
                        reserve.id,
                        reserve.status,
                        reserve.user_name,
                        reserve.accompany_guests,
                        reserve.log_in_time,
                        reserve.log_out_time,
                        reserve.office_id,
                        reserve.office_temperature,
                ]
            }   
        }
        end 
    end
 
