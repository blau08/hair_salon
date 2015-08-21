require('spec_helper')
require('capybara/rspec')
require('./app')
Capybara.app = Sinatra::Application
set(:show_exceptions, false)

describe('path for viewing all clients', {:type => :feature}) do
  it('the client path to view all clients') do
    visit('/')
    click_on('View all clients')
    expect(page).to have_content('Clients in the Salon:')
  end
end

describe('path for adding a client', {:type => :feature}) do
  it('will add a client to the database') do
    visit('/clients')
    fill_in('client_name', :with => 'Samwell Tarly')
    click_button('Add client')
    expect(page).to have_content('Samwell Tarly')
  end
end
