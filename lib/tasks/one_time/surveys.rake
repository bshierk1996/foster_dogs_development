namespace :one_time do
  namespace :surveys do
    desc 'creates foster dogs survey'
    task foster_dogs: :environment do
      ActiveRecord::Base.transaction do
        organization = Organization.find_or_create_by(name: 'Foster Dogs')
        survey = organization.survey
        survey ||= organization.create_survey unless survey.present?

        survey.questions.find_or_create_by!(slug: 'fostered_before') do |q|
          q.question_text = 'Have you fostered before?'
          q.question_type = Question::BOOLEAN
          q.queryable = true
          q.required = true
          q.index = 0
        end

        survey.questions.find_or_create_by!(slug: 'fostered_for') do |q|
          q.question_text = 'If so, which organizations have you previously fostered with?'
          q.question_type = Question::MULTI_SELECT
          q.queryable = true
          q.question_choices = Organization.where.not(slug: 'foster_dogs').pluck(:name)
          q.index = 1
        end

        survey.questions.find_or_create_by!(slug: 'fospice') do |q|
          q.question_text = 'Are you interested in participating in our Fospice program?'
          q.question_type = Question::BOOLEAN
          q.question_subtext = 'If you are interested in being a "Forever Foster" caretaker for our "Fospice" program for dogs in their end-of-life months, check the box below. Learn more about the program <span><a target="_blank" href="http://fosterdogsnyc.com/fospice/">here</a></span>'
          q.queryable = true
          q.required = true
          q.index = 2
        end

        survey.questions.find_or_create_by!(slug: 'owns_cats') do |q|
          q.question_text = 'How many cats are in your household?'
          q.question_type = Question::COUNT
          q.queryable = true
          q.required = true
          q.index = 3
        end

        survey.questions.find_or_create_by!(slug: 'owns_dogs') do |q|
          q.question_text = 'How many dogs are in your household?'
          q.question_type = Question::COUNT
          q.queryable = true
          q.required = true
          q.index = 4
        end

        survey.questions.find_or_create_by!(slug: 'other_pets') do |q|
          q.question_text = 'Do you own any other pets?'
          q.question_type = Question::BOOLEAN
          q.queryable = true
          q.required = true
          q.index = 5
        end

        survey.questions.find_or_create_by!(slug: 'kids') do |q|
          q.question_text = 'Are you in a household with young children?'
          q.question_type = Question::BOOLEAN
          q.queryable = true
          q.required = true
          q.index = 6
        end

        survey.questions.find_or_create_by!(slug: 'size') do |q|
          q.question_text = 'What size of dog are you open to fostering?'
          q.question_type = Question::MULTI_SELECT
          q.question_choices = User::SIZE_PREFERENCES.map { |k, v| "#{k} (#{v})" }
          q.queryable = true
          q.required = true
          q.index = 7
        end

        survey.questions.find_or_create_by!(slug: 'experience') do |q|
          q.question_text = 'What experience do you have with dogs?'
          q.question_type = Question::MULTI_SELECT
          q.question_choices = User::EXPERIENCE
          q.queryable = true
          q.required = true
          q.index = 8
        end

        survey.questions.find_or_create_by!(slug: 'schedule') do |q|
          q.question_text = 'How often are you out of the house'
          q.question_subtext = 'On average, how long would the dog be alone during the workweek? Note: If you are away for more than 8 hours a day you should consider hiring a dog walker or have someone check in on the dog. Some rescue organizations offer discounted dog walks.'
          q.question_type = Question::MULTI_SELECT
          q.question_choices = User::SCHEDULE
          q.queryable = true
          q.required = true
          q.index = 9
        end

        survey.questions.find_or_create_by!(slug: 'activity') do |q|
          q.question_text = 'How active do you prefer your foster to be?'
          q.question_type = Question::MULTI_SELECT
          q.question_choices = User::ACTIVITY_PREFERENCES
          q.queryable = true
          q.required = true
          q.index = 10
        end

        survey.questions.find_or_create_by!(slug: 'fosters_big_dogs') do |q|
          q.question_text = 'Are you interested in fostering big dogs?'
          q.question_type = Question::BOOLEAN
          q.queryable = true
          q.required = false
          q.index = 11
        end

        survey.questions.find_or_create_by!(slug: 'fosters_cats') do |q|
          q.question_text = 'Are you interested in fostering cats?'
          q.question_type = Question::BOOLEAN
          q.queryable = true
          q.required = false
          q.index = 12
        end
      end
    end

    desc 'creates macc survey'
    task macc: :environment do
      ActiveRecord::Base.transaction do
        organization = Organization.find_or_create_by(name: 'Metro Animal Care & Control') do |o|
          o.slug = 'macc'
        end
        survey = organization.survey
        survey ||= organization.create_survey unless survey.present?

        survey.questions.find_or_create_by!(slug: 'kids') do |q|
          q.question_text = 'Do you have young children in your home?'
          q.question_type = Question::BOOLEAN
          q.queryable = true
          q.required = true
          q.index = 0
        end

        survey.questions.find_or_create_by!(slug: 'applied_previously') do |q|
          q.question_text = 'Have you applied to foster with MACC before?'
          q.question_type = Question::BOOLEAN
          q.queryable = true
          q.required = true
          q.index = 1
        end

        survey.questions.find_or_create_by!(slug: 'activity') do |q|
          q.question_text = 'What activity level might be a good fit your household?'
          q.question_type = Question::MULTI_SELECT
          q.question_choices = ['Low activity (Couch Potato)', 'Moderate activity (Let’s Play)', 'Active (Running Buddy)']
          q.queryable = true
          q.required = true
          q.index = 2
        end

        survey.questions.find_or_create_by!(slug: 'fosters_cats') do |q|
          q.question_text = 'Are you interested in fostering cats?'
          q.question_type = Question::BOOLEAN
          q.queryable = true
          q.required = false
          q.index = 3
        end

        survey.questions.find_or_create_by!(slug: 'owns_cats') do |q|
          q.question_text = 'How many cats are in your household?'
          q.question_type = Question::COUNT
          q.queryable = true
          q.required = true
          q.index = 4
        end

        survey.questions.find_or_create_by!(slug: 'owns_dogs') do |q|
          q.question_text = 'How many dogs are in your household?'
          q.question_type = Question::COUNT
          q.queryable = true
          q.required = true
          q.index = 5
        end

        survey.questions.find_or_create_by!(slug: 'other_pets') do |q|
          q.question_text = 'How many other pets are in you household?'
          q.question_type = Question::COUNT
          q.queryable = true
          q.required = true
          q.index = 6
        end

        survey.questions.find_or_create_by!(slug: 'spayed_neutered_vaccinated') do |q|
          q.question_text = 'Are all pets in your home spayed/neutered/vaccinated?'
          q.question_type = Question::BOOLEAN
          q.queryable = true
          q.required = true
          q.index = 7
        end

        survey.questions.find_or_create_by!(slug: 'spayed_neutered_vaccinated_explanation') do |q|
          q.question_text = 'If your animals are not spayed/neutered/vaccinated, please elaborate below:'
          q.question_type = Question::LONG_TEXT
          q.queryable = false
          q.required = false
          q.index = 8
        end

        survey.questions.find_or_create_by!(slug: 'special_experience') do |q|
          q.question_text = 'If you have any special experience or additional information to share, please elaborate below:'
          q.question_type = Question::LONG_TEXT
          q.queryable = false
          q.required = false
          q.index = 9
        end

        survey.questions.find_or_create_by!(slug: 'referral') do |q|
          q.question_text = 'How did you hear about us?'
          q.question_type = Question::SHORT_TEXT
          q.queryable = false
          q.required = false
          q.index = 10
        end
      end
    end

    desc 'ports foster dogs taggable items over to survey'
    task cutover: :environment do
      foster_dogs = Organization.foster_dogs
      survey = foster_dogs.survey

      User.find_each do |user|
        next if user.survey_responses.foster_roster.present?

        ActiveRecord::Base.transaction do
          sr = SurveyResponse.new
          sr.user = user
          sr.organization = foster_dogs
          sr.survey = survey

          response_hash = {}

          survey.questions.each do |question|
            next if [:owns_cats, :owns_dogs].include?(question.slug.to_sym)
            response_hash[question.slug] = user.question_to_preferences(question)
          end

          sr.response = response_hash
          sr.save!
        end
      end
    end
  end
end
