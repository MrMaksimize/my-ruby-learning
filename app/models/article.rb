class Article < ActiveRecord::Base
    include ActiveModel::ForbiddenAttributesProtection
    has_many :comments
end
