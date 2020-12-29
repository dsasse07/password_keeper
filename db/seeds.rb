Group.destroy_all
Password.destroy_all
Service.destroy_all
User.destroy_all
UserGroup.destroy_all
GroupService.destroy_all

Group.reset_pk_sequence
Password.reset_pk_sequence
Service.reset_pk_sequence
User.reset_pk_sequence
UserGroup.reset_pk_sequence
GroupService.reset_pk_sequence
#####################  Make Users   ####################

john = User.create({
    first_name: "john",
    last_name: "smith",
    role: "admin",
    app_username: "jsmith",
    app_password: "1234"
    })

katie = User.create({
    first_name: "katie",
    last_name: "smith",
    role: "limited",
    app_username: "ksmith",
    app_password: "abcd"
    })

# people = [john, katie]
# people.each {|person| User.create(person)}

################### Make Groups ##################

john_family = Group.create(name: "family")
john_work = Group.create(name: "work")

############# Make UserGroups ##################

ug1 = UserGroup.create(user_id: john.id, group_id: john_family.id)
ug2 = UserGroup.create(user_id: katie.id, group_id: john_family.id)
ug3 = UserGroup.create(user_id: john.id, group_id: john_work.id)

############# Make Services ####################

amazon = Service.create(name: "amazon") 
                        # required_access: "any", 
                        # service_username: "jsmith@gmail.com")
netflix = Service.create(name: "netflix") 
                        # required_access: "any", 
                        # service_username: "jsmith")
chase = Service.create(name: "chase")
                        # required_access: "any", 
                        # service_username: "jsmith001"
hulu = Service.create(name: "hulu")

############# Make GroupServices ################
jf1 = GroupService.create(group_id: john_family.id,
                        service_id: amazon.id,
                        required_access: "any", 
                        service_username: "jsmith@gmail.com")
jf2 = GroupService.create(group_id: john_family.id,
                        service_id: netflix.id,
                        required_access: "any", 
                        service_username: "jsmith")
jf3 = GroupService.create(group_id: john_family.id,
                        service_id: chase.id,
                        required_access: "admin", 
                        service_username: "jsmith137")
jw1 = GroupService.create(group_id: john_work.id,
                        service_id: chase.id,
                        required_access: "admin", 
                        service_username: "jsmith@company.com")

################# Make Passwords ########################

pw1 = Password.create(group_service_id: jf1.id, 
                        password: "abcd",
                        current: true)
pw2 = Password.create(group_service_id: jf2.id, 
                    password: "efgh",
                    current: true)
pw3 = Password.create(group_service_id: jf3.id, 
                    password: "ijkl",
                    current: true)
pw4 = Password.create(group_service_id: jw1.id, 
                    password: "work password",
                    current: true)
pw5 = Password.create(group_service_id: jf1.id, 
                    password: "old password",
                    current: false)



puts "🔥 🔥 🔥 🔥 "