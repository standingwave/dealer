class ProxyController < ApplicationController
  # This controller is used to proxy requests to other servers.
  # It is used to get around the same-origin policy in browsers.
  # It is also used to get around the need for a CORS proxy.

  def index
    Rails.logger.info "PROXY: params=#{params.inspect}"
    proxy_params = { url: "http://gatherer.wizards.com/Handlers/InlineCardSearch.ashx", args: [ "nameFragment" ] }

    q_params = {}

    params.each_pair do |k, v|
      next unless proxy_params[:args].include?(k) or k.match(/^Attribute/)
      Rails.logger.info "PROXY: proxy_params pairs k=#{k} v=#{v}"
      q_params[k] = v
    end
    query = q_params.map { |k, v| "#{CGI.escape(k)}=#{CGI.escape(v)}" }.join("&")
    url = proxy_params[:url] + "?" + query
    Rails.logger.info "PROXY: url=#{url}"

    response = get_url url
    Rails.logger.info "PROXY: response.body=#{response.body}"

    render json: response.body
  end

  private
    def get_url(uri_str, limit = 10)
      logger.info "get_url: url=#{uri_str}"
      require "net/http"
      require "net/https"

      raise ArgumentError, "HTTP redirect too deep" if limit <= 0

      url = URI.parse(uri_str)
      http = Net::HTTP.new(url.host, url.port)
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http.use_ssl = (url.scheme == "https")
      request = Net::HTTP::Get.new(url.path+"?"+url.query)
      response = http.request(request)
      case response
      when Net::HTTPSuccess
        response
      when Net::HTTPRedirection
        logger.info "get_url: redirecting to #{response['location']}"
        get_url(response["location"], limit - 1)
      else
        response.error!
      end
    end
end
