require 'omniauth-dingding/client/base'

module OmniAuth
  module Dingding
    module Client
      class EnterpriseInternal < ::OmniAuth::Dingding::Client::Base
        TOKEN_URL = '/gettoken'

        def token_params
          { appkey: id, appsecret: secret }
        end

        def get_user_info(params = {})
          resp = get_user_info_by_code(params[:code])
          user_info = resp['user_info'] || {}
          return user_info if user_info['unionid'].to_s.empty?

          user_id = get_user_id_by_unionid(params[:access_token], user_info['unionid']).dig('result', 'userid')
          return user_info if user_id.to_s.empty?

          result = get_user_info_by_id(params[:access_token], user_id)['result']
          user_info.merge(result || {})
        end
      end
    end
  end
end