// Liste « Gen Z » — 109 lignes × 5 paires = 545 paires.
// Format : Mot1|Mot2;Mot1|Mot2;… (5 paires par ligne)

let gzRapFR = """
PNL|Ninho;Jul|SCH;Booba|Kaaris;Damso|Orelsan;Nekfeu|Lomepal
Gazo|Tiakola;Werenoi|Naps;Soolking|Maes;Niska|Koba LaD;Hamza|Josman
Vald|Freeze Corleone;Laylow|Lacrim;Rohff|Kery James;Médine|Youssoupha;Dinos|Alpha Wann
Heuss l'Enfoiré|Gradur;Leto|Sofiane;SDM|Zola;Dadju|Gims;Soprano|Black M
Aya Nakamura|Wejdene;Shay|Chilla;Diam's|Keny Arkana;Disiz|Oxmo Puccino;MC Solaar|IAM
Tayc|Franglish;Ziak|Soso Maness;Jazzy Bazz|Hugo TSR;Roméo Elvis|Caballero;Angèle|Pomme
Alonzo|Jok'air;Rim'K|Kalash Criminel;La Fouine|Sefyu;Mister You|Sadek;Lartiste|Naza
"""

let gzRapUS = """
Drake|Kendrick Lamar;Travis Scott|Playboi Carti;Kanye West|Jay-Z;Eminem|50 Cent;Snoop Dogg|Dr. Dre
Nicki Minaj|Cardi B;Lil Wayne|Future;Post Malone|Juice WRLD;21 Savage|Metro Boomin;Tyler, the Creator|Frank Ocean
J. Cole|Lil Baby;Roddy Ricch|Lil Uzi Vert;A$AP Rocky|Pharrell Williams;Megan Thee Stallion|Doja Cat;Tupac|Notorious B.I.G.
Central Cee|Dave;Stormzy|Skepta;Bad Bunny|J Balvin;Burna Boy|Wizkid;Rosalía|Shakira
Lil Nas X|Jack Harlow;Offset|Quavo;Migos|Gunna;Ice Spice|Latto;DaBaby|Moneybagg Yo
Mac Miller|Lil Tjay;Lil Peep|Lil Yachty;Kodak Black|NBA YoungBoy;Chief Keef|Lil Durk;Pop Smoke|Fivio Foreign
"""

let gzStreamers = """
Squeezie|Inoxtag;Michou|Kameto;Gotaga|ZeratoR;Domingo|Ultia;Locklear|Maghla
Pomf|Sardoche;Amixem|Joyca;Cyprien|Norman;Léna Situations|EnjoyPhoenix;Tibo InShape|Nasdas
Hugo Décrypte|Mister V;Doigby|Mynthos;Jiraya|Fuze III;Anyme023|Alphacast;Chowh1|Lutti
Ponce|Rivenzi;Skyyart|Terracid;Studio Bagel|Golden Moustache;Natoo|Kemar;Dr Nozman|E-penser
MrBeast|PewDiePie;Ninja|Shroud;Pokimane|Valkyrae;xQc|Ludwig;Kai Cenat|IShowSpeed
Markiplier|Jacksepticeye;Dream|GeorgeNotFound;Sykkuno|Mizkif;Logan Paul|Jake Paul;KSI|Miniminter
Chaîne|Playlist;Kick|Rumble;Streamer|YouTubeur;Abonné|Follower;Donation|Sub
Karmine Corp|Team Vitality;Zevent|ZLAN;Vlog|Let's play;Tutoriel|Unboxing;Live|Replay
"""

let gzApps = """
TikTok|Instagram Reels;Snapchat|Instagram;BeReal|Locket;Twitter|Threads;Discord|Telegram
WhatsApp|Signal;Facebook|LinkedIn;Pinterest|Tumblr;Reddit|9GAG;Vinted|Leboncoin
Tinder|Bumble;Hinge|Meetic;Uber|Bolt;BlaBlaCar|Getaround;Airbnb|Booking
Prime Video|Apple TV+;OCS|Canal+;Crunchyroll|ADN;Apple Music|YouTube Music;SoundCloud|Bandcamp
ChatGPT|Gemini;Siri|Alexa;Google Maps|Waze;Shazam|Genius;Canva|Photoshop
Story|Reel;Like|Commentaire;Hashtag|Tendance;DM|Mention;Filtre|Sticker
Shein|Temu;Zalando|ASOS;Amazon|AliExpress;Depop|Vestiaire Collective;Too Good To Go|Phenix
Selfie|Photo de groupe;Emoji|GIF;Vocal|Appel vidéo;Notification|Alerte;Mode avion|Mode silencieux
"""

