require 'omniauth-dingding/client/third_party_personal'
require 'omniauth-dingding/client/enterprise_internal'

module OmniAuth
  module Dingding
    module Client
      class << self
        def get(client_type)
          case client_type.to_s
          when 'third_party_personal'
            ::OmniAuth::Dingding::Client::ThirdPartyPersonal
          else
            ::OmniAuth::Dingding::Client::EnterpriseInternal
          end
        end
      end
    end
  end
end