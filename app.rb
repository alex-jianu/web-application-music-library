# file: app.rb
require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/album_repository'
require_relative 'lib/artist_repository'

DatabaseConnection.connect()

class Application < Sinatra::Base

  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/album_repository'
    also_reload 'lib/artist_repository'
  end

  get '/albums/:id' do
    repo1 = AlbumRepository.new
    repo2 = ArtistRepository.new

    @album = repo1.find(params[:id])
        
    @artist = repo2.find(@album.artist_id)

    return erb(:album)
  end

  get '/albums' do
    repo = AlbumRepository.new
    @albums = repo.all

    return erb(:all_albums)
  end

  post '/albums' do
    repo = AlbumRepository.new

    new_album = Album.new

    new_album.title = params[:title]
    new_album.release_year = params[:release_year]
    new_album.artist_id = params[:artist_id]

    repo.create(new_album)
  end

  get '/artists' do
    repo = ArtistRepository.new

    @artists = repo.all

    return erb(:all_artists)
  end

  post '/artists' do
    repo = ArtistRepository.new

    new_artist = Artist.new

    new_artist.name = params[:name]
    new_artist.genre = params[:genre]

    repo.create(new_artist)
  end

  get '/artists/:id' do
    repo = ArtistRepository.new
    
    @artist = repo.find(params[:id])

    return erb(:artist)
  end
end