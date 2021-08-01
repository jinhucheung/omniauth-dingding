require 'omniauth-dingding/client/base'

module OmniAuth
  module Dingding
    module Client
      class ThirdPartyPersonal < ::OmniAuth::Dingding::Client::Base
        TOKEN_URL = '/sns/gettoken'

        def get_user_info(params = {})
          resp = get_user_info_by_code(params[:code])
          resp['user_info'] || {}
        end
      end
    end
  end
end