module "apigateway" {
  providers = {
    aws.main = aws.main
    aws.dns  = aws.dns
  }
  source                      = "git@github.com:NequiTI/terraform_apigateway_mod.git//modules/api-gateway?ref=v4.0.1"
  capacity                    = var.capacity
  country                     = var.country
  env                         = var.env
  endpoint_types              = var.endpoint_types
  api_description             = var.api_description
  healtcheck_path_tg          = var.healtcheck_path_tg
  use_custom_domain           = false
  microservice_type           = var.microservice_type
  tags                        = var.tags
}

resource "aws_api_gateway_resource" "api" {
  provider    = aws.main
  rest_api_id = module.apigateway.aws_api_gateway_rest_api_id
  parent_id   = module.apigateway.root_resource_id
  path_part   = "api"
}

module "apikeys" {
  providers = {
    aws.main = aws.main
  }
  source          = "git@github.com:NequiTI/terraform_api_resources_Mod.git//modules/api_gateway_api_keys?ref=v4.0.1"
  capacity        = var.capacity
  country         = var.country
  env             = var.env
  confidentiality = var.confidentiality
  integrity       = var.integrity
  tags            = var.tags
  list_apikey     = local.list_apikey
  api_id          = module.apigateway.aws_api_gateway_rest_api_id
  depends_on = [module.apigateway]
}

resource "aws_api_gateway_resource" "api_reto_lambda" {
  provider    = aws.main
  rest_api_id = module.apigateway.aws_api_gateway_rest_api_id
  parent_id   = aws_api_gateway_resource.api.id
  path_part   = "reto-apgtw"
}

module "apigateway_resources_lambda" {
  providers = {
    aws.main = aws.main
  }
  source        = "git@github.com:NequiTI/terraform_api_resources_Mod.git//modules/api_gateway_lambda_integration?ref=v4.0.1"
  env           = var.env
  api_resources = local.api_resources_lambda
  api_id        = module.apigateway.aws_api_gateway_rest_api_id
  authorizer_id = null
  depends_on    = [module.apigateway]
}

data "aws_iam_role" "lambda_role" {
  name = "apimdemo-LambdaExecutionRole"
}

resource "aws_lambda_function" "reto_apgtw" {
  provider         = aws.main
  filename         = "lambda/lambda.zip"
  function_name    = "reto-apgtw-${var.env}"
  role             = data.aws_iam_role.lambda_role.arn
  handler          = var.handler
  source_code_hash = filebase64sha256("lambda/lambda.zip")
  runtime          = var.runtime
}

resource "aws_lambda_permission" "allow_apigateway" {
  provider      = aws.main
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.reto_apgtw.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${module.apigateway.stage_arn_execution}/*/*"
}
