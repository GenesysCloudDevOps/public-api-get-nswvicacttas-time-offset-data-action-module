resource "genesyscloud_integration_action" "action" {
    name           = var.action_name
    category       = var.action_category
    integration_id = var.integration_id
    secure         = var.secure_data_action
    
    contract_input  = jsonencode({
        "$schema" = "http://json-schema.org/draft-04/schema#",
        "properties" = {},
        "type" = "object"
    })
    contract_output = jsonencode({
        "$schema" = "http://json-schema.org/draft-04/schema#",
        "properties" = {
            "TimezoneId" = {
                "description" = "",
                "title" = "Timezone Offset",
                "type" = "integer"
            },
            "contactId" = {
                "description" = "",
                "title" = "Id",
                "type" = "string"
            }
        },
        "type" = "object"
    })
    
    config_request {
        request_template     = "$${input.rawRequest}"
        request_type         = "GET"
        request_url_template = "/api/v2/timezones?pageSize=500&pageNumber=1"
        headers = {
			Content-Type = "application/json"
		}
    }

    config_response {
        success_template = "{\"TimezoneId\": $${successTemplateUtils.firstFromArray($${TimezoneId})}}"
        translation_map = { 
			TimezoneId = "$.entities[?(@.id == 'Australia/Sydney')].offset"
		}
               
    }
}