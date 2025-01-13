import type { PreTokenGenerationTriggerHandler } from "aws-lambda";
import {
    CognitoIdentityProviderClient,
    AdminAddUserToGroupCommand,
    AdminGetUserCommand,
    AdminUpdateUserAttributesCommand,
    AdminListGroupsForUserCommand
} from '@aws-sdk/client-cognito-identity-provider';
import { UserGroup } from "../../enums/UserGroup";
import { SubscriptionStatus } from "../../enums/SubscriptionStatus";

const client = new CognitoIdentityProviderClient();

export const handler: PreTokenGenerationTriggerHandler = async (event) => {
    try {

        const listGroupsCommand = new AdminListGroupsForUserCommand({
            UserPoolId: event.userPoolId,
            Username: event.userName
        });

        const groupList = await client.send(listGroupsCommand);

        if (groupList.Groups && groupList.Groups.length > 0) {
            console.log(`User ${event.userName} is already in a group. Skipping initialization.`);
            return event;
        }

        console.log(`User ${event.userName} is new. Initializing user.`);

        const addUserToGroupCommand = new AdminAddUserToGroupCommand({
            GroupName: UserGroup.User,
            Username: event.userName,
            UserPoolId: event.userPoolId
        });

        try {
            await client.send(addUserToGroupCommand);
            console.log(`User ${event.userName} added to group USERS`);
        } catch (groupError) {
            console.error("Error adding user to group:", groupError);
            throw groupError;
        }

        const getUserCommand = new AdminGetUserCommand({
            UserPoolId: event.userPoolId,
            Username: event.userName
        });

        const userDetails = await client.send(getUserCommand);

        const attributesToUpdate = [];

        const subscriptionStatus = userDetails.UserAttributes?.find(attr => attr.Name === 'custom:subscriptionStatus')?.Value;

        if (!subscriptionStatus) {
            attributesToUpdate.push({ Name: 'custom:subscriptionStatus', Value: SubscriptionStatus.Free});
        }

        if (attributesToUpdate.length > 0) {
            const updateUserAttributesCommand = new AdminUpdateUserAttributesCommand({
                UserPoolId: event.userPoolId,
                Username: event.userName,
                UserAttributes: attributesToUpdate,
            });
            await client.send(updateUserAttributesCommand);
            console.log(`User ${event.userName} attributes updated`);
        } else {
            console.log(`User ${event.userName} attributes are already set`);
        }

        return event;

    } catch (error) {
        console.error('Error in preTokenGeneration trigger:', error);
        throw error;
    }
};