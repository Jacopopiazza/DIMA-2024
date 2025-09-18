// ============================================
// getNutritionistLocation Resolver
// Gets location fields from existing NUTR_DETAILS record
// ============================================
import { util } from '@aws-appsync/utils';

export function request(ctx) {
  const { nutritionistId } = ctx.args;

  if (!nutritionistId) {
    util.error('nutritionistId is required', 'ValidationException');
  }

  return {
    operation: 'GetItem',
    key: util.dynamodb.toMapValues({
      PK: `NUTR#${nutritionistId}`,
      SK: 'NUTR_DETAILS',
    }),
    // Fixed: projection should be an object with expression property
    projection: {
      expression:
        'NutritionistID, latitude, longitude, address, notes, updatedAt',
    },
  };
}

export function response(ctx) {
  if (ctx.error) {
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
    latitude: item.latitude,
    longitude: item.longitude,
    address: item.address ?? null,
    notes: item.notes ?? null,
    updatedAt: item.updatedAt,
  };
}
