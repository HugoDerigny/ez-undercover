// Liste « Grand public » — 117 lignes × 5 paires = 585 paires.
// Format : Mot1|Mot2;Mot1|Mot2;… (5 paires par ligne)

let gpAnimaux = """
Chat|Chien;Lion|Tigre;Loup|Renard;Cheval|Âne;Vache|Taureau
Lapin|Lièvre;Souris|Rat;Poule|Canard;Coq|Paon;Mouton|Chèvre
Dauphin|Requin;Baleine|Orque;Phoque|Otarie;Crabe|Homard;Pieuvre|Calamar
Crocodile|Alligator;Serpent|Lézard;Tortue|Escargot;Grenouille|Crapaud;Caméléon|Iguane
Aigle|Faucon;Hibou|Chouette;Pigeon|Colombe;Corbeau|Pie;Cygne|Oie
Abeille|Guêpe;Papillon|Libellule;Fourmi|Termite;Moustique|Mouche;Araignée|Scorpion
Singe|Gorille;Éléphant|Rhinocéros;Girafe|Zèbre;Chameau|Dromadaire;Panda|Koala
Ours|Panthère;Léopard|Guépard;Hérisson|Porc-épic;Écureuil|Hamster;Cochon|Sanglier
Pingouin|Manchot;Flamant rose|Pélican;Perroquet|Toucan;Moineau|Rouge-gorge;Kangourou|Wallaby
"""

let gpPlats = """
Pizza|Tarte flambée;Hamburger|Sandwich;Pâtes|Riz;Raviolis|Gnocchis;Lasagnes|Cannelloni
Crêpe|Gaufre;Omelette|Quiche;Croissant|Pain au chocolat;Baguette|Pain de mie;Brioche|Pain perdu
Soupe|Velouté;Salade|Taboulé;Fondue|Raclette;Couscous|Paëlla;Sushi|Maki
Kebab|Tacos;Burrito|Fajitas;Nems|Samoussas;Ramen|Pho;Curry|Tajine
Steak|Escalope;Poulet rôti|Dinde;Jambon|Saucisson;Saucisse|Merguez;Bacon|Lardons
Hot-dog|Croque-monsieur;Frites|Chips;Purée|Gratin dauphinois;Ketchup|Mayonnaise;Moutarde|Cornichon
Fromage|Beurre;Camembert|Brie;Gruyère|Emmental;Yaourt|Fromage blanc;Crème|Lait
Œuf au plat|Œuf poché;Jambon-beurre|Club sandwich;Risotto|Polenta;Poisson pané|Nuggets;Saumon|Thon
Huître|Moule;Crevette|Langoustine;Foie gras|Pâté;Cassoulet|Choucroute;Truite|Sardine
Bouillabaisse|Pot-au-feu;Ratatouille|Poêlée de légumes;Blanquette|Bourguignon;Tartiflette|Hachis Parmentier;Quenelle|Boudin
"""

let gpGourmandises = """
Pomme|Poire;Orange|Mandarine;Citron|Pamplemousse;Fraise|Framboise;Cerise|Prune
Banane|Mangue;Ananas|Papaye;Raisin|Groseille;Pêche|Abricot;Melon|Pastèque
Noix|Noisette;Amande|Cacahuète;Pistache|Noix de cajou;Châtaigne|Marron;Datte|Figue
Carotte|Navet;Tomate|Poivron;Concombre|Courgette;Aubergine|Courge;Brocoli|Chou-fleur
Pomme de terre|Patate douce;Oignon|Échalote;Ail|Gingembre;Laitue|Épinards;Haricot vert|Petit pois
Champignon|Truffe;Maïs|Blé;Radis|Betterave;Poireau|Céleri;Artichaut|Asperge
Gâteau|Tarte;Mille-feuille|Éclair;Macaron|Meringue;Cookie|Brownie;Muffin|Cupcake
Glace|Sorbet;Chocolat|Caramel;Nutella|Confiture;Miel|Sirop d'érable;Bonbon|Sucette
Flan|Crème brûlée;Mousse au chocolat|Tiramisu;Profiterole|Chou à la crème;Donut|Beignet;Chantilly|Crème anglaise
"""

