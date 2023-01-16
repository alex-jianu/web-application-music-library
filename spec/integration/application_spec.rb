require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  

  context "GET /albums" do
    it "returns all albums on the list" do
      response = get('/albums')

      expect(response.status).to eq(200)
      expect(response.body).to eq "Surfer Rosa, Waterloo, Super Trouper, Bossanova, Lover, Folklore, I Put a Spell on You, Baltimore, Here Comes the Sun, Fodder on My Wings, Ring Ring"
    end
  end

  context "POST /albums" do
    it "creates a new album" do
      response = post('/albums', title: "Voyage", release_year: 2022, artist_id: 2)

      expect(response.status).to eq(200)

      new_list = get('/albums')
      expect(new_list.body).to eq "Surfer Rosa, Waterloo, Super Trouper, Bossanova, Lover, Folklore, I Put a Spell on You, Baltimore, Here Comes the Sun, Fodder on My Wings, Ring Ring, Voyage"
    end
  end

  context "GET /artists" do
    it "gets a list of all artists" do
      response = get('/artists')

      expect(response.status).to eq(200)

      new_list = get('/artists')
      expect(new_list.body).to eq "Pixies, ABBA, Taylor Swift, Nina Simone, Kiasmos"
    end
  end

  context "POST /artists" do
    it "creates a new artist" do
      response = post('/artists', name: "Wild nothing", genre: "Indie")

      expect(response.status).to eq(200)

      new_list = get('/artists')
      expect(new_list.body).to eq "Pixies, ABBA, Taylor Swift, Nina Simone, Kiasmos, Wild nothing"
    end
  end
end