let gzJeux = """
Fortnite|Warzone;Minecraft|Roblox;GTA|Red Dead Redemption;FIFA|eFootball;Call of Duty|Battlefield
League of Legends|Dota 2;Valorant|Counter-Strike;Overwatch|Apex Legends;Rocket League|Fall Guys;Among Us|Goose Goose Duck
Mario|Sonic;Zelda|Pokémon;Pikachu|Evoli;Luigi|Wario;Yoshi|Kirby
PlayStation|Xbox;Switch|Steam Deck;PS5|PS4;Manette|Joystick;Casque VR|Écran gaming
Clash Royale|Clash of Clans;Brawl Stars|Subway Surfers;Candy Crush|Angry Birds;Flappy Bird|Temple Run;Pokémon GO|Ingress
Animal Crossing|Les Sims;Stardew Valley|Terraria;Hollow Knight|Celeste;Hades|Dead Cells;Undertale|Omori
The Witcher|Skyrim;Elden Ring|Dark Souls;God of War|Assassin's Creed;Cyberpunk 2077|Fallout;Mass Effect|Baldur's Gate
Resident Evil|Silent Hill;Five Nights at Freddy's|Poppy Playtime;Outlast|Amnesia;Dead by Daylight|Phasmophobia;Left 4 Dead|The Last of Us
Mario Kart|Smash Bros;Just Dance|Guitar Hero;Wii Sports|Ring Fit;Tetris|Pac-Man;Space Invaders|Pong
Speedrun|Walkthrough;Boss|Mini-boss;Noob|Smurf;Skin|Emote;Battle royale|MOBA
"""

let gzSeries = """
Stranger Things|Wednesday;Squid Game|Alice in Borderland;Money Heist|Lupin;Peaky Blinders|Boardwalk Empire;Euphoria|Elite
Riverdale|Gossip Girl;Bridgerton|The Crown;Emily in Paris|Sex Education;Outer Banks|Never Have I Ever;13 Reasons Why|Skins
House of the Dragon|Les Anneaux de pouvoir;The Mandalorian|Andor;The Boys|Invincible;Arcane|Cyberpunk Edgerunners;Black Mirror|Love Death & Robots
Marvel|DC;Avengers|Justice League;Thor|Hulk;Deadpool|Wolverine;Joker|Harley Quinn
Barbie|Oppenheimer;Dune|Interstellar;Fast & Furious|Taxi;Intouchables|Bienvenue chez les Ch'tis;Kaamelott|Les Tuche
Disney|Pixar;Vaiana|La Reine des neiges;Encanto|Coco;Zootopie|Les Mondes de Ralph;Nemo|Le Monde de Dory
The Office|Parks and Recreation;Brooklyn Nine-Nine|Modern Family;The Big Bang Theory|Young Sheldon;Malcolm|Les Frères Scott;Scrubs|Dr House
Koh-Lanta|Survivor;The Voice|Star Academy;Love Island|Les Anges;Top Chef|Le Meilleur Pâtissier;Les Marseillais|Les Ch'tis
"""

let gzAnimes = """
Naruto|Bleach;One Piece|Dragon Ball;Death Note|Code Geass;Attack on Titan|Demon Slayer;My Hero Academia|One Punch Man
Jujutsu Kaisen|Chainsaw Man;Hunter x Hunter|Fullmetal Alchemist;Tokyo Revengers|Haikyuu;Sword Art Online|Re:Zero;Spy x Family|Kaguya-sama
Goku|Vegeta;Luffy|Zoro;Naruto Uzumaki|Sasuke;Eren|Levi;Tanjiro|Zenitsu
Gojo|Sukuna;Itachi|Madara;Light Yagami|L;Saitama|Genos;Deku|Bakugo
Pokémon|Digimon;Yu-Gi-Oh!|Beyblade;Totoro|Ponyo;Chihiro|Princesse Mononoké;Kiki la petite sorcière|Le Château ambulant
Manga|Webtoon;Shonen|Seinen;Otaku|Weeb;Cosplay|Fanart;Opening|Ending
Dragon Ball Z|Dragon Ball Super;Naruto Shippuden|Boruto;One Piece Film Red|Stampede;Sailor Moon|Card Captor Sakura;Albator|Goldorak
Évangelion|Gundam;Akira|Ghost in the Shell;Cowboy Bebop|Trigun;Fruits Basket|Toradora;Your Name|A Silent Voice
"""

