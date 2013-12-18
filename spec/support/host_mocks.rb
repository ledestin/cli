class Ninefold::Host

  def request(method, path, options={}, &block)
    find_response_for path, options, &block
  end

  def find_response_for(path, options, &block)
    request = (@requests || []).detect do |query|
      query.path == path && query.options.to_s == options.to_s
    end

    raise "Unexpected a request to path: #{path}, params: #{options} " if ! request

    Response.new(request).tap do |response|
      block.call(response) if block_given?
    end
  end

  def respond_to(path, options={})
    Query.new(path, options).tap do |query|
      @requests ||= []
      @requests << query
    end
  end

  class Query
    attr_reader :path, :options, :status, :data

    def initialize(path, options)
      @path    = path
      @options = options
    end

    def with(status, data={})
      @status = status
      @data   = data
    end

    def success?
      @status == :ok
    end

    def body
      @data.to_json
    end
  end
end

RSpec.configure do |config|
  config.before do
    Ninefold::Host.inst.instance_eval do
      @requests = nil
    end
  end
end
