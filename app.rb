require('sinatra')
require('sinatra/reloader')
also_reload('lib/**/*.rb')
require('./lib/client')
require('./lib/stylist')
require('pg')
require('pry')

DB = PG.connect({:dbname => 'hair_salon_test', :user => 'postgres', :password => 'secret'})

get('/') do
  erb(:index)
end

get('/clients') do
  @clients = Client.all()
  erb(:clients)
end

get('/stylists') do
  @stylists = Stylist.all()
  erb(:stylists)
end

post('/clients/new') do
  client_name = params.fetch('client_name')
  @client = Client.new({:client_name => client_name})
  @client.save()
  redirect('/clients')
end

post('/stylists/new') do
  stylist_name = params.fetch('stylist_name')
  @stylist = Stylist.new({:stylist_name => stylist_name})
  @stylist.save()
  redirect('/stylists')
end

get('/clients/:id') do
  @client = Client.find(params.fetch('id').to_i())
  @stylists = Stylist.all()
  erb(:client)
end

get('/stylists/:id') do
  @stylist = Stylist.find(params.fetch('id').to_i())
  erb(:stylist)
end

get('/clients/:id/edit') do
  @client = Client.find(params.fetch('id').to_i())
  erb(:client_edit)
end

get('/stylists/:id/edit') do
  @stylist = Stylist.find(params.fetch('id').to_i())
  erb(:stylist_edit)
end

patch('/clients/:id/edit') do
  @client = Client.find(params.fetch('id').to_i())
  if params.fetch('client_name').length > 0
    @client.update({:client_name => params.fetch('client_name')})
  end
  redirect('/clients/' + @client.client_id().to_s())
end

get('/clients/:id/return') do
  @client = Client.find(params.fetch('id').to_i())
  erb(:client_return)
end

patch('/clients/:id/return') do
  stylist_id = params.fetch('stylist_id').to_i()
  client_id = params.fetch('id').to_i()
  @stylist = Stylist.find(stylist_id)
  @stylist.update({:returned_client_ids => [client_id]})
  redirect('/stylists/' + @stylist.stylist_id().to_s())
end

patch('/clients/:id') do
  @client = Client.find(params.fetch('id').to_i())
  @stylist = Stylist.find(params.fetch('stylist_id').to_i())
  @stylist.update({:client_ids => [@client.client_id()]})
  redirect('/clients/' + @client.client_id().to_s())
end

delete('/clients/:id') do
  @client = Client.find(params.fetch('id').to_i())
  @client.delete()
  redirect('/clients')
end

patch('/stylists/:id/edit') do
  stylist = params.fetch('stylist_name')
  @stylist = Stylist.find(params.fetch('id').to_i())
  @stylist.update({:stylist_name => stylist})
  redirect('/stylists/' + @stylist.stylist_id().to_s())
end

patch('/stylists/:id') do
  @stylist = Stylist.find(params.fetch('id').to_i())
  title = params.fetch('title')
  @client = Client.find_by_client_name(client_name)
  @stylist.update({:client_ids => [@client.client_id()]})
  redirect('/stylists/' + @stylist.stylist_id().to_s())
end

delete('/stylists/:id') do
  @stylist = Stylist.find(params.fetch('id').to_i())
  @stylist.delete()
  redirect('/stylists')
end
