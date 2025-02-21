$tenantId = "change-me"
$clientId = "change-me"
# Jwt from JWT.ps1
$jwt = "" 


$body = @{
    client_id = $clientId
    scope = "https://<YOUR-DOMAIN>.sharepoint.com/.default"
    grant_type = "client_credentials"
    client_assertion_type = "urn:ietf:params:oauth:client-assertion-type:jwt-bearer"
    client_assertion = $jwt
}

$response = Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token" -ContentType "application/x-www-form-urlencoded" -Body $body
Write-Output $response.access_token
