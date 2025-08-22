import { util } from '@aws-appsync/utils';

/**
 * Resolver per la mutation notifyMealPlanStatusChanged
 * Questa mutation è chiamata solo dalle lambda interne per triggerare le subscriptions
 */
export function request(ctx) {
  // Valida l'input
  const { input } = ctx.args;

  if (!input || !input.mealPlanId || !input.success) {
    util.error(
      'Missing required fields in notification input',
      'ValidationException',
    );
  }

  console.log('Processing meal plan notification:', {
    mealPlanId: input.mealPlanId,
    success: input.success,
    message: input.message,
  });

  // Non esegue nessuna operazione su database - è solo per triggerare la subscription
  // Usa il data source "None" - non ha bisogno di operazioni DB
  return {};
}

/**
 * Response function - ritorna i dati della notifica per la subscription
 */
export function response(ctx) {
  // Se ci sono errori nel request, propagali
  if (ctx.error) {
    console.error('Error in notifyMealPlanStatusChanged request:', ctx.error);
    util.error(ctx.error.message, ctx.error.type);
  }

  const { input } = ctx.args;

  // Costruisce la risposta MealPlanNotification
  const notification = {
    mealPlanId: input.mealPlanId,
    success: input.success,
    message: input.message,
  };

  console.log('Returning meal plan notification:', notification);

  return notification;
}
