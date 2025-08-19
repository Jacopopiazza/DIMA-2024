// packages/backend/vtl-templates/query.ListMyMealPlans.js

export function request(ctx) {
  return {
    operation: 'Query',
    query: {
      expression: 'PK = :pk AND begins_with(SK, :sk)',
      expressionValues: {
        ':pk': { S: `USER#${ctx.identity.sub}` },
        ':sk': { S: 'PLAN#' }, // Assuming your SK pattern
      },
    },
  };
}

export function response(ctx) {
  const items = ctx.result && ctx.result.items ? ctx.result.items : [];
  const nextToken =
    ctx.result && ctx.result.nextToken ? ctx.result.nextToken : null;

  // Find the active meal plan by status
  const activeMealPlan = items.find((plan) => plan.status === 'ACTIVE');
  const activeMealPlanId = activeMealPlan ? activeMealPlan.mealPlanId : null;

  return {
    items,
    nextToken,
    activeMealPlan: activeMealPlanId,
  };
}
