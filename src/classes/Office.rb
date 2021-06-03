require "colorize"
class Office 
    @@office_list = []
    attr_reader :id 
    attr_accessor :status, :capacity, :temperature, :description

    def initialize(id, status, capacity, temperature, description)
        @id = id
        @status = status
        @capacity = capacity
        @temperature = temperature
        @description = description

        # New office room to office_list  
        @@office_list.push(self)
    end

    # access to office list method  
    def self.get_list 
        return @@office_list
    end   

    # Sorted list of office IDS method  
    def self.get_ids
        id_list = []
        @@office_list.each {|office|
            id_list.push(office.id)
    }
    return id_list.sort 
end

def self.get_temperature(id)
    return self.get_office(id).temperature
end 

# validate user input for id & return id method   
def self.input_valid_id
    id = "default"
    while !self.get_ids.include? id 
        print "Enter a Office ID: "
        id = gets.chomp
        if !self.get_ids.include? id
            puts "!! No Office ID was founded !!".colorize(:salmon)
        end  
    end  
    return id
end 


    # Generate the next office ID, this adds 1 to the last id number 
    def self.generate_next_id
        next_number = self.get_ids.last.delete("OR").to_i + 1 

        # ADD "OR" and to next ID number   
        new_id = "OR" + next_number.to_s
        while new_id.length < 4 
            new_id.insert(1, "0")
        end   
        return new_id
    end  

    # return office user office ID method    
    def self.get_office(id)
        index = @@office_list.find_index {|office| 
            room.id == id}
       return @@office_list [index]
    end

    # Method to edit office with element & value   
    def edit_office(element, value)
        case element
        when "capacity"
            @capacity = value
        when "description"
            @description = value
        when "temperature"
            @temperature = value
        end 
    end   

    # toggle office status when performing logging in/out method 
    def self.log_in_out(id)
        case self.get_office(id).status
        when "Available"
            self.get_office(id).status = "In-use"
            return true
        when "In-use"
            self.get_office(id).status = "Not Available"
            return true 
        when "Not Available"
            puts "This office is not ready for log-in!".colorize(:salmon)
            puts "Note: Make sure office is ready and status is changed before log-in!".colorize(:salmon)
            enter_to_continue
            return false
        end  
    end  

    # Toggle office status when performing change_office_status method   
    def self.change_status(id)
        case self.get_office(id).change_status
        when "Available"
            puts "Office #{id} status will be changed to" + "Not Available".colorize(:green)
            enter_to_continue
            self.get_office(id).status = "Not Available"
        when "In-use"
            puts "The office is currently" + "In-use".colorize(:green) + ". Check out office first."
            enter_to_continue
        when "Not Available"
            puts "Office #{id} status will be changed to" + "Available".colorize(:green)
            enter_to_continue
            self.get_office(id).status = "Available"
        end 
    end  

    # Print out table for offices method then create array to hold data for each office room 
    def self.print_table
        rows = []

        @@office_list.each {|office| 
        rows.push ([
            room.id,
            room.status,
            room.capacity,
            room.temperature,
            room.description,
            ]
        )
     }   

        # Via terminal-table to create a table 
        table = Terminal::Table.new :title => "Office List".colorize(:light_blue), :headings => ["Office ID".colorize(:light_blue), "Status".colorize(:light_blue), "Capacity".colorize(:light_blue), "Temperature (°C)".colorize(:light_blue), "Description".colorize(:light_blue)], :rows => rows
        puts table
    end
    
    # CSV file to save the data method  
    def self.save_to_csv
        CSV.open("./data/office_list.csv", "w") {|csv|
            @@office_list.each {|office|
                csv << [office.id, room.status, room.capacity, room.temperature, room.description]
        }
    }
end 
end