require "rails_helper"

feature "announcements" do
  let(:team) { FactoryGirl.create(:team) }

  context "as a team member" do
    let(:team_member) { FactoryGirl.create(:team_membership, team: team) }

    before :each do
      sign_in_as(team_member.user)
    end

    scenario "view latest announcements on dashboard" do
      old_announcements = FactoryGirl.create_list(:announcement, 2, team: team, created_at: 1.day.ago)
      recent_announcements = FactoryGirl.create_list(:announcement, 5, team: team)

      visit dashboard_path

      recent_announcements.each do |announcement|
        expect(page).to have_content(announcement.title)
      end

      old_announcements.each do |announcement|
        expect(page).to_not have_content(announcement.title)
      end
    end

    scenario "view announcements on team page" do
      announcements = FactoryGirl.create_list(:announcement, 5, team: team)

      visit team_path(team)

      announcements.each do |announcement|
        expect(page).to have_content(announcement.title)
      end
    end
  end

  context "as an admin" do
    let(:admin) { FactoryGirl.create(:admin) }

    before :each do
      sign_in_as(admin)
    end

    scenario "create a new announcement" do
      visit team_announcements_path(team)

      fill_in "Title", with: "Free donuts on the counter."
      fill_in "Description", with: "Except they're stale."
      click_button "Add Announcement"

      expect(page).to have_content("Free donuts on the counter.")
      expect(page).to have_content("Except they're stale.")
      expect(page).to have_content("Added announcement.")
    end

    scenario "fail to create a new announcement" do
      visit team_announcements_path(team)

      click_button "Add Announcement"

      expect(page).to have_content("Failed to add announcement.")
      expect(Announcement.count).to eq(0)

    end

    scenario "remove an existing announcement" do
      announcement = FactoryGirl.create(:announcement, team: team)

      visit announcement_path(announcement)

      click_link "delete announcement"

      expect(page).to have_content "You have deleted an announcement."
      expect(Announcement.count).to eq(0)
    end
  end
end
