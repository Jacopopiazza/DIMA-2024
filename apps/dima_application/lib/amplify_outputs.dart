const amplifyConfig = r'''{
  "version": "1",
  "data": {
    "aws_region": "us-west-2",
    "url": "https://wxc4v4f7ovcahml6nnsgvdbfea.appsync-api.us-west-2.amazonaws.com/graphql",
    "default_authorization_type": "AMAZON_COGNITO_USER_POOLS",
    "authorization_types": ["AMAZON_COGNITO_USER_POOLS"]
  },
  "auth": {
    "aws_region": "us-west-2",
    "user_pool_id": "us-west-2_fQpGATfnW",
    "user_pool_client_id": "1jpsfjkq93r6isi22opgl398kn",
    "identity_pool_id": "us-west-2:92fa5e1c-ce70-4a66-9b32-06ae93c14dcd",
    "username_attributes": ["email"],
    "standard_required_attributes": [
      "email",
      "given_name",
      "family_name"
    ],
    "mfa_configuration": "OPTIONAL",
    "mfa_methods": [
      "TOTP"
    ],
    "user_verification_types": ["email"],
    "unauthenticated_identities_enabled": false,
    "password_policy": {
      "min_length": 8,
      "require_lowercase": true,
      "require_uppercase": true,
      "require_numbers": true,
      "require_symbols": true
    },
    "groups": [
      {
        "USERS": {
          "precedence": 0
        }
      },
      {
        "NUTRITIONISTS": {
          "precedence": 1
        }
      },
      {
        "ADMIN": {
          "precedence": 2
        }
      }
    ],
    "oauth": {
      "identity_providers": [
        "GOOGLE"
      ],
      "redirect_sign_in_uri": [
        "http://localhost:3000/profile",
        "dima://auth"
      ],
      "redirect_sign_out_uri": [
        "http://localhost:3000/",
        "dima://logout"
      ],
      "response_type": "code",
      "scopes": [
        "phone",
        "email",
        "openid",
        "profile",
        "aws.cognito.signin.user.admin"
      ],
      "domain": "e2c748be1d135a2c6733.auth.us-west-2.amazoncognito.com"
    }
  }
}''';