let gpBoissons = """
Café|Thé;Cappuccino|Latte;Chocolat chaud|Infusion;Jus d'orange|Jus de pomme;Eau plate|Eau gazeuse
Coca|Pepsi;Limonade|Soda;Sirop|Grenadine;Smoothie|Milkshake;Thé glacé|Citronnade
Vin|Champagne;Bière|Cidre;Whisky|Vodka;Rhum|Tequila;Mojito|Caïpirinha
Pastis|Anisette;Cognac|Armagnac;Spritz|Sangria;Bière blonde|Bière brune;Vin rouge|Vin blanc
Expresso|Café allongé;Lait de vache|Lait d'amande;Tisane|Maté;Kombucha|Kéfir;Red Bull|Monster
"""

let gpMaison = """
Canapé|Fauteuil;Table|Bureau;Chaise|Tabouret;Lit|Hamac;Armoire|Commode
Lampe|Lustre;Bougie|Veilleuse;Miroir|Tableau;Rideau|Store;Tapis|Moquette
Frigo|Congélateur;Four|Micro-ondes;Grille-pain|Cafetière;Mixeur|Blender;Bouilloire|Casserole
Assiette|Bol;Fourchette|Cuillère;Couteau|Ciseaux;Verre|Tasse;Bouteille|Carafe
Poêle|Wok;Cocotte|Marmite;Passoire|Écumoire;Rouleau à pâtisserie|Spatule;Fouet|Louche
Lave-linge|Lave-vaisselle;Aspirateur|Balai;Fer à repasser|Sèche-linge;Éponge|Serpillière;Savon|Gel douche
Brosse à dents|Brosse à cheveux;Dentifrice|Bain de bouche;Shampoing|Après-shampoing;Serviette|Peignoir;Baignoire|Douche
Porte|Fenêtre;Escalier|Ascenseur;Balcon|Terrasse;Garage|Cave;Grenier|Sous-sol
Oreiller|Coussin;Couette|Plaid;Drap|Housse;Pyjama|Chemise de nuit;Réveil|Montre
Marteau|Tournevis;Perceuse|Visseuse;Clou|Vis;Échelle|Escabeau;Pinceau|Rouleau de peinture
"""

let gpMode = """
Pantalon|Jean;Short|Bermuda;Jupe|Robe;Pull|Gilet;Veste|Manteau
T-shirt|Chemise;Polo|Débardeur;Sweat|Hoodie;Cravate|Nœud papillon;Costume|Smoking
Chaussettes|Collants;Baskets|Mocassins;Bottes|Bottines;Sandales|Tongs;Escarpins|Ballerines
Casquette|Bonnet;Chapeau|Béret;Écharpe|Foulard;Gants|Moufles;Ceinture|Bretelles
Lunettes|Lentilles;Bracelet|Gourmette;Collier|Pendentif;Bague|Alliance;Boucles d'oreilles|Piercing
Sac à dos|Sac à main;Valise|Cartable;Portefeuille|Porte-monnaie;Parapluie|Imperméable;Maillot de bain|Bikini
"""

let gpTransports = """
Voiture|Camion;Moto|Scooter;Vélo|Trottinette;Bus|Tramway;Métro|RER
Train|TGV;Avion|Hélicoptère;Bateau|Paquebot;Voilier|Péniche;Ferry|Sous-marin
Taxi|VTC;Ambulance|Camion de pompiers;Tracteur|Bulldozer;Fusée|Satellite;Montgolfière|Parachute
Gare|Aéroport;Péage|Parking;Autoroute|Nationale;Rond-point|Carrefour;Feu rouge|Passage piéton
Ceinture de sécurité|Airbag;Permis|Code de la route;Essence|Diesel;Pneu|Roue;Volant|Guidon
"""

