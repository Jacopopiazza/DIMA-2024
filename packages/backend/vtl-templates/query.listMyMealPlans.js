// packages/backend/vtl-templates/query.ListMyMealPlans.js

export function request(ctx) {
  // Query meal plans for the current user from DynamoDB
  return {
    operation: 'Query',
    query: {
      expression: 'PK = :pk',
      expressionValues: {
        ':pk': { S: `USER#${ctx.identity.sub}` },
      },
    },
  };
}

export function response(ctx) {
  // Debug log for ctx.result
  console.log('ctx.result:', JSON.stringify(ctx.result));

  const items = ctx.result && ctx.result.items ? ctx.result.items : [];
  const nextToken =
    ctx.result && ctx.result.nextToken ? ctx.result.nextToken : null;

  // If the user's activeMealPlanId is available in the user's details, use it
  // This example assumes it is available in ctx.stash.activeMealPlanId
  // You may need to adjust this based on your pipeline setup
  const activeMealPlanId = ctx.stash.activeMealPlanId;
  let activeMealPlan = null;
  if (activeMealPlanId) {
    activeMealPlan = items.find((plan) => plan.mealPlanId === activeMealPlanId);
  }

  return {
    items,
    nextToken,
    activeMealPlan,
  };
}
