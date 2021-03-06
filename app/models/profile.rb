# frozen_string_literal: true

class Profile < ApplicationRecord
  belongs_to :user, class_name: 'Profile', foreign_key: 'user_id'
end