let gpMetiers = """
Médecin|Infirmier;Dentiste|Pharmacien;Vétérinaire|Éleveur;Chirurgien|Kiné;Psychologue|Coach
Professeur|Instituteur;Avocat|Juge;Policier|Gendarme;Pompier|Ambulancier;Militaire|Garde du corps
Boulanger|Pâtissier;Cuisinier|Serveur;Boucher|Poissonnier;Fleuriste|Jardinier;Coiffeur|Barbier
Plombier|Électricien;Maçon|Charpentier;Peintre|Décorateur;Architecte|Ingénieur;Mécanicien|Garagiste
Facteur|Livreur;Pilote|Hôtesse de l'air;Chauffeur|Conducteur de bus;Marin|Pêcheur;Agriculteur|Vigneron
Journaliste|Présentateur;Écrivain|Poète;Acteur|Humoriste;Chanteur|Danseur;Photographe|Cameraman
Banquier|Comptable;Notaire|Huissier;Secrétaire|Assistant;Commercial|Vendeur;Caissier|Magasinier
Astronaute|Aviateur;Détective|Espion;Magicien|Illusionniste;Clown|Mime;Cowboy|Bûcheron
"""

let gpSports = """
Football|Rugby;Basket|Handball;Volley|Badminton;Tennis|Ping-pong;Golf|Pétanque
Natation|Plongée;Surf|Planche à voile;Voile|Kayak;Ski|Snowboard;Patinage|Hockey
Boxe|Judo;Karaté|Taekwondo;Escrime|Tir à l'arc;Lutte|Catch;Musculation|Crossfit
Course à pied|Marathon;Sprint|Relais;Saut en longueur|Saut à la perche;Lancer de javelot|Lancer de poids;Cyclisme|VTT
Yoga|Pilates;Danse|Gymnastique;Équitation|Polo;Escalade|Randonnée;Camping|Caravaning
Échecs|Dames;Monopoly|Cluedo;Poker|Belote;Tarot|Bridge;Puzzle|Mots croisés
Pêche à la ligne|Chasse;Jardinage|Bricolage;Tricot|Couture;Peinture|Dessin;Cuisine|Pâtisserie
Cartes|Dés;Loto|Tombola;Bowling|Billard;Fléchettes|Baby-foot;Karaoké|Blind test
"""

let gpNature = """
Mer|Océan;Lac|Étang;Rivière|Fleuve;Ruisseau|Cascade;Plage|Falaise
Montagne|Colline;Volcan|Geyser;Désert|Savane;Forêt|Jungle;Prairie|Champ
Soleil|Lune;Étoile|Planète;Nuage|Brouillard;Pluie|Neige;Orage|Tempête
Arc-en-ciel|Aurore boréale;Vent|Tornade;Tremblement de terre|Tsunami;Glacier|Iceberg;Île|Presqu'île
Rose|Tulipe;Marguerite|Pâquerette;Tournesol|Lavande;Chêne|Sapin;Palmier|Bambou
Herbe|Mousse;Feuille|Branche;Racine|Tronc;Fougère|Ronce;Cactus|Aloe vera
Grotte|Canyon;Marais|Mangrove;Oasis|Dune;Récif corallien|Atoll;Phare|Port
Printemps|Automne;Été|Hiver;Matin|Soir;Lundi|Dimanche;Janvier|Décembre
"""

let gpCorps = """
Main|Pied;Bras|Jambe;Genou|Coude;Doigt|Orteil;Épaule|Hanche
Œil|Oreille;Nez|Bouche;Dent|Langue;Cheveux|Poils;Barbe|Moustache
Cœur|Poumon;Cerveau|Estomac;Foie|Rein;Os|Muscle;Peau|Cicatrice
Rhume|Grippe;Fièvre|Toux;Migraine|Vertige;Pansement|Bandage;Médicament|Vitamines
"""

let gpArts = """
Guitare|Basse;Piano|Orgue;Violon|Violoncelle;Flûte|Clarinette;Trompette|Trombone
Batterie|Tambour;Harpe|Mandoline;Saxophone|Harmonica;Accordéon|Cornemuse;Micro|Enceinte
Opéra|Comédie musicale;Concert|Festival;Rock|Métal;Jazz|Blues;Rap|Slam
Aquarelle|Fusain;Sculpture|Poterie;Musée|Galerie;Théâtre|Cirque;Cinéma|Drive-in
Bibliothèque|Librairie;Roman|Nouvelle;Bande dessinée|Manga;Poème|Chanson;Dictionnaire|Encyclopédie
Photo|Selfie;Film|Documentaire;Dessin animé|Marionnette;Magie|Hypnose;Danse classique|Hip-hop
"""

