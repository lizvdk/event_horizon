FactoryGirl.define do
  factory :lesson do
    type "article"
    sequence(:title) { |n| "Article #{n}" }
    sequence(:slug) { |n| "article-#{n}" }
    description "Describes the article."
    body "# Article Foo\n\nThis is an article."
    sequence(:position) { |n| n }

    factory :article do
      type "article"
    end

    factory :challenge do
      type "challenge"

      archive do
        Rack::Test::UploadedFile.new(
          Rails.root.join("spec/data/one_file.tar.gz"))
      end
    end
  end

  factory :comment do
    user
    submission
    body "Needs more cow-bell."
  end

  factory :rating do
    user
    lesson

    clarity 2
    helpfulness 4
    comment "Not bad."
  end

  factory :submission do
    association :lesson, factory: :challenge
    user
    self.public false

    archive do
      Rack::Test::UploadedFile.new(Rails.root.join("spec/data/one_file.tar.gz"))
    end

    factory :submission_with_two_file_archive do
      archive do
        Rack::Test::UploadedFile.new(
          Rails.root.join("spec/data/two_files.tar.gz"))
      end
    end

    factory :submission_with_file do
      after(:create) do |submission|
        FactoryGirl.create(:source_file, submission: submission)
      end
    end

    factory :submission_with_nested_files do
      archive do
        Rack::Test::UploadedFile.new(
          Rails.root.join("spec/data/nested_files.tar.gz"))
      end
    end

    factory :submission_with_ignored_files do
      archive do
        Rack::Test::UploadedFile.new(
          Rails.root.join("spec/data/ignored_files.tar.gz"))
      end
    end

    factory :submission_with_large_file do
      archive do
        Rack::Test::UploadedFile.new(
          Rails.root.join("spec/data/large_file.tar.gz"))
      end
    end
  end

  factory :source_file do
    submission
    filename "foo.rb"
    body "2 + 2 == 5\n"
  end

  factory :user do
    provider "github"
    sequence(:uid) { |n| n.to_s }
    sequence(:username) { |n| "george_michael_#{n}" }
    sequence(:email) { |n| "gm#{n}@example.com" }
    sequence(:name) { |n| "George Michael #{n}" }
    role "member"

    factory :admin do
      role "admin"
    end
  end

  factory :team do
    sequence(:name) { |n| "Team #{n}" }
  end

  factory :team_membership do
    user
    team
  end

  factory :assignment do
    team
    lesson
    due_on { DateTime.now + 1.day }
    required true
  end
end
