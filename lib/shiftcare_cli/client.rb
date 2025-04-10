module ShiftCareCLI
  class Client
    attr_reader :id, :full_name, :email

    def initialize(attrs = {})
      @id = attrs['id']
      @full_name = attrs['full_name']
      @email = attrs['email']
    end
  end
end