let gzMusique = """
Taylor Swift|Olivia Rodrigo;Billie Eilish|Lorde;Ariana Grande|Selena Gomez;Dua Lipa|Rihanna;Beyoncé|Jennifer Lopez
The Weeknd|Bruno Mars;Ed Sheeran|Shawn Mendes;Harry Styles|Justin Bieber;Sabrina Carpenter|Chappell Roan;Lady Gaga|Madonna
Louane|Zaz;Indochine|Téléphone;Jain|Christine and the Queens;Vianney|Calogero;Kendji Girac|Slimane
BTS|Blackpink;Stray Kids|Twice;Psy|Jungkook;K-pop|J-pop;Ado|YOASOBI
David Guetta|Martin Garrix;Daft Punk|Justice;Calvin Harris|Avicii;Tiësto|Alan Walker;Cassius|Air
Coachella|Tomorrowland;Rock en Seine|Solidays;Vieilles Charrues|Hellfest;Eurockéennes|We Love Green;Concert|Showcase
Playlist|Album;Single|EP;Clip|Lyric video;Remix|Cover;Auto-Tune|Vocoder
"""

let gzStyle = """
Nike|Adidas;Puma|Reebok;New Balance|Asics;Converse|Vans;Jordan|Air Max
Supreme|Off-White;Gucci|Louis Vuitton;Prada|Balenciaga;Dior|Chanel;Lacoste|Ralph Lauren
Zara|H&M;Uniqlo|Bershka;Primark|Kiabi;Celio|Jules;Pull&Bear|Stradivarius
Stüssy|Carhartt;The North Face|Patagonia;Moncler|Canada Goose;Kenzo|Jacquemus;Casablanca|Ami
Air Force 1|Dunk;Yeezy|Jordan 1;Stan Smith|Superstar;Campus|Gazelle;Tn|Air Max 97
Jogging|Cargo;Baggy|Slim;Crop top|Brassière;Doudoune|Parka;Bob|Visière
Tatouage|Henné;Dégradé|Brosse;Gloss|Rouge à lèvres;Vernis|Faux ongles;Parfum|Déodorant
"""

let gzFood = """
McDo|Burger King;KFC|Popeyes;Quick|Five Guys;Subway|Starbucks;Domino's|Pizza Hut
Big Mac|Whopper;Chicken McNuggets|Chicken Wings;McFlurry|Frappé;Sauce algérienne|Sauce samouraï;Frites cheddar|Potatoes
Bubble tea|Matcha latte;Boba|Mochi;Açaï bowl|Poke bowl;Avocado toast|Granola;Smoothie bowl|Overnight oats
Oasis|Capri-Sun;Fanta|Sprite;Orangina|Schweppes;Lipton|Nestea;Fuze Tea|Arizona
Kinder Bueno|Kinder Délice;Oreo|Prince;Haribo|Carambar;Sour Patch|Fraises Tagada;Pringles|Doritos
Pop-corn|Biscuits apéro;M&M's|Smarties;Snickers|Mars;Twix|Kit Kat;Milka|Toblerone
Ramen instantané|Cup Noodles;Kimchi|Bibimbap;Corn dog|Tteokbokki;Gimbap|California roll;Dalgona|Tanghulu
Café glacé|Frappuccino;Pumpkin Spice Latte|Chai latte;Cookie dough|Brookie;Churros|Gaufre de Liège;Cheesecake|Tarte au citron
"""

