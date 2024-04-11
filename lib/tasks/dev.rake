unless Rails.env.production?
  namespace :dev do
    desc "Destroy, create, migrate, and adds sample data to database"
    task reset: [
      :environment,
      "db:drop",
      "db:create",
      "db:migrate",
      "dev:sample_data",
    ] do
      puts "done resetting"
    end

    desc "Add sample data"
    task sample_data: [
           :environment,
           "dev:add_users",
           "dev:add_organizations",
           "dev:add_events",
           "dev:add_meeting_minutes",
           "dev:add_members",
           "dev:add_tasks"
         ] do
      puts "done adding sample data"
    end

    # create users
    task add_users: :environment do
      puts "adding users..."
      names = ["alice", "bob", "lisa"]

      names.each do |name|
        u = User.create!(
          first_name: name.capitalize(),
          last_name: Faker::Name.last_name,
          email: "#{name}@example.com",
          username: name,
          password: "password",
        )
        puts "added #{u.first_name}"
      end
    end # end of add_users

    # create organizations
    task add_organizations: :environment do
      puts "adding organizations..."

      10.times do
        o = Organization.create!(
          name: Faker::Company.name,
          user_id: User.all.sample.id,
        )
      end
    end # end of add_organizations

    # create events
    task add_events: :environment do
      puts "adding events..."

      20.times do
        event_start_time = Faker::Time.between_dates(from: Date.today - 1, to: Date.today, period: :day)
        event_end_time = event_start_time + rand(1..8).hours # Adding random hours for the event duration
        e = Event.create!(
          title: "Sample event",
          description: "Sample description",
          event_date: Faker::Date.between(from: "2024-04-08", to: "2024-09-25"),
          start_time: event_start_time,
          end_time: event_end_time,
          address: Faker::Address.full_address,
          hosting: [true, false].sample,
          organization_id: Organization.all.sample.id,
        )
      end
    end # end of add_events

    # create meeting minutes
    task add_meeting_minutes: :environment do
      puts "adding meeting minutes..."

      20.times do
        mm = MeetingMinute.create!(
          meeting_date: Faker::Date.forward(days: 100),
          organization_id: Organization.all.sample.id,
        )
        # Generate some fake content for the meeting minute
        mm.content = Faker::Lorem.paragraphs(number: 3).join("\n\n")
        mm.save
      end
    end # end of add_meeting_minutes

    # create members
    task add_members: :environment do
      puts "adding members..."
      50.times do
        m = Member.create!(
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          birthday: Faker::Date.between(from: "1995-01-01", to: "2010-12-31"),
          phone_number: Faker::PhoneNumber.phone_number,
          role: "Member",
          organization_id: Organization.all.sample.id,
        )
        m.email = "#{m.first_name.downcase}#{m.last_name.downcase}@example.com"
        m.save
      end
    end # end of add_members

    task add_tasks: :environment do
      puts "adding tasks..."

      100.times do
        t = Task.create!(
          text: Faker::Lorem.sentence,
          assigned_to_id: Member.all.sample.id,
          organization_id: Organization.all.sample.id,
          due_date: Faker::Date.forward(days: 30),
          status: Task.statuses.keys.sample, # Assign a random status from the enum keys
        )
      end
    end # end of add_tasks
    puts "done"
  end
end
