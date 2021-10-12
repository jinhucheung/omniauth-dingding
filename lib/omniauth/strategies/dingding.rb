require 'omniauth-dingding/client'

module OmniAuth
  module Strategies
    class Dingding < OmniAuth::Strategies::OAuth2
      option :name, 'dingding'

      option :client_options, {
        site: 'https://oapi.dingtalk.com',
        # one of qrcode, account, default is qrcode
        authorize_method: :qrcode
      }

      # one of enterprise_internal, third_party_personal, default is enterprise_internal
      option :client_type, :enterprise_internal

      # one of snsapi_login, snsapi_auth, default is snsapi_login
      option :authorize_params, scope: 'snsapi_login'

      uid do
        user_info['openid']
      end

      info do
        {
          unionid: user_info['unionid'],
          username: user_info['nick'],
          ding_id: user_info['dingId']
        }.merge(user_info)
      end

      extra do
        { raw_info: user_info }
      end

      def request_phase
        params = client.auth_code.authorize_params.merge(redirect_uri: callback_url).merge(authorize_params)
        params['appid'] = params.delete('client_id')
        redirect client.authorize_url(params)
      end

      protected

      def client
        ::OmniAuth::Dingding::Client.get(options.client_type).new(
          options.client_id,
          options.client_secret,
          deep_symbolize(options.client_options)
        )
      end

      def build_access_token
        verifier = request.params['code']
        client.auth_code.get_token(verifier, { redirect_uri: callback_url }.merge(token_params.to_hash(symbolize_keys: true)), deep_symbolize(options.auth_token_params))
      end

      def user_info
        @user_info ||= client.get_user_info(code: request.params['code'], access_token: access_token.token)
      end
    end
  end
end

OmniAuth.config.add_camelization 'dingding', 'Dingding'