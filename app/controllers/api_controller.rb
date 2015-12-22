class ApiController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken
  protect_from_forgery with: :null_session

  DIRECTION = { up: 0, down: 1 }
end
