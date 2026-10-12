-- ============================================================================
-- SEED 001: Platform Template Catalog & Top 100 Foundational French Words (A1)
-- ============================================================================

WITH new_template_catalog AS (
    INSERT INTO catalogs (user_id, title, description, is_template)
    VALUES (
        NULL, -- NULL user_id marks this as a platform-wide system template
        'Vocabulaire Français A1 - Les 100 Mots Essentiels',
        'Top 100 foundational French words covering greetings, essential verbs, everyday objects, and basic descriptors.',
        TRUE
    )
    RETURNING id
)
INSERT INTO words (catalog_id, term, definition, part_of_speech, example_sentence)
SELECT new_template_catalog.id, w.term, w.definition, w.part_of_speech, w.example_sentence
FROM new_template_catalog
CROSS JOIN (
    VALUES
    -- Greetings & Courtesies
    ('bonjour', 'hello / good morning', 'noun', 'Bonjour, comment allez-vous ?'),
    ('bonsoir', 'good evening', 'noun', 'Bonsoir tout le monde, bienvenue.'),
    ('salut', 'hi / bye (informal)', 'noun', 'Salut Paul, à plus tard !'),
    ('merci', 'thank you', 'noun', 'Merci beaucoup pour votre aide.'),
    ('s''il vous plaît', 'please (formal/plural)', 'phrase', 'Un café, s''il vous plaît.'),
    ('pardon', 'sorry / excuse me', 'noun', 'Pardon, où est la gare ?'),
    ('oui', 'yes', 'adverb', 'Oui, je comprends parfaitement.'),
    ('non', 'no', 'adverb', 'Non, ce n''est pas nécessaire.'),
    ('d''accord', 'okay / agreed', 'phrase', 'D''accord, on se retrouve à midi.'),

    -- Core Auxiliary & High-Frequency Verbs
    ('être', 'to be', 'verb', 'Je suis étudiant à l''université.'),
    ('avoir', 'to have', 'verb', 'Nous avons une question pour le professeur.'),
    ('faire', 'to do / to make', 'verb', 'Il fait ses devoirs chaque soir.'),
    ('aller', 'to go', 'verb', 'Je vais au travail à vélo.'),
    ('pouvoir', 'to be able to / can', 'verb', 'Pouvez-vous répéter, s''il vous plaît ?'),
    ('vouloir', 'to want', 'verb', 'Elle veut apprendre le français rapidement.'),
    ('devoir', 'to have to / must', 'verb', 'Je dois partir maintenant.'),
    ('savoir', 'to know (a fact or skill)', 'verb', 'Savez-vous où se trouve la bibliothèque ?'),
    ('connaître', 'to know / be familiar with', 'verb', 'Je connais très bien cette ville.'),
    ('venir', 'to come', 'verb', 'Ils viennent de Montréal.'),
    ('voir', 'to see', 'verb', 'Je vois un beau parc là-bas.'),
    ('prendre', 'to take', 'verb', 'Nous prenons le métro tous les matins.'),
    ('parler', 'to speak', 'verb', 'Il parle couramment anglais et espagnol.'),
    ('aimer', 'to like / to love', 'verb', 'J''aime voyager en Europe.'),
    ('manger', 'to eat', 'verb', 'Nous mangeons ensemble à midi.'),
    ('boire', 'to drink', 'verb', 'Je bois de l''eau après le sport.'),
    ('comprendre', 'to understand', 'verb', 'Je comprends la règle maintenant.'),
    ('habiter', 'to live / reside', 'verb', 'J''habite à Montréal depuis un an.'),
    ('travailler', 'to work', 'verb', 'Elle travaille dans une entreprise technologique.'),
    ('chercher', 'to look for / search', 'verb', 'Je cherche mes clés de maison.'),
    ('trouver', 'to find', 'verb', 'Avez-vous trouvé une solution ?'),
    ('donner', 'to give', 'verb', 'Donnez-moi votre avis sur ce projet.'),
    ('partir', 'to leave', 'verb', 'Le train part à dix heures pile.'),
    ('arriver', 'to arrive', 'verb', 'Nous arrivons à l''aéroport à l''heure.'),
    ('attendre', 'to wait', 'verb', 'J''attends mon collègue devant le bureau.'),
    ('lire', 'to read', 'verb', 'Il lit un article sur l''intelligence artificielle.'),
    ('écrire', 'to write', 'verb', 'Elle écrit un courriel important.'),
    ('écouter', 'to listen', 'verb', 'J''écoute attentivement les explications.'),
    ('regarder', 'to watch / look at', 'verb', 'Nous regardons le match ce soir.'),
    ('acheter', 'to buy', 'verb', 'Je vais acheter des fruits au marché.'),
    ('dormir', 'to sleep', 'verb', 'Il est important de bien dormir la nuit.'),

    -- Time & Dates
    ('temps', 'time / weather', 'noun', 'Quel beau temps aujourd''hui !'),
    ('jour', 'day', 'noun', 'Passez une excellente journée.'),
    ('matin', 'morning', 'noun', 'Le matin, je prends un café noir.'),
    ('soir', 'evening', 'noun', 'Le soir, je préfère me reposer.'),
    ('nuit', 'night', 'noun', 'Bonne nuit et à demain matin.'),
    ('heure', 'hour / time', 'noun', 'Quelle heure est-il, s''il vous plaît ?'),
    ('semaine', 'week', 'noun', 'Nous avons une réunion la semaine prochaine.'),
    ('mois', 'month', 'noun', 'Ce mois-ci, nous lançons le nouveau produit.'),
    ('année', 'year', 'noun', 'Cette année sera très productive.'),
    ('aujourd''hui', 'today', 'adverb', 'Aujourd''hui, nous commençons le sprint.'),
    ('demain', 'tomorrow', 'adverb', 'À demain pour la démonstration.'),
    ('hier', 'yesterday', 'adverb', 'Hier, nous avons déployé la mise à jour.'),

    -- People & Society
    ('personne', 'person / nobody', 'noun', 'Cette personne est très compétente.'),
    ('homme', 'man', 'noun', 'L''homme lit un journal dans le parc.'),
    ('femme', 'woman / wife', 'noun', 'La femme dirige cette initiative stratégique.'),
    ('enfant', 'child', 'noun', 'Les enfants jouent dans la cour de récréation.'),
    ('ami', 'friend', 'noun', 'Mon ami m''a recommandé ce cours.'),
    ('famille', 'family', 'noun', 'Ma famille vit à l''étranger.'),
    ('collègue', 'colleague', 'noun', 'Mon collègue a validé la spécification.'),

    -- Places, Infrastructure & Travel
    ('maison', 'house / home', 'noun', 'Bienvenue dans ma nouvelle maison.'),
    ('ville', 'city', 'noun', 'Montréal est une ville cosmopolite et dynamique.'),
    ('pays', 'country', 'noun', 'Le Canada est un pays magnifique.'),
    ('rue', 'street', 'noun', 'Le bureau est situé dans cette rue.'),
    ('bureau', 'office / desk', 'noun', 'Je travaille au bureau deux jours par semaine.'),
    ('école', 'school', 'noun', 'L''école ouvre ses portes à huit heures.'),
    ('gare', 'train station', 'noun', 'Rendez-vous à la gare centrale.'),
    ('voiture', 'car', 'noun', 'Il a garé sa voiture devant le bâtiment.'),
    ('train', 'train', 'noun', 'Le train est rapide et confortable.'),
    ('café', 'coffee / café', 'noun', 'Prenons un café pour en discuter.'),
    ('restaurant', 'restaurant', 'noun', 'Ce restaurant sert une excellente cuisine.'),
    ('porte', 'door', 'noun', 'Fermez la porte derrière vous, s''il vous plaît.'),
    ('table', 'table', 'noun', 'Les documents sont posés sur la table.'),
    ('chambre', 'room / bedroom', 'noun', 'La chambre est lumineuse et calme.'),

    -- Essentials & Food
    ('eau', 'water', 'noun', 'Buvez beaucoup d''eau pendant l''effort.'),
    ('pain', 'bread', 'noun', 'Le pain frais de la boulangerie est délicieux.'),
    ('nourriture', 'food', 'noun', 'La nourriture saine favorise la concentration.'),
    ('pomme', 'apple', 'noun', 'Je mange une pomme comme collation.'),
    ('argent', 'money / silver', 'noun', 'Le budget alloué est suffisant pour la phase 1.'),
    ('livre', 'book', 'noun', 'Ce livre de gestion de produit est remarquable.'),
    ('clé', 'key', 'noun', 'N''oubliez pas votre clé d''accès au laboratoire.'),

    -- Common Adjectives
    ('grand', 'big / tall', 'adjective', 'C''est un grand défi pour notre équipe.'),
    ('petit', 'small', 'adjective', 'Faisons un petit ajustement au modèle.'),
    ('bon', 'good', 'adjective', 'C''est une très bonne initiative technique.'),
    ('mauvais', 'bad', 'adjective', 'Une mauvaise architecture entraîne une dette technique.'),
    ('beau', 'beautiful / fine', 'adjective', 'Le résultat final est très beau.'),
    ('nouveau', 'new', 'adjective', 'Voici le nouveau tableau de bord opérationnel.'),
    ('facile', 'easy', 'adjective', 'La première étape est simple et facile.'),
    ('difficile', 'difficult', 'adjective', 'La migration de données a été difficile mais réussie.'),
    ('cher', 'expensive / dear', 'adjective', 'Cette solution logicielle est trop chère.'),
    ('rapide', 'fast / quick', 'adjective', 'Nous visons un temps de réponse rapide.'),
    ('important', 'important', 'adjective', 'C''est une exigence non fonctionnelle importante.'),
    ('prêt', 'ready', 'adjective', 'Le schéma de base de données est prêt.'),

    -- Adverbs, Quantifiers & Prepositions
    ('toujours', 'always / still', 'adverb', 'Il respecte toujours les délais de livraison.'),
    ('jamais', 'never', 'adverb', 'Ne faites jamais de commit directement sans relecture.'),
    ('souvent', 'often', 'adverb', 'Nous synchronisons nos tâches souvent.'),
    ('beaucoup', 'a lot / much', 'adverb', 'Ce retour d''expérience m''aide beaucoup.'),
    ('un peu', 'a little', 'adverb', 'Je parle un peu français chaque jour.'),
    ('ici', 'here', 'adverb', 'Les fichiers de migration sont stockés ici.'),
    ('là-bas', 'over there', 'adverb', 'La salle de conférence se trouve là-bas.'),
    ('avec', 'with', 'preposition', 'Nous collaborons étroitement avec l''équipe produit.'),
    ('sans', 'without', 'preposition', 'Un projet sans suivi rigoureux risque d''échouer.'),
    ('pour', 'for / in order to', 'preposition', 'Cette API est conçue pour l''intégration mobile.'),
    ('dans', 'in / inside', 'preposition', 'Les données sont persistées dans PostgreSQL.'),
    ('sur', 'on / about', 'preposition', 'Le rapport repose sur des métriques précises.'),

    -- Interrogatives
    ('pourquoi', 'why', 'adverb', 'Pourquoi avons-nous choisi ce modèle de données ?'),
    ('comment', 'how', 'adverb', 'Comment pouvons-nous optimiser cette requête SQL ?'),
    ('quand', 'when', 'adverb', 'Quand aura lieu la revue de sprint ?'),
    ('où', 'where', 'adverb', 'Où se trouvent les spécifications techniques ?'),
    ('qui', 'who', 'pronoun', 'Qui est responsable de cette fonctionnalité ?')
) AS w(term, definition, part_of_speech, example_sentence);