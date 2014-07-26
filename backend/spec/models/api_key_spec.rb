
require 'rails_helper'

describe APIKey do
  include ActiveSupport::Testing::TimeHelpers

  describe "associations" do
    it { should belong_to :user }
  end

  describe "validations" do
    it { should validate_presence_of :user }
    it { should validate_uniqueness_of :access_token }
  end

  describe ".active" do
    it "returns access tokens that have not expired" do
      future_date = Time.zone.now + 1.day
      api_key = FactoryGirl.create(:api_key, expires_at: future_date)

      expect(APIKey.active).to include api_key
    end

    it "does not return access tokens that have expired" do
      past_date = Time.zone.now - 1.day
      api_key = FactoryGirl.create(:api_key, expires_at: past_date)

      expect(APIKey.active).to_not include api_key
    end
  end

  describe ".from_request" do
    it "finds access token from request authorization" do
      request = double(authorization: "Bearer ABC")
      expect(APIKey).to receive(:find_by).with(access_token: 'ABC')
      APIKey.from_request(request)
    end

    it "fails gracefully when request has no authorization" do
      request = double(authorization: nil)
      expect { APIKey.from_request(request) }.to_not raise_error
    end
  end

  describe "before_validation callback" do
    it "generates an access token" do
      user = FactoryGirl.build_stubbed(:user)
      api_key = APIKey.create!(user: user)

      expect(api_key.access_token).to_not be_nil
    end

    it "sets an expires_at" do
      travel_to Time.zone.at(0) do
        user = FactoryGirl.build_stubbed(:user)
        api_key = APIKey.create!(user: user)

        expect(api_key.expires_at).to eq 30.days.from_now
      end
    end

    it "uses provided expires_at if given" do
      travel_to Time.zone.at(0) do
        user = FactoryGirl.build_stubbed(:user)
        expires_at = 10.days.from_now
        api_key = APIKey.create!(user: user, expires_at: expires_at)

        expect(api_key.expires_at).to eq expires_at
      end
    end
  end

  describe "#expires_in" do
    it "returns the number of seconds remaining until the token is expired" do
      travel_to Time.zone.at(0) do
        api_key = APIKey.new(created_at: Time.zone.now,
                             expires_at: 5.minutes.from_now)

        expect(api_key.expires_in).to eq 300
      end
    end

    it "returns 0 when token has expired" do
      travel_to Time.zone.at(0) do
        api_key = APIKey.new(created_at: Time.zone.now,
                             expires_at: 5.minutes.ago)

        expect(api_key.expires_in).to eq 0
      end
    end
  end
end
