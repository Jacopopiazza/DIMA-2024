// ============================================
// updateNutritionistLocation Resolver
// Updates location fields in existing NUTR_DETAILS record
// ============================================
import { util } from '@aws-appsync/utils';

export function request(ctx) {
  const nutritionistId = ctx.identity.sub;
  const { input } = ctx.args;

  // Validate required fields
  if (input.latitude == null || input.longitude == null) {
    util.error('Latitude and longitude are required', 'ValidationException');
  }

  const now = util.time.nowISO8601();

  // Build SET expression
  let setExpr = [
    '#updatedAt = :updatedAt',
    '#latitude = :latitude',
    '#longitude = :longitude',
  ];

  const exprNames = {
    '#updatedAt': 'updatedAt',
    '#latitude': 'latitude',
    '#longitude': 'longitude',
  };

  const exprValues = util.dynamodb.toMapValues({
    ':updatedAt': now,
    ':latitude': input.latitude,
    ':longitude': input.longitude,
  });

  // Track attributes to remove
  const removeExpr = [];

  exprNames['#address'] = 'address';
  if (!input.address) {
    removeExpr.push('#address');
  } else {
    setExpr.push('#address = :address');
    exprValues[':address'] = util.dynamodb.toDynamoDB(input.address);
  }

  exprNames['#notes'] = 'notes';
  if (!input.notes) {
    removeExpr.push('#notes');
  } else {
    setExpr.push('#notes = :notes');
    exprValues[':notes'] = util.dynamodb.toDynamoDB(input.notes);
  }

  // Combine SET and REMOVE
  let updateExpression = 'SET ' + setExpr.join(', ');
  if (removeExpr.length > 0) {
    updateExpression += ' REMOVE ' + removeExpr.join(', ');
  }

  return {
    operation: 'UpdateItem',
    key: util.dynamodb.toMapValues({
      PK: `NUTR#${nutritionistId}`,
      SK: 'NUTR_DETAILS',
    }),
    update: {
      expression: updateExpression,
      expressionNames: exprNames,
      expressionValues: exprValues,
    },
    condition: {
      expression: 'attribute_exists(PK) AND attribute_exists(SK)',
    },
  };
}

export function response(ctx) {
  if (ctx.error) {
    if (ctx.error.type === 'ConditionalCheckFailedException') {
      util.error('Nutritionist profile not found', 'NotFound');
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
    latitude: item.latitude ?? null,
    longitude: item.longitude ?? null,
    address: item.address ?? null,
    notes: item.notes ?? null,
    updatedAt: item.updatedAt,
  };
}
