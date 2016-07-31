module Displayable

  module InstanceMethods

    def slug
      self.name.downcase.split(" ").join("-")
    end

  end

  ###########################################################################

  module ClassMethods

    def find_by_slug(slug)
      self.all.find {|user| user.slug == slug.downcase}
    end

    



  end

end
