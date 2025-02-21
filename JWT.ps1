# Load your certificate
$certificatePath = "Path/To/Your/Certificate.pfx"
$certificatePassword = ConvertTo-SecureString "password" -AsPlainText -Force
$cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($certificatePath, $certificatePassword, [System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::Exportable)

# Define variables (azure stuff)
$tenantId = "change-me"
$clientId = "change-me"
$audience = "https://login.microsoftonline.com/$tenantId/v2.0"
$now = [System.DateTime]::UtcNow
$unixEpoch = Get-Date "1970-01-01T00:00:00Z" # Unix Epoch date

# Function to convert to Base64Url
function ConvertTo-Base64Url ($bytes) {
    $base64 = [System.Convert]::ToBase64String($bytes)
    return $base64.TrimEnd('=').Replace('+', '-').Replace('/', '_')
}

# Generate JWT header
$header = @{
    alg = "RS256"
    typ = "JWT"
    x5t = ConvertTo-Base64Url($cert.GetCertHash()) # Fix x5t encoding
}

# Generate JWT payload
$payload = @{
    aud = $audience
    exp = [int](($now.AddMinutes(60) - $unixEpoch).TotalSeconds) # Subtract Unix Epoch from now for expiry
    iss = $clientId
    sub = $clientId
    jti = [guid]::NewGuid().ToString()
    nbf = [int](($now.AddMinutes(-5) - $unixEpoch).TotalSeconds) # Subtract Unix Epoch from now for not before
}

# Encode to JSON and Base64Url
$headerJson = ($header | ConvertTo-Json -Compress)
$payloadJson = ($payload | ConvertTo-Json -Compress)

# Ensure that the JSON is not null before encoding
if ($headerJson -ne $null -and $payloadJson -ne $null) {
    $headerEncoded = ConvertTo-Base64Url ([System.Text.Encoding]::UTF8.GetBytes($headerJson))
    $payloadEncoded = ConvertTo-Base64Url ([System.Text.Encoding]::UTF8.GetBytes($payloadJson))
} else {
    Write-Error "Header or Payload JSON is null!"
    exit
}

$unsignedJwt = "$headerEncoded.$payloadEncoded"

# Sign the JWT using the certificate's private key
$privateKey = [System.Security.Cryptography.X509Certificates.RSACertificateExtensions]::GetRSAPrivateKey($cert)
$signature = $privateKey.SignData([System.Text.Encoding]::UTF8.GetBytes($unsignedJwt), [System.Security.Cryptography.HashAlgorithmName]::SHA256, [System.Security.Cryptography.RSASignaturePadding]::Pkcs1)
$signatureEncoded = ConvertTo-Base64Url $signature

# Final JWT
$jwt = "$unsignedJwt.$signatureEncoded"

Write-Output "Generated JWT:"
Write-Output $jwt
