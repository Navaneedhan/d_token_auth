Rails.application.routes.draw do
  mount DTokenAuth::Engine => "/d_token_auth"
end
