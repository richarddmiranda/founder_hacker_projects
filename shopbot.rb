#!/usr/bin/env ruby

# ## Receiving orders via GET request

# url = 'https://@apploving.myshopify.com/admin/api/2024-01/orders.json'
# headers = {'X-Shopify-Access-Token' => 'XXXXX'}
# body = {
#     "order": {
#         "line_items": [{
#             "title": "Bananas",
#             "quantity": 5,
#         }]

#     }
# }
# resp = HTTParty.get(url, headers: headers)
# data = JSON.parse(resp.body)
# data["orders"][0]["line_items"]


# ## Creating orders via POST request

# url = 'https://@apploving.myshopify.com/admin/api/2024-01/orders.json'
# headers = {'X-Shopify-Access-Token' => 'XXXXX'}
# body = {
#     "order": {
#         "line_items": [{
#             "title": "Bananas",
#             "price": 1.00, 
#             "quantity": 5,
#         }]

#     }
# }
# resp = HTTParty.post(url, headers: headers, body:body)
# data = JSON.parse(resp.body)


# ## Get customer info, no checking for errors

require 'httparty'

def get_price(product_list, chosen_product)
  price = 0.0
  product_list.each do | product |
    if product[:name] == chosen_product
      price = product[:price]
    end
  end

  price > 0 ? price : nil

end

PRODUCTS = [ 
  { name: "Bananas",
    price: 1.00, }
]

puts "I'm Shopbot, I'm here to take your order."
puts "Firstly, what's your name?"
customer = gets.chomp
puts "Your email?"
contact_email = gets.chomp
puts "What product do you want to purchase?"
title = gets.chomp
puts "How many do you want to get?"
quantity = gets.chomp.to_i
product_price = get_price(PRODUCTS, title)

order_total = (quantity * product_price).round(2)


puts "Let me just put that through for you"
sleep(2)


url = 'https://@apploving.myshopify.com/admin/api/2024-01/orders.json'
headers = {'X-Shopify-Access-Token' => 'XXXX'}
body = {
    "order": {
        "line_items": [{
            "title": title,
            "price": product_price, 
            "quantity": quantity,
        }]

    }
}

resp = HTTParty.post(url, headers: headers, body:body)
data = JSON.parse(resp.body)
order_number = data["order"]["order_number"]

if resp.success?
  puts "Ok great #{customer}, here's your order details"
  puts "You're ordering #{quantity} of the product: #{title}"
  puts "Amount: £#{order_total}"
  puts "Your order number is #{order_number}"
end

