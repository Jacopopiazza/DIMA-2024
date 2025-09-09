import { util } from '@aws-appsync/utils';

export function request(ctx) {
  const { specialization, bio, profilePictureUrl, isAvailable } =
    ctx.args.input;

  if (!ctx.identity || !ctx.identity.sub) {
    util.unauthorized();
  }

  // Get user details from previous function's stash
  const givenName = ctx.stash.givenName;
  const familyName = ctx.stash.familyName;

  if (!givenName || !familyName) {
    util.error('Missing required user attributes given_name or family_name');
  }

  const userId = ctx.identity.sub;
  const now = util.time.nowISO8601();

  // Build update expression and attribute values dynamically
  const updateExpressionParts = [];
  const expressionAttributeNames = {};
  const expressionAttributeValues = {};

  // Always update these fields
  updateExpressionParts.push('#givenName = :givenName');
  updateExpressionParts.push('#familyName = :familyName');
  updateExpressionParts.push('#updatedAt = :updatedAt');
  updateExpressionParts.push('#nutritionistId = :nutritionistId');
  updateExpressionParts.push('#gsi1pk = :gsi1pk');
  updateExpressionParts.push('#gsi1sk = :gsi1sk');

  expressionAttributeNames['#givenName'] = 'GivenName';
  expressionAttributeNames['#familyName'] = 'FamilyName';
  expressionAttributeNames['#updatedAt'] = 'UpdatedAt';
  expressionAttributeNames['#nutritionistId'] = 'NutritionistID';
  expressionAttributeNames['#gsi1pk'] = 'GSI1PK';
  expressionAttributeNames['#gsi1sk'] = 'GSI1SK';

  expressionAttributeValues[':givenName'] = util.dynamodb.toDynamoDB(givenName);
  expressionAttributeValues[':familyName'] =
    util.dynamodb.toDynamoDB(familyName);
  expressionAttributeValues[':updatedAt'] = util.dynamodb.toDynamoDB(now);
  expressionAttributeValues[':nutritionistId'] =
    util.dynamodb.toDynamoDB(userId);
  expressionAttributeValues[':gsi1pk'] =
    util.dynamodb.toDynamoDB('NUTR_PROFILES_ALL');
  expressionAttributeValues[':gsi1sk'] = util.dynamodb.toDynamoDB(
    `NUTRID#${userId}`,
  );

  // Conditionally add optional fields if they're provided
  if (specialization !== undefined) {
    updateExpressionParts.push('#specialization = :specialization');
    expressionAttributeNames['#specialization'] = 'Specialization';
    expressionAttributeValues[':specialization'] =
      util.dynamodb.toDynamoDB(specialization);
  }

  if (bio !== undefined) {
    updateExpressionParts.push('#bio = :bio');
    expressionAttributeNames['#bio'] = 'Bio';
    expressionAttributeValues[':bio'] = util.dynamodb.toDynamoDB(bio);
  }

  updateExpressionParts.push('#profilePictureUrl = :profilePictureUrl');
  expressionAttributeNames['#profilePictureUrl'] = 'ProfilePictureURL';
  expressionAttributeValues[':profilePictureUrl'] =
    util.dynamodb.toDynamoDB(profilePictureUrl);

  if (isAvailable !== undefined) {
    updateExpressionParts.push('#isAvailable = :isAvailable');
    expressionAttributeNames['#isAvailable'] = 'IsAvailable';
    expressionAttributeValues[':isAvailable'] =
      util.dynamodb.toDynamoDB(isAvailable);
  }

  // Set CreatedAt only if the item doesn't exist (using SET if_not_exists)
  updateExpressionParts.push(
    '#createdAt = if_not_exists(#createdAt, :createdAt)',
  );
  expressionAttributeNames['#createdAt'] = 'CreatedAt';
  expressionAttributeValues[':createdAt'] = util.dynamodb.toDynamoDB(now);

  const updateExpression = 'SET ' + updateExpressionParts.join(', ');

  return {
    operation: 'UpdateItem',
    key: util.dynamodb.toMapValues({
      PK: `NUTR#${userId}`,
      SK: 'NUTR_DETAILS',
    }),
    update: {
      expression: updateExpression,
      expressionNames: expressionAttributeNames,
      expressionValues: expressionAttributeValues,
    },
  };
}

export function response(ctx) {
  const item = ctx.result;

  if (!item) {
    return null;
  }

  return {
    id: item.NutritionistID,
    nutritionistId: item.NutritionistID,
    givenName: item.GivenName,
    familyName: item.FamilyName,
    specialization: item.Specialization,
    bio: item.Bio,
    profilePictureUrl:
      item.ProfilePictureURL && item.ProfilePictureURL.trim() !== ''
        ? item.ProfilePictureURL
        : null,
    isAvailable: item.IsAvailable,
  };
}
