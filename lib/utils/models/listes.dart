class ListesApp {
  static final subjects = [
    'Mathématiques',
    'Français',
    'SVT',
    'Physique-Chimie',
    'Philosophie',
    'Informatique',
    'Histoire-Géographie',
    'Anglais',
    'Dessin',
    'EPS',
    'Autres',
  ];

  static final levels = [
    'Maternelle',
    'Primaire',
    'Collège',
    'Lycée Général',
    'Lycée Professionnel',
    'Université',
    'Autres',
  ];

  static final diplomas = [
    'CEPE',
    'BEPC',
    'BAC +1',
    'Bac +2',
    'BTS',
    'Licence',
    'Master',
    'Doctorat',
    'Autres',
  ];

  static final genders = ["Homme", "Femme"];
  static final isPublicListes = ["Public", "Privé"];

  static final experienceYears = List.generate(
    40,
    (index) => '${index + 1} ans',
  );

  static final congoCities = [
    'Brazzaville',
    'Pointe-Noire',
    'Dolisie',
    'Nkayi',
    'Kindamba',
    'Impfondo',
    'Ouésso',
    'Madingo-Kayes',
    'Owando',
    'Sibiti',
    'Loango',
    'Madingou',
    'Mossaka',
    'Gamboma',
    'Makoua',
    'Sembé',
    'Ewo',
    'Mbinda',
    'Lékana',
    'Kinkala',
  ];
}
