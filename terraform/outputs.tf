output "tls_private_key" { 
    value = tls_private_key.jenkins_ssh.private_key_pem 
    sensitive = true
}


output "azurerm_public_ip" {
  value = azurerm_public_ip.dev_publicip.*.ip_address
  depends_on = [azurerm_public_ip.dev_publicip]
}
