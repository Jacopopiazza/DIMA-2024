import {
  PostConfirmationTriggerEvent,
  PostConfirmationTriggerHandler,
} from 'aws-lambda';
import { SubscriptionStatus } from '../../types/SubscriptionStatus';
import { updateUserAttributes } from '../pre-sign-up/utils';

export const handler: PostConfirmationTriggerHandler = async (
  event: PostConfirmationTriggerEvent,
) => {
  console.log(
    'PostConfirmationTriggerHandler event: ',
    JSON.stringify(event, null, 2),
  );

  const { userPoolId, userName, request } = event;
  const userAttributes = request.userAttributes;

  // Set a default subscription status (e.g., "free") if not already set
  if (!userAttributes['custom:subscriptionStatus']) {
    try {
      // Update the user's attributes in Cognito
      await updateUserAttributes(userPoolId, userName, {
        'custom:subscriptionStatus': SubscriptionStatus.FREE,
      });
      console.log(
        `Successfully updated subscriptionStatus for user ${userName}`,
      );
    } catch (error) {
      console.error('Error updating subscriptionStatus in Cognito:', error);
      throw error;
    }
  }

  // Return the event to continue the signup process
  return event;
};
