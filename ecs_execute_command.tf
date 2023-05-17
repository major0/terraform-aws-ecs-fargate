data "aws_iam_policy_document" "enable_execute_command" {
  count = var.enable_execute_command && var.task_role_arn == "" ? 1 : 0

  statement {
    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "enable_execute_command" {
  count = var.enable_execute_command ? 1 : 0

  name   = "enable-execute-command-${var.service_name}-${data.aws_region.current.name}"
  path   = "/ecs/task-role/"
  policy = data.aws_iam_policy_document.enable_execute_command[count.index].json
}

resource "aws_iam_role_policy_attachment" "enable_execute_command" {
  count = var.enable_execute_command && var.task_role_arn == "" ? 1 : 0

  role       = aws_iam_role.ecs_task_role[count.index].name
  policy_arn = aws_iam_policy.enable_execute_command[count.index].arn
}
