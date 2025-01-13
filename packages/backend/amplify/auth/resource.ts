import { defineAuth, secret } from '@aws-amplify/backend';
import { preTokenGenerationLambda } from './preTokenGeneration/resource';
/**
 * Define and configure your auth resource
 * @see https://docs.amplify.aws/gen2/build-a-backend/auth
 */
export const auth = defineAuth({
  loginWith: {
    email: true,
    externalProviders: {
      google: {
        clientId: secret('GOOGLE_CLIENT_ID'),
        clientSecret: secret('GOOGLE_CLIENT_SECRET'),
        scopes: ['profile email'],
                
        attributeMapping: {
          email: 'email',
          givenName: 'given_name',
          familyName: 'family_name',
        }
      },
      /*signInWithApple: {
        clientId: secret('SIWA_CLIENT_ID'),
        keyId: secret('SIWA_KEY_ID'),
        privateKey: secret('SIWA_PRIVATE_KEY'),
        teamId: secret('SIWA_TEAM_ID')
      },
      loginWithAmazon: {
        clientId: secret('LOGINWITHAMAZON_CLIENT_ID'),
        clientSecret: secret('LOGINWITHAMAZON_CLIENT_SECRET')
      },
      facebook: {
        clientId: secret('FACEBOOK_CLIENT_ID'),
        clientSecret: secret('FACEBOOK_CLIENT_SECRET')
      },*/
      callbackUrls: [
        'http://localhost:3000/profile',
      ],
      logoutUrls: ['http://localhost:3000/'],
    }
  },

  multifactor: {
    mode: "OPTIONAL",
    totp: true,
  },

  groups: ["USERS","NUTRITIONISTS","ADMIN"],

  userAttributes: {
    givenName: {
      required: true,
      mutable: false,
    },
    familyName: {
      required: true,
      mutable: false,
    },
    email: {
      required: true,
      mutable: false,
    },
    birthdate: {
      required: false,
      mutable: false
    },
    gender: {
      required: false,
      mutable: false
    },
    profilePicture: {
      required: false,
      mutable: true
    },
    "custom:subscriptionStatus" : {
      dataType: "String",
      mutable: true,
    }
  },

  triggers: {
    preTokenGeneration: preTokenGenerationLambda
  },
  access: (allow) => [
    allow.resource(preTokenGenerationLambda).to(["addUserToGroup", "manageUsers"]),
    allow.resource(preTokenGenerationLambda).to(["updateUserAttributes"]),
    allow.resource(preTokenGenerationLambda).to(["listGroupsForUser"])
    ],
});
