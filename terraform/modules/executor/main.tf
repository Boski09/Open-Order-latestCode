data "aws_region" "aws-region" {}
data "aws_caller_identity" "current" {}


module "dynamodb" {
  source                = "../dynamodb"
  # project               = var.project
  # env                   = "${terraform.workspace}"
  region                = data.aws_region.aws-region.name
  dynamodb_table_name   = "Order"
  dynamo_billing_mode   = "PROVISIONED"
  dynamo_write_capacity = 5
  dynamo_read_capacity  = 10
  hash_key              = "id"
  hash_key_type         = "S"
  range_key             = "name"
  range_key_type        = "N"
  tags                  = var.tags
}

module "lambda_function" {
  source   = "../lambda"
  vpc_id                         = var.vpc_id
  subnet_ids                     = var.lambda_subnet_ids
  lambda_function_name           = "OrderCreat"
  #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
  lambda_handler_name            = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
  lambda_function_runtime        = var.lambda_function_runtime
  lambda_max_memory              = var.lambda_max_memory
  lambda_timeout                 = var.lambda_timeout
  lambda_deployment_package_path = "../lambda/lambda_function.zip"
  lambda_env_variables           = {}
  publish_lambda                 = true
  tags                           = var.tags
}
module "lambda_function_02" {
  source   = "../lambda"
  vpc_id                         = var.vpc_id
  subnet_ids                     = var.lambda_subnet_ids
  lambda_function_name           = "Order_T_OrderGet"
  #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
  lambda_handler_name            = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
  lambda_function_runtime        = var.lambda_function_runtime
  lambda_max_memory              = var.lambda_max_memory
  lambda_timeout                 = var.lambda_timeout
  lambda_deployment_package_path = "../lambda/lambda_function.zip"
  lambda_env_variables           = {}
  publish_lambda                 = true
  tags                           = var.tags
}
module "lambda_function_03" {
  source   = "../lambda"
  vpc_id                         = var.vpc_id
  subnet_ids                     = var.lambda_subnet_ids
  lambda_function_name           = "OpenOrders_T_OrderList"
  #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
  lambda_handler_name            = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
  lambda_function_runtime        = var.lambda_function_runtime
  lambda_max_memory              = var.lambda_max_memory
  lambda_timeout                 = var.lambda_timeout
  lambda_deployment_package_path = "../lambda/lambda_function.zip"
  lambda_env_variables           = {}
  publish_lambda                 = true
  tags                           = var.tags
}
module "lambda_function_04" {
  source   = "../lambda"
  vpc_id                         = var.vpc_id
  subnet_ids                     = var.lambda_subnet_ids
  lambda_function_name           = "Order_T_OrderUpdate"
  #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
  lambda_handler_name            = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
  lambda_function_runtime        = var.lambda_function_runtime
  lambda_max_memory              = var.lambda_max_memory
  lambda_timeout                 = var.lambda_timeout
  lambda_deployment_package_path = "../lambda/lambda_function.zip"
  lambda_env_variables           = {}
  publish_lambda                 = true
  tags                           = var.tags
}


module "api_lambda_function_authorizer" {
  source   = "../lambda"
  vpc_id                         = var.vpc_id
  subnet_ids                     = var.lambda_subnet_ids
  lambda_function_name           = "OrderAPIAuthorizer"
  #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
  lambda_handler_name            = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
  lambda_function_runtime        = var.lambda_function_runtime
  lambda_max_memory              = var.lambda_max_memory
  lambda_timeout                 = var.lambda_timeout
  lambda_deployment_package_path = "../lambda/lambda_function.zip"
  lambda_env_variables           = {}
  publish_lambda                 = true
  tags                           = var.tags
}


module "api" {
    source                          = "../api"
    api_name                        = "createorder"
    authorizer_lambda_invoke_arn    = module.api_lambda_function_authorizer.lambda_function_invoke_arn
    lambda_invoke_arn               = module.lambda_function.lambda_function_invoke_arn
    lambda_name                     = module.lambda_function.lambda_function_name
    lambda_name_02                  = module.lambda_function_02.lambda_function_name
    lambda_invoke_arn_02            = module.lambda_function_02.lambda_function_invoke_arn
    lambda_name_03                  = module.lambda_function_03.lambda_function_name
    lambda_invoke_arn_03            = module.lambda_function_03.lambda_function_invoke_arn
    lambda_name_04                  = module.lambda_function_04.lambda_function_name
    lambda_invoke_arn_04            = module.lambda_function_04.lambda_function_invoke_arn
   
    stage_name                      = "dev"
    tags                            = var.tags
}