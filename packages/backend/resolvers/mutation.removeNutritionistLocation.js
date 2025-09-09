// ============================================
// removeNutritionistLocation Resolver
// Removes location fields from existing NUTR_DETAILS record
// ============================================
import { util } from '@aws-appsync/utils';

export function request(ctx) {
  const nutritionistId = ctx.identity.sub;

  return {
    operation: 'UpdateItem',
    key: util.dynamodb.toMapValues({
      PK: `NUTR#${nutritionistId}`,
      SK: 'NUTR_DETAILS',
    }),
    update: {
      expression:
        'REMOVE #latitude, #longitude, #address, #notes SET #updatedAt = :updatedAt',
      expressionNames: {
        '#latitude': 'latitude',
        '#longitude': 'longitude',
        '#address': 'address',
        '#notes': 'notes',
        '#updatedAt': 'updatedAt',
      },
      expressionValues: util.dynamodb.toMapValues({
        ':updatedAt': util.time.nowISO8601(),
      }),
    },
    condition: {
      expression: 'attribute_exists(PK) AND attribute_exists(SK)',
    },
  };
}

export function response(ctx) {
  if (ctx.error) {
    if (ctx.error.type === 'ConditionalCheckFailedException') {
      return null; // No profile found
    }
    util.error(ctx.error.message, ctx.error.type);
  }

  const item = ctx.result;

  if (!item) return null;

  // Return null if no location data exists
  if (item.latitude == null || item.longitude == null) {
    return null;
  }

  return {
    nutritionistId: item.nutritionistId ?? item.NutritionistID,
    latitude: null,
    longitude: null,
    address: null,
    notes: null,
    updatedAt: item.updatedAt,
  };
}
