class Workout < ActiveRecord::Base
	has_many :exercises, dependent: :destroy
end
