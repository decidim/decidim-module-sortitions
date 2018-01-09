# frozen_string_literal: true

require "spec_helper"

describe "Sortition embeds", type: :feature do
  include_context "with a feature"
  let(:manifest_name) { "sortitions" }

  let!(:sortition) { create(:sortition, feature: feature) }

  context "when visiting the embed page for a sortition" do
    before do
      visit resource_locator(sortition).path
      visit "#{current_path}/embed"
    end

    it "renders the page correctly" do
      expect(page).to have_content(sortition.title[:en])
      expect(page).to have_content(organization.name)
    end
  end
end
