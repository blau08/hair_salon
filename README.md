Salon App 8/21/2015
By Brian Lau

Description

Manage salon by checking in clients and assigning stylists.

Setup

- Clone from GitHub
- Set up databases: hair_salon and hair_salon_test, with tables: clients (client_id serial PRIMARY KEY, client_name varchar) stylists (stylist_id serial PRIMARY KEY, stylist_name varchar) clients_stylists (id serial PRIMARY KEY, client_id int, stylist_id int, check_out_date timestamp, due_date timestamp, returned_date timestamp)
- Run bundle
- Open in Sinatra

Technologies Used

Ruby, Postgres, Sinatra

Legal

Copyright (c) 2015 Brian Lau

This software is licensed under the MIT license.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
