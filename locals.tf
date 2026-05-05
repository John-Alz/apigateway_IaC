locals {

  list_apikey = {
    api_key_test_1 = {
      enable_quota    = true
      quota_limit     = 100000
      quota_period    = "DAY"
      quota_offset    = 0
      enable_throttle = true
      burst_limit     = 1
      rate_limit      = 1
    }
  }

  api_resources_lambda = {
    "metodo1" = {
      "resource_id" : aws_api_gateway_resource.api_reto_lambda.id,
      "http_method" : "GET",
      "authorization" : "NONE", # Es fundamental validar este dato con el arquitecto del proyecto y el equipo de ciberseguridad para definir el tipo de autorización adecuado para su caso de uso.
      "api_key_required" : true, # Este valor es obligatorio debido a controles de seguridad. Si considera que no aplica a su caso de uso, deberá escalarlo con el equipo de ciberseguridad para evaluar la posibilidad de una solicitud de excepción, si corresponde.
      "integration_type" : "AWS_PROXY",
      "integration_http_method" : "POST", # Tenga en cuenta que, si su método es GET pero requiere validar autenticación o autorización en la Lambda, será necesario configurar la integración como POST.
      "status_code" : 200,
      "integration_uri" : "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/${aws_lambda_function.reto_apgtw.arn}/invocations",
      "method_request_parameters" : {},
      "method_response_parameters" : {},
      "integration_request_parameters" : {},
      "integration_response_parameters" : {},
      "request_templates" : {},
      "response_models" : {},
      "integration_response_templates" : {}
    }
  }

}