let gzSport = """
Vinicius|Rodrygo;Benzema|Griezmann;Dembélé|Kolo Muani;Pogba|Kanté;Giroud|Lacazette
Lamine Yamal|Pedri;Bellingham|Foden;Salah|Mané;De Bruyne|Kane;Kvaratskhelia|Osimhen
PSG|OM;Real Madrid|Barça;Manchester City|Liverpool;Chelsea|Arsenal;Juventus|Milan AC
Ligue 1|Premier League;Liga|Serie A;Bundesliga|Ligue 2;Ligue des champions|Ligue Europa;Coupe du monde|Euro
LeBron James|Stephen Curry;Michael Jordan|Kobe Bryant;Wembanyama|Giannis;NBA|WNBA;Lakers|Celtics
Djokovic|Nadal;Federer|Alcaraz;Serena Williams|Naomi Osaka;Roland-Garros|Wimbledon;Tony Parker|Rudy Gobert
Léon Marchand|Florent Manaudou;Lewis Hamilton|Max Verstappen;Formule 1|MotoGP;Ferrari|Lamborghini;Jeux olympiques|Jeux paralympiques
"""

let gzVie = """
Tiktokeur|Influenceur;Boomer|Millennial;Gen Z|Alpha;Rizz|Swag;Cringe|Malaise
Vibes|Mood;Ghosting|Rupture;Crush|Date;Situationship|Couple;Red flag|Green flag
Fake news|Rumeur;Spoil|Teaser;Buzz|Bad buzz;Hype|Trend;Viral|Tendance
Soirée|Boîte de nuit;After|Afterwork;Rooftop|Terrasse;Pote|Collègue;Colocation|Résidence étudiante
Fac|Prépa;Partiel|Oral;Amphi|Salle de TD;Resto U|Cafétéria;Erasmus|Année de césure
Trottinette électrique|Vélo en libre-service;Navigo|Pass Imagine R;Carte jeune|Pass Culture;Auchan|Carrefour;Lidl|Aldi
Basic-Fit|Fitness Park;Protéine|Créatine;Pompes|Tractions;Abdos|Gainage;Run|Footing
Job étudiant|Petit boulot;Auto-entrepreneur|Freelance;Dropshipping|Trading;Crypto|Bitcoin;NFT|Metaverse
"""

let gzTech = """
AirPods|Galaxy Buds;MacBook|iPad;PlayStation VR|Meta Quest;GoPro|Insta360;Apple Watch|Fitbit
Tesla|Renault Zoé;Trottinette Xiaomi|Hoverboard;Powerbank|Chargeur sans fil;Ring light|Trépied;Micro-cravate|Micro-casque
iOS|Android;Windows|macOS;Linux|Chrome OS;Pixel|Xiaomi;Huawei|Oppo
Discord vocal|TeamSpeak;OBS|Streamlabs;Elgato|Capture card;Overlay|Alerte stream;Webcam|Caméscope
Intelligence artificielle|Robot;Deepfake|Filtre;Lightroom|Snapseed;Midjourney|DALL-E;Prompt|Algorithme
"""

let gzMemes = """
Meme|Gif;Troll|Hater;Clash|Punchline;Challenge|Prank;ASMR|Mukbang
Pepe|Doge;Rickroll|Gangnam Style;Nyan Cat|Grumpy Cat;Harlem Shake|Ice Bucket Challenge;Baby Shark|Macarena
Skibidi Toilet|Sigma;Aura|Ohio;Mewing|Looksmaxxing;Griddy|Floss;Renegade|Savage
Mdr|Ptdr;Lol|Lmao;Jpp|Osef;Wallah|Sah;Bg|Goat
😭|💀;🔥|💯;🤡|😈;👍|👌;👻|👽
Slime|Squishy;Fidget spinner|Pop it;Tamagotchi|Furby;Rubik's Cube|Taquin;Yo-yo|Toupie
"""

let gzLifestyle = """
Festival|Rave;Glamping|Van life;Road trip|Interrail;Auberge de jeunesse|Hôtel capsule;Gourde|Thermos
Bali|Thaïlande;Dubaï|Miami;Ibiza|Mykonos;Los Angeles|Las Vegas;Disneyland Paris|Parc Astérix
Skate|Roller;BMX|Trottinette freestyle;Parkour|Street workout;Paintball|Laser game;Escape game|Accrobranche
Barbecue|Plancha;Apéro|Brunch;Raclette party|Soirée crêpes;Soirée jeux|Soirée ciné;Pique-nique|Goûter
Binge-watching|Marathon de films;Cinéma|Streaming;Série|Film;Podcast|Audiolivre;Livre|Liseuse
Skincare|Make-up;Astrologie|Numérologie;Méditation|Sophrologie;Journaling|Bullet journal;Végan|Végétarien
"""
