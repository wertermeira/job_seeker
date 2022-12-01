# frozen_string_literal: true

namespace :populate do
  desc 'Task populate user'
  task users: :environment do
    FactoryBot.create_list(:user, 20).each do |user|
      puts "#{user.name} was registred"
      puts '---------'
      puts "start register attachements for #{user.name}"
      attachements = rand(1..20)
      FactoryBot.create_list(:attachment, attachements, user: user)
      puts "was registred #{attachements} attachements"
      puts '---------'
      puts 'Finished'
      puts '---------'
    end
  end
end
