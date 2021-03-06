require 'csv'

namespace :one_time do
  namespace :fosters do
    desc "geocodes fosters"
    task geocode: :environment do
      User.where(latitude: nil, longitude: nil).where.not(address: nil).find_each do |user|
        Rails.logger.info "Geocoding #{user.name}"
        user.geocode
        user.save!
      end
    end

    desc "marks subscribed_at"
    task subscribe: :environment do
      User.where(subscribed_at: nil).find_each do |user|
        begin
          user.send(:subscribe_to_mailchimp)
          user.save!
        rescue Mailchimp::ListAlreadySubscribedError => e
          user.update_attributes(subscribed_at: DateTime.current)
        rescue Mailchimp::ListInvalidUnsubMemberError => e
          user.update_attributes(subscribed_at: DateTime.current)
          user.update_attributes(unsubscribed_at: DateTime.current)
        rescue => e
          Rollbar.error(e)
          next
        end
      end
    end

    desc "imports fosters into database"
    task import: :environment do
      ApplicationRecord.logger.level = 1

      failed = []

      CSV.foreach("data/roster.csv") do |row|
        begin
          ApplicationRecord.transaction do
            timestamp = row[0] #datetime
            first_name = row[1].capitalize #string
            last_name = row[2].capitalize #string
            email = row[3] #string
            address = row[7] #address model
            size_preferences = row[8] #array to tags
            activity_preferences = row[9] #array to tags
            experience = row[10].split(", ").map(&:capitalize).join(',') #array to tags
            fostered_before = row[11].present? ? true : false #bool
            other_pets = (row[13] == "No other pets") ? false : true #bool
            kids = (row[14] == "No") ? false : true #bool
            schedule = row[15] #array to tags
            fospice = (row[18] == "No / Not Now") ? false : true #bool
            accepted_terms_at = (row[20] == "I understand and accept") ? DateTime.current : nil #datetime

            year = timestamp[/\d{4}/].to_i
            quarter = timestamp[/Q{1}\d/]

            case quarter
            when 'Q1'
              timestamp = Date.new(year, 1, 1)
            when 'Q2'
              timestamp = Date.new(year, 4, 1)
            when 'Q3'
              timestamp = Date.new(year, 7, 1)
            when 'Q4'
              timestamp = Date.new(year, 10, 1)
            end

            size_preferences = size_preferences.gsub(/ \(([^\)]+)\)/, "").split(", ").map(&:capitalize).join(',')

            sanitized_activity_preferences = ""

            ["Young Puppy", "Active", "Moderately active", "Low activity"].each do |opts|
              sanitized_activity_preferences << "#{opts.capitalize}, " if activity_preferences[opts].present?
            end

            name = "#{first_name} #{last_name}"

            user = User.find_or_create_by(email: email) do |u|
              u.created_at = timestamp
              u.name = name
              u.fostered_before = fostered_before
              u.other_pets = other_pets
              u.kids = kids
              u.fospice = fospice
              u.accepted_terms_at = accepted_terms_at
              u.address = address
            end

            user.size_preference_list = size_preferences
            user.activity_preference_list = sanitized_activity_preferences
            user.schedule_list = schedule
            user.experience_list = experience

            user.save!
            Rails.logger.info("Successfully imported #{user.name}")
          end
        rescue => e
          Rails.logger.info("Failed to import: #{row}")
          Rails.logger.info("Error: #{e.message}")
          failed << row
        end
      end

      failed.each do |r|
        Rails.logger.info(r)
      end
    end
  end
end
