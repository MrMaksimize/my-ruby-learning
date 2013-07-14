class Article < ActiveRecord::Base
    include ActiveModel::ForbiddenAttributesProtection
end
