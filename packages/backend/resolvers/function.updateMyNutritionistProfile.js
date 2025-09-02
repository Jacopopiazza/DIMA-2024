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

  const itemData = {
    PK: `NUTR#${userId}`,
    SK: 'NUTR_DETAILS',
    NutritionistID: userId,
    GivenName: givenName,
    FamilyName: familyName,
    Specialization: specialization,
    Bio: bio,
    ProfilePictureURL: profilePictureUrl,
    IsAvailable: isAvailable,
    CreatedAt: now,
    UpdatedAt: now,
    GSI1PK: 'NUTR_PROFILES_ALL',
    GSI1SK: `NUTRID#${userId}`,
  };

  return {
    operation: 'PutItem',
    key: util.dynamodb.toMapValues({
      PK: `NUTR#${userId}`,
      SK: 'NUTR_DETAILS',
    }),
    attributeValues: util.dynamodb.toMapValues(itemData),
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
