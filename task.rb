require 'httparty'
require 'sinatra'
require 'json'
require 'make_todo'
require 'sinatra/reloader'

# class Page
#   include HTTParty
#
#   base_uri "http://makeitreal-todo.herokuapp.com"
# end

class Task < Sinatra::Base
  use Rack::MethodOverride

  get '/' do
    # hola = Page.get("/task.json").parsed_response
    @all_task = []
    erb :index
  end


  post '/task' do
    tarea = params[:content]
    if tarea.empty?
      @invalid = true
      @all_task = []
      erb :index
    else
      @invalid = false
      Tarea.create(tarea)
      redirect '/'
    end

    # result = Page.post("/task.json",
    #         :body => {:task => tarea,
    #                   :complete => false
    #                 }.to_json,
    #         :headers => { 'Content-Type' => 'application/json' } )
    # pp result.code
  end

  get '/complete' do
    @all_task = Tarea.all.select {|element| element['done']==true}
    @complete_page = true
    erb :index
  end

  get '/incomplete' do
    @all_task = Tarea.all.select {|element| element['done']==false}
    @incomplete_page = true
    erb :index
  end

  put '/:id' do
    Tarea.update(params[:id])
    redirect '/'
  end

  delete '/:id' do
    Tarea.destroy(params[:id])
    redirect '/'
  end
end

Task.run!
