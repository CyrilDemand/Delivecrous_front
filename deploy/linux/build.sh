#!/bin/bash

network_name="mon-reseau"

# Vérifier si le réseau Docker existe déjà
if ! docker network inspect $network_name >/dev/null 2>&1; then
    # Le réseau n'existe pas, le créer
    docker network create $network_name
    echo "Réseau Docker '$network_name' créé avec succès."
else
    echo "Le réseau Docker '$network_name' existe déjà."
fi

echo "set env"
chmod u+x ./set_env.sh
./set_env.sh

# Chemin vers le fichier env.env
env_file="../env.env"

port=19006
env_value=""
# Vérifier si le fichier existe
if [ -f "$env_file" ]; then
    # Utiliser grep pour rechercher la ligne contenant la variable env
    env_line=$(grep '^env=' "$env_file")

    # Vérifier si la ligne a été trouvée
    if [ -n "$env_line" ]; then
        # Utiliser cut pour extraire la valeur de la variable env
        env_value=$(echo "$env_line" | cut -d'=' -f2)
        echo "La valeur de 'env' est : $env_value"
    else
        echo "La variable 'env' n'a pas été trouvée dans $env_file."
    fi
else
    echo "Le fichier $env_file n'existe pas."
fi


if [ "$env_value" = "blue" ]; then
    port=19007
fi

# Nom du conteneur Docker
nomConteneur="projet_rentree_front_$env_value"

# Vérifie si un conteneur avec le même nom existe déjà et le supprime le cas échéant
conteneurExistant=$(docker ps -a -q -f name=^/${nomConteneur}$)
if [ ! -z "$conteneurExistant" ]; then
    echo "Un conteneur avec le nom $nomConteneur existe déjà. Suppression du conteneur."
    docker rm -f $nomConteneur
fi

# Construit l'image Docker pour le projet Maven
docker build ../../. -t projet_rentree_front:"$env_value"
echo "Image Docker construite"

# Lance le conteneur Docker du projet Maven sur le réseau personnalisé, le build est lancé automatiquement
docker run --name $nomConteneur --network mon-reseau -p $port:19006 -d projet_rentree_front:"$env_value"
echo "Conteneur Docker lancé"

# Commande à exécuter dans le conteneur
commande="npm i"

# Exécute la commande dans le conteneur Docker
echo "Exécution de la commande dans le conteneur Docker : $nomConteneur"
docker exec $nomConteneur $commande
