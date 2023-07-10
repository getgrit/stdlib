---
title: PreferEarlyReturn
---

# {{ page.title }}

Prefer to use early returns to keep functions flat.

tags: #lint, #style

```grit
engine marzano(0.1)
language js

`return $else` as $the_fallthrough where {
    $the_fallthrough <: after if_statement($condition, $consequence, alternative = .) as $the_if,
    // `if ($cond) { $cond_true }` as $the_if,
    $consequence <: statement_block($statements),
    $statements <: contains `return $_`,
    $the_if => `if (!$condition) { return $else }`,
    $the_fallthrough => `$statements`
}
```

## grit/example.js

```js
export const activityHandler = async (activityObj: ActivityObject, eventType: string) => {
  logger.info(`[webhook] activity event for ${activityObj.project.full_name}`, {
    activityObj,
    eventType,
  });

  const mainService = new WorkflowService();
  const logPromise = mainService.startStandardWorkflow('log_activity_data', {
    project: new Project(activityObj.project.full_name),
    inputData: activityObj,
  });
  const customEvent = checkCustomEvent(activityObj);
  if (customEvent) {
    const internalUser = InternalServiceAccount.getNamed('webhook');
    const baseCommitObj = createCommitRef(customEvent.pull_request.head.ref);
    const branchRefObj = createBranchRef(customEvent.pull_request.head.ref);
    const response = await executeOperation({
      operationName: 'platform_reply',
      internalUser,
      projectFullName: customEvent.project.full_name,
      baseCommitObj,
      branchRefObj,
      workflowArgs: { eventType: customEvent },
    });
    if (!response) {
      logger.error('failed to execute operation');
      return false;
    } else {
      return Promise.all([logPromise, response.handle]);
    }
  }
  return logPromise;
};
```

```js
export const activityHandler = async (activityObj: ActivityObject, eventType: string) => {
  logger.info(`[webhook] activity event for ${activityObj.project.full_name}`, {
    activityObj,
    eventType,
  });

  const mainService = new WorkflowService();
  const logPromise = mainService.startStandardWorkflow('log_activity_data', {
    project: new Project(activityObj.project.full_name),
    inputData: activityObj,
  });
  const customEvent = checkCustomEvent(activityObj);
  if (!(customEvent)) { return logPromise }
  const internalUser = InternalServiceAccount.getNamed('webhook');
    const baseCommitObj = createCommitRef(customEvent.pull_request.head.ref);
    const branchRefObj = createBranchRef(customEvent.pull_request.head.ref);
    const response = await executeOperation({
      operationName: 'platform_reply',
      internalUser,
      projectFullName: customEvent.project.full_name,
      baseCommitObj,
      branchRefObj,
      workflowArgs: { eventType: customEvent },
    });
    if (!response) {
      logger.error('failed to execute operation');
      return false;
    } else {
      return Promise.all([logPromise, response.handle]);
    }
};
```
