require 'csv'
require 'slim'

class Context
    attr_reader :title, :headers, :rows
    def initialize
       @rows = CSV.read(ARGV.shift)
       @headers = @rows.shift
       @title = ARGV.shift
    end
end

ctx = Context.new
layout = Slim::Template.new("views/layout.slim")
puts layout.render(ctx) {
    Slim::Template.new("views/csv.slim").render(ctx)
}
