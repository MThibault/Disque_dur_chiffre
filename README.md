Gestion de disque dur externe chiffré
==================

# Utilisation

Utilisant un Raspberry Pi comme serveur, je n'ai pas recourt à l'interface graphique.
J'ai donc cherché une solution pour avoir un montage semi-automatique de mes partitions chiffrées, suite à l'installation et la configuration d'un disque dur externe pour Owncloud/Nextcloud.

J'ai donc écrit deux scripts, un pour le montage et l'autre pour le démontage de disque dur chiffré avec option pour Owncloud/Nextcloud (minimisant la quantité d'information à créer).

J'utilise cryptsetup qu'il peut être nécessaire d'installer, avec LUKS.

## Montage d'une partition chiffré

Il y a deux méthodes, dont que je destine à Owncloud/Nextcloud (mais qui peut servir pour autre chose) et qui est plus automatique.

### Méthode Owncloud/Nextcloud

Il vous faut simplement envoyé en paramètre la partition à monter, sous la forme /dev/xxxx.
Vous réppondez "yes" à la question, et le script se chargera d'ouvrir le support chiffré, de créer le dossier servant de point de montage, de monter la partition et d'attribuer les droits (pour Owncloud/Nextcloud, donc www-data:www-data)

### Méthode basique pour toutes les utilisations

Il faut envoyer 3 paramètres dans l'ordre suivant :
* 1) La partition à monter sous la forme /dev/xxxx,
* 2) Le nom que vous voulez donner à votre partition pour l'identifier dans /dev/mapper/,
* 3) le point de montage de votre choix.

La script s'occupera de vous monter la partition chiffrée.
Par contre, il ne lui attribue pas de propriétaires particuliers, vous devrez donc le faire vous-mêmes. C'est une option à rajouter.

## Démontage d'une partition chiffrée

Comme pour le montage, il y a deux méthodes, une tout automatique qui marche si vous avez fait le montage automatique, et l'autre pour le montage basique.

### Méthode Owncloud/Nextcloud

Il vous faut répondre oui à la question et c'est tout. Pas de paramètres à envoyer au programme, c'est automatique.

### Méthode basique pour toutes les utilisations

Il y a deux paramètres à envoyer au script :
* 1) Le nom que vous avez donné à la partition chiffrée pour l'identifier. Vous pouvez le trouver dans /dev/mapper/,
* 2) Le point de montage que vous avez utilisé.

Le script se chargera ensuite de démonter le périphérique, de fermer la partition chiffrée, et de supprimer le point de montage.
