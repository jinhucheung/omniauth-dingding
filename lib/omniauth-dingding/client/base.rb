require 'openssl'
require 'base64'
require 'cgi'
require 'json'

module OmniAuth
  module Dingding
    module Client
      class Base < ::OAuth2::Client
        AUTHORIZE_URL = {
          'qrcode' => '/connect/qrconnect',
          'account' => '/connect/oauth2/sns_authorize'
        }.freeze

        GET_USER_INFO_BY_CODE_URL = '/sns/getuserinfo_bycode'

        GET_USER_ID_BY_UNIONID_URL = '/topapi/user/getbyunionid'

        GET_USER_INFO_BY_ID_URL = 'topapi/v2/user/get'

        def initialize(client_id, client_secret, options = {}, &block)
          opts = {
            authorize_url: AUTHORIZE_URL.fetch(options[:authorize_method].to_s, AUTHORIZE_URL['qrcode']),
            token_url: token_url,
            token_method: :get
          }.merge(options)

          super(client_id, client_secret, opts, &block)
        end

        def get_user_info_by_code(code)
          t = (Time.now.to_f * 1000).to_i.to_s
          raw_sign = Base64.encode64(OpenSSL::HMAC.digest('SHA256', secret, t)).strip
          sign = CGI.escape(raw_sign)

          url = "#{GET_USER_INFO_BY_CODE_URL}?accessKey=#{id}&timestamp=#{t}&signature=#{sign}"

          request(:post, url,
            headers: { 'Content-Type' => 'application/json' },
            body: { tmp_auth_code: code }.to_json
          ).parsed
        end

        def get_user_id_by_unionid(access_token, unionid)
          request(:post, GET_USER_ID_BY_UNIONID_URL,
            headers: { 'Content-Type' => 'application/json' },
            body: { unionid: unionid }.to_json,
            params: { access_token: access_token }
          ).parsed
        end

        def get_user_info_by_id(access_token, id)
          request(:post, GET_USER_INFO_BY_ID_URL,
            headers: { 'Content-Type' => 'application/json' },
            body: { userid: id }.to_json,
            params: { access_token: access_token }
          ).parsed
        end

        def get_user_info(params = {})
          raise NotImplementedError
        end

        def token_url
          self.class.const_get(:TOKEN_URL) rescue nil
        end

        def token_params
          { appid: id, appsecret: secret }
        end

        def get_token(params, access_token_opts = {}, extract_access_token = options[:extract_access_token])
          super(token_params.merge(params), access_token_opts, extract_access_token)
        end
      end
    end
  end
end