module MyMoip
  class Request
    include HTTParty

    attr_reader :id, :data, :response

    def initialize(id)
      @id = id
    end

    def api_call(params, opts = {})
      opts[:logger]   ||= MyMoip.logger
      opts[:username] ||= MyMoip.token
      opts[:password] ||= MyMoip.key

      opts[:logger].info "#{self.class} of ##{@id} with #{params[:body].inspect}"

      url = MyMoip.api_url + params.delete(:path)
      params[:basic_auth] = { username: opts[:username], password: opts[:password] }

      @response = HTTParty.send params.delete(:http_method), url, params

      opts[:logger].info "#{self.class} of ##{@id} to #{url} had response #{@response}"
    end
  end
end

requests = Dir[File.dirname(__FILE__) + "/requests/*.rb"]
requests.each { |f| require f }
