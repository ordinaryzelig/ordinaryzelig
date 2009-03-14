require "digest/sha1"

module Digest
  
  def hash(str)
    Digest::SHA1.hexdigest(str)
  end
  
end