let gpFetes = """
Noël|Nouvel An;Pâques|Halloween;Anniversaire|Mariage;Baptême|Communion;Saint-Valentin|Fête des mères
Sapin de Noël|Crèche;Cadeau|Carte de vœux;Guirlande|Boule de Noël;Bûche|Galette des rois;Poisson d'avril|Chasse aux œufs
Feux d'artifice|Pétards;Défilé|Carnaval;Déguisement|Masque;Ballon|Confetti;Gâteau d'anniversaire|Bougies
Vacances|Week-end;Hôtel|Auberge;Gîte|Chalet;Croisière|Safari;Passeport|Visa
Pacs|Concubinage;Divorce|Séparation;Bébé|Enfant;Grand-mère|Tante;Cousin|Neveu
"""

let gpGeo = """
France|Belgique;Espagne|Portugal;Italie|Grèce;Allemagne|Autriche;Suisse|Luxembourg
Angleterre|Écosse;Irlande|Islande;Suède|Norvège;Danemark|Finlande;Pologne|Russie
Maroc|Tunisie;Algérie|Égypte;Sénégal|Côte d'Ivoire;Brésil|Argentine;Mexique|Cuba
Japon|Chine;Corée|Thaïlande;Inde|Pakistan;Australie|Nouvelle-Zélande;Canada|États-Unis
Paris|Lyon;Marseille|Nice;Bordeaux|Toulouse;Lille|Strasbourg;Nantes|Rennes
Londres|New York;Rome|Venise;Madrid|Barcelone;Berlin|Amsterdam;Tokyo|Pékin
Tour Eiffel|Arc de Triomphe;Louvre|Orsay;Notre-Dame|Sacré-Cœur;Mont-Saint-Michel|Château de Versailles;Colisée|Panthéon
"""

let gpCulture = """
Batman|Superman;Spider-Man|Iron Man;Harry Potter|Seigneur des anneaux;Star Wars|Star Trek;Astérix|Tintin
Mickey|Donald;Cendrillon|Blanche-Neige;Shrek|Madagascar;Le Roi lion|Bambi;Toy Story|Cars
James Bond|Mission impossible;Titanic|Avatar;Gladiator|Braveheart;Matrix|Inception;Jurassic Park|King Kong
Napoléon|Louis XIV;Jeanne d'Arc|Marie-Antoinette;De Gaulle|Mitterrand;Einstein|Newton;Mozart|Beethoven
Picasso|Van Gogh;Monet|Renoir;Molière|Victor Hugo;Zidane|Mbappé;Messi|Ronaldo
Père Noël|Saint Nicolas;Dracula|Frankenstein;Sherlock Holmes|Hercule Poirot;Robin des Bois|Zorro;Pirate|Corsaire
Netflix|Disney+;Friends|How I Met Your Mother;Game of Thrones|Vikings;Breaking Bad|Narcos;Les Simpson|Family Guy
"""

let gpTech = """
Ordinateur|Tablette;Clavier|Souris;Écran|Télévision;Imprimante|Scanner;Casque|Écouteurs
iPhone|Samsung;Facebook|Instagram;WhatsApp|Messenger;YouTube|Twitch;Google|Bing
Email|SMS;Wi-Fi|Bluetooth;Clé USB|Disque dur;Batterie|Chargeur;Radio|Podcast
Appareil photo|Caméra;Drone|Robot;GPS|Boussole;Télécommande|Manette;Console|PC
Amazon|Cdiscount;Uber Eats|Deliveroo;Spotify|Deezer;Wikipédia|Google Maps;PayPal|Carte bancaire
Calculatrice|Agenda;Tampon|Cachet;Fax|Minitel;Cassette|CD;Vinyle|Walkman
"""

let gpEcole = """
École|Collège;Lycée|Université;Cantine|Récréation;Cahier|Classeur;Stylo|Crayon
Gomme|Correcteur;Règle|Équerre;Trousse|Plumier;Tableau noir|Ardoise;Craie|Feutre
Maths|Physique;Français|Histoire;Géographie|SVT;Anglais|Espagnol;Philosophie|Sociologie
Examen|Concours;Bac|Brevet;Diplôme|Certificat;Stage|Alternance;CV|Lettre de motivation
"""
