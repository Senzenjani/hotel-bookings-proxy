    # app/controllers/proxy_controller.rb
require 'httparty'

class Api::V1::ProxyController < ApplicationController
    def proxy
        # Get the target URL from the request parameters or wherever you need it
    
        target_path = params[:path] || ''

        target_url = "https://restful-booker.herokuapp.com#{target_path}"

        # Make the request to the external API using HTTParty
        response = HTTParty.get(target_url, headers: request.headers)

        # Forward the external API response back to the original requester
        render json: {
            status: response.code,
            headers: response.headers,
            body: response.body
        }
    end
end
