import { util } from '@aws-appsync/utils';

// query.getChatMessages.loadMessages.js
export function request(ctx) {
  const {
    chatId,
    limit = 20,
    beforeTimestamp, // For getting older messages (load more history)
  } = ctx.args;

  const userId = ctx.stash.userId; // Set by previous resolver in pipeline
  if (!userId) {
    util.unauthorized();
  }

  ctx.stash.chatId = chatId;
  ctx.stash.requestedLimit = limit;
  ctx.stash.beforeTimestamp = beforeTimestamp;

  let queryParams = {
    operation: 'Query',
    query: {
      expression: 'PK = :pk AND begins_with(SK, :sk)',
      expressionValues: util.dynamodb.toMapValues({
        ':pk': `CHAT#${chatId}`,
        ':sk': 'MSG#',
      }),
    },
    scanIndexForward: false, // Always descending (newest first)
    limit: limit,
  };

  // If beforeTimestamp is provided, get older messages
  if (beforeTimestamp) {
    queryParams.query.expression =
      'PK = :pk AND SK BETWEEN :beforeSK AND :afterSK';
    queryParams.query.expressionValues[':beforeSK'] =
      util.dynamodb.toDynamoDB(`MSG#0}`);
    queryParams.query.expressionValues[':afterSK'] = util.dynamodb.toDynamoDB(
      `MSG#${beforeTimestamp - 1}`,
    );
    delete queryParams.query.expressionValues[':sk'];
  }

  return queryParams;
}

export function response(ctx) {
  if (ctx.error) {
    util.error('Failed to load messages', ctx.error.type, ctx.error);
  }

  const items = ctx.result?.items || [];

  // Filter to only include messages (in case we got other items)
  const messageItems = items.filter(
    (item) => item.SK && item.SK.startsWith('MSG#'),
  );

  // Transform messages and extract timestamps
  const messages = messageItems.map((item) => {
    const timestampStr = item.SK.replace('MSG#', '');
    const timestamp = +timestampStr; // Use unary plus operator to convert to number
    return {
      ...item,
      timestamp,
      messageId: item.SK,
    };
  });

  // Get the oldest timestamp for next pagination
  const oldestTimestamp =
    messages.length > 0 ? Math.min(...messages.map((m) => m.timestamp)) : null;

  return {
    messages,
    oldestTimestamp, // Use this for the next beforeTimestamp
    hasMore: messages.length === ctx.stash.requestedLimit, // If we got full limit, likely more exist
    count: messages.length,
  };
}
