# Nom du conteneur Docker
$nomConteneur = "projet-rentree-back"

# Commande à exécuter dans le conteneur
$commande = "npm run web"

# Exécute la commande dans le conteneur Docker en redirigeant la sortie vers $null
Write-Host "Exécution de la commande dans le conteneur Docker : $nomConteneur"
$dockerCommand = "docker run $nomConteneur $commande > $null 2>&1"
Invoke-Expression $dockerCommand

# Vérifie le code de retour de la commande
if ($LASTEXITCODE -eq 0) {
    Write-Host "La commande a été exécutée avec succès dans le conteneur."
} else {
    Write-Host "La commande a échoué dans le conteneur."
    exit $LASTEXITCODE
}
