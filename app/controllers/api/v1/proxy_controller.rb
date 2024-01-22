    # app/controllers/proxy_controller.rb
require 'httparty'

class Api::V1::ProxyController < ApplicationController
   
    skip_before_action :verify_authenticity_token, only: [:proxy]

    def proxy
        # Get parameters from the request
        target_path = params[:path] || ''
        target_url = "https://restful-booker.herokuapp.com/#{target_path}"
    
        token = params[:token] || ''
        request_method = params[:method]&.upcase || 'GET' # Default to GET if method is not specified

        request_params = params[:proxy] || {} # Use the "proxy" parameters directly as the request body
    
        # Make the request to the external API using HTTParty
        response = case request_method
                   when 'GET'
                     HTTParty.get(target_url, headers: request_headers(token), query: request_params)
                   when 'POST'
                     HTTParty.post(target_url, headers: request_headers(token), body: request_params.to_json)
                   when 'PUT'
                     HTTParty.put(target_url, headers: request_headers(token), body: request_params.to_json)
                   when 'DELETE'
                     HTTParty.delete(target_url, headers: request_headers(token), body: request_params.to_json)
                   else
                     # Unsupported request method
                     render json: { error: 'Unsupported request method' }, status: :unprocessable_entity
                     return
                   end
    
        # Forward the external API response back to the original requester
       # Forward only the status and JSON body of the external API response back to the original requester
        render json: {
            status: response.code,
            body: JSON.parse(response.body) # Parse the JSON body to ensure it's valid JSON
        }

      end
    
      private
    
      def request_headers(token)
        {
          'Authorization' => "Bearer #{token}",
          'Content-Type' => 'application/json',
          'User-Agent' => request.headers['User-Agent']
          # Add other headers as needed
        }
      end
end
