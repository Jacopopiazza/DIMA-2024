export function request(ctx) {
  const { givenName, familyName, specialization, bio, profilePictureUrl, isAvailable } = ctx.args.input;
  const userId = ctx.identity.sub;
  const now = util.time.nowISO8601();
  
  const updateExpression = [];
  const expressionValues = {};
  
  if (givenName !== undefined) {
    updateExpression.push('GivenName = :givenName');
    expressionValues[':givenName'] = givenName;
  }
  
  if (familyName !== undefined) {
    updateExpression.push('FamilyName = :familyName');
    expressionValues[':familyName'] = familyName;
  }
  
  if (specialization !== undefined) {
    updateExpression.push('Specialization = :specialization');
    expressionValues[':specialization'] = specialization;
  }
  
  if (bio !== undefined) {
    updateExpression.push('Bio = :bio');
    expressionValues[':bio'] = bio;
  }
  
  if (profilePictureUrl !== undefined) {
    updateExpression.push('ProfilePictureURL = :profilePictureUrl');
    expressionValues[':profilePictureUrl'] = profilePictureUrl;
  }
  
  if (isAvailable !== undefined) {
    updateExpression.push('IsAvailable = :isAvailable');
    expressionValues[':isAvailable'] = isAvailable;
  }
  
  // Always update the timestamp
  updateExpression.push('UpdatedAt = :updatedAt');
  expressionValues[':updatedAt'] = now;
  
  return {
    operation: 'UpdateItem',
    key: util.dynamodb.toMapValues({
      PK: `NUTR#${userId}`,
      SK: 'NUTR_DETAILS'
    }),
    update: {
      expression: `SET ${updateExpression.join(', ')}`,
      expressionValues: util.dynamodb.toMapValues(expressionValues)
    },
    condition: {
      expression: 'attribute_exists(PK) AND attribute_exists(SK)'
    }
  };
}

export function response(ctx) {
  const item = ctx.result;
  
  if (!item) {
    return null;
  }
  
  // Transform DynamoDB item to match NutritionistProfile type
  return {
    id: item.NutritionistID, // Add id for codegen compatibility
    nutritionistId: item.NutritionistID,
    givenName: item.GivenName,
    familyName: item.FamilyName,
    specialization: item.Specialization,
    bio: item.Bio,
    profilePictureUrl: item.ProfilePictureURL && item.ProfilePictureURL.trim() !== '' 
      ? item.ProfilePictureURL 
      : null,
    isAvailable: item.IsAvailable
  };
} 