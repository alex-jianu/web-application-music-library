require "spec_helper"
require "rack/test"
require_relative '../../app'

def reset_albums_table
  seed_sql = File.read('spec/seeds/albums_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(seed_sql)
end

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  before(:each) do
    reset_albums_table
  end
  

  context "GET /albums" do
    it "returns all albums on the list" do
      response = get('/albums')

      expect(response.status).to eq(200)
      expect(response.body).to include('<a href="/albums/1">Title: Doolittle Release Year: 1989</a>')
    end
  end

  context "POST /albums" do
    it "creates a new album" do
      response = post('/albums', title: "Voyage", release_year: 2022, artist_id: 2)

      expect(response.status).to eq(200)

      new_list = get('/albums')
      expect(new_list.body).to include('<a href="/albums/13">Title: Voyage Release Year: 2022</a>')
    end
  end

  context "GET /artists" do
    it "gets a list of all artists" do
      response = get('/artists')

      expect(response.status).to eq(200)
      expect(response.body).to include('<a href="/artists/1">ID: 1 Name: Pixies Genre: Rock</a>')
    end
  end

  context "POST /artists" do
    it "creates a new artist" do
      response = post('/artists', name: "Wild nothing", genre: "Indie")

      expect(response.status).to eq(200)

      new_list = get('/artists')
      expect(new_list.body).to include('<a href="/artists/6">ID: 6 Name: Wild nothing Genre: Indie</a>')
    end
  end

  context "GET /albums/:id" do
    it "returns the details of the searched album" do
      response = get('/albums/1')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Doolittle</h1>')
    end
  end

  context "GET /artists/:id" do
    it "returns the details of the searched artist" do
      response = get('/artists/1')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Pixies</h1>')
    end
  end
end
