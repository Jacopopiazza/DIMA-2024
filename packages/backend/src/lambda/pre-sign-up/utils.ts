import {
  CognitoIdentityProviderClient,
  ListUsersCommand,
  AdminLinkProviderForUserCommand,
  AdminCreateUserCommand,
  AdminSetUserPasswordCommand,
  UserType,
  AdminUpdateUserAttributesCommand
} from '@aws-sdk/client-cognito-identity-provider';

const cognitoIdentityProviderClient = new CognitoIdentityProviderClient({
  region: process.env.AWS_REGION
});

const generatePassword = (length: number = 16): string => {
  const uppercaseChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  const lowercaseChars = 'abcdefghijklmnopqrstuvwxyz';
  const numberChars = '0123456789';
  const specialChars = '!@#$%^&*()_+~`|}{[]\:;?><,./-=';

  const allChars = uppercaseChars + lowercaseChars + numberChars + specialChars;

  let password = '';
  for (let i = 0; i < length; i++) {
      const randomIndex = Math.floor(Math.random() * allChars.length);
      password += allChars[randomIndex];
  }

  return password;
};

export const setUserPassword = async ({
  userPoolId,
  email
}: {
  userPoolId: string;
  email: string;
}) => {
  const adminChangePasswordCommand = new AdminSetUserPasswordCommand({
    UserPoolId: userPoolId,
    Username: email, // the email is the username
    Password: generatePassword(), // generate a random password
    Permanent: true // this is needed to set the password as permanent
  });

  await cognitoIdentityProviderClient.send(adminChangePasswordCommand);
};

export const createUser = async ({
  userPoolId,
  email,
  givenName,
  familyName
}: {
  userPoolId: string;
  email: string;
  givenName: string;
  familyName: string;
}) => {
  const adminCreateUserCommand = new AdminCreateUserCommand({
    UserPoolId: userPoolId,
    MessageAction: 'SUPPRESS', // don't send email to the user
    Username: email,
    UserAttributes: [
      {
        Name: 'given_name',
        Value: givenName
      },
      {
        Name: 'family_name',
        Value: familyName
      },
      {
        Name: 'email',
        Value: email
      },
      {
        Name: 'email_verified',
        Value: 'true'
      }
    ]
  });

  const { User } = await cognitoIdentityProviderClient.send(
    adminCreateUserCommand
  );
  return User;
};

export const linkSocialAccount = async ({
  userPoolId,
  cognitoUsername,
  providerName,
  providerUserId
}: {
  userPoolId: string;
  cognitoUsername?: string;
  providerName: string;
  providerUserId: string;
}) => {
  const linkProviderForUserCommand = new AdminLinkProviderForUserCommand({
    UserPoolId: userPoolId,
    DestinationUser: {
      ProviderName: 'Cognito', // Cognito is the default provider
      ProviderAttributeValue: cognitoUsername // this is the username of the user
    },
    SourceUser: {
      ProviderName: providerName, // Google or Facebook (first letter capitalized)
      ProviderAttributeName: 'Cognito_Subject', // Cognito_Subject is the default attribute name
      ProviderAttributeValue: providerUserId // this is the value of the provider
    }
  });

  await cognitoIdentityProviderClient.send(linkProviderForUserCommand);
};

export const findUserByEmail = async (
  email: string,
  userPoolId: string
): Promise<UserType | undefined> => {
  const listUsersCommand = new ListUsersCommand({
    UserPoolId: userPoolId,
    Filter: `email = "${email}"`,
    Limit: 1
  });

  const { Users } = await cognitoIdentityProviderClient.send(listUsersCommand);

  return Users?.[0];
};

export const updateUserAttributes = async (
  userPoolId: string,
  userName: string,
  attr: any = {}
) => {
  const userAttributes = Object.keys(attr).map((key) => {
    return {
      Name: key,
      Value: attr[key]
    };
  });

  const adminUpdateUserAttributesCommand = new AdminUpdateUserAttributesCommand(
    {
      UserPoolId: userPoolId,
      Username: userName,
      UserAttributes: userAttributes
    }
  );

  await cognitoIdentityProviderClient.send(adminUpdateUserAttributesCommand);
};
