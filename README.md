Voici un **README.md** structuré et détaillé pour ton projet, intégrant une documentation complète sur l'installation, les fonctionnalités, les technologies utilisées, et la structure du projet.

---

# **Routine App**

Routine App est une application Flutter permettant de gérer et visualiser des routines quotidiennes sous forme de graphiques de progression inspirés du style GitHub. L'application intègre des fonctionnalités de suivi, de filtrage, et de visualisation des données des routines, tout en offrant une expérience fluide et personnalisée.

---

## **Fonctionnalités**

### 1. **Gestion des Routines**
- Ajouter, modifier et supprimer des routines.
- Associer des états aux routines (complété, partiellement complété, etc.).
- Suivi des routines sur plusieurs années.

### 2. **Visualisation des Données**
- Graphiques de progression inspirés de GitHub.
- Affichage des routines par période et par catégorie.
- Zoom et défilement horizontal pour naviguer dans les périodes.

### 3. **Filtres et Personnalisation**
- Filtrer les routines par catégorie.
- Sélectionner une période personnalisée à l'aide d'un calendrier.

---

## **Technologies Utilisées**

### **Frontend**
- **Flutter** : Framework UI multiplateforme.
- **Provider** : Gestion d'état pour synchroniser les données et les widgets.

### **Backend**
- **SQLite** : Base de données locale pour stocker les routines.


---

## **Installation**

### 1. Prérequis
- [Flutter](https://flutter.dev/docs/get-started/install) installé sur votre machine.
- Un émulateur Android/iOS ou un appareil physique connecté.

### 2. Cloner le projet
```bash
git clone https://github.com/yourusername/routine-app.git
cd routine-app
```

### 3. Installer les dépendances
```bash
flutter pub get
```

### 4. Lancer l'application
#### **Sur un simulateur**
```bash
flutter emulators --launch <emulator_name>
flutter run
```

#### **Sur un appareil physique**
- Connectez votre appareil.
- Activez le mode développeur.
- Exécutez :
```bash
flutter run
```

---

## **Structure du Projet**

```
.
├── lib/
│   ├── main.dart             # Point d'entrée de l'application
│   ├── screens/              # Contient les écrans principaux
│   │   ├── home_screen.dart
│   │   ├── routines_screen.dart
│   │   ├── statistics_screen.dart
│   ├── widgets/              # Composants réutilisables
│   │   ├── github_style_chart.dart
│   ├── providers/            # Gestion des états
│   │   ├── routineProvider.dart
│   │   ├── completionProvider.dart
│   ├── db/                   # Interactions avec la base de données
│   │   ├── database.dart
│   ├── models/               # Modèles de données
│       ├── routine_model.dart
│       ├── state_model.dart
│       ├── frequency_model.dart
└── pubspec.yaml              # Configuration des dépendances
```

---

## **Documentation des Composants**

### **1. RoutineProvider**
Gestionnaire d'état central pour les routines.

#### **Méthodes principales**
- `loadRoutines()` : Charge les routines depuis la base de données.
- `addRoutine(Map<String, dynamic>)` : Ajoute une nouvelle routine.
- `updateRoutine(int id, Map<String, dynamic>)` : Met à jour une routine existante.
- `deleteRoutine(int id)` : Supprime une routine.

### **2. GithubStyleChart**
Widget affichant le graphique des routines sous forme de grille inspirée de GitHub.

#### **Propriétés**
- `startDate` : Date de début de la période affichée.
- `endDate` : Date de fin de la période affichée.
- `data` : Liste des routines à afficher.

#### **Personnalisation**
- Les couleurs des cellules sont configurées dans la méthode `_colorFromValue` :
  ```dart
  Color _colorFromValue(int value) {
    switch (value) {
      case 0: return const Color(0xFFEBEDF0);
      case 1: return const Color(0xFF9BE9A8);
      case 2: return const Color(0xFF40C463);
      case 3: return const Color(0xFF30A14E);
      default: return const Color(0xFF216E39);
    }
  }
  ```

### **3. DatabaseHelper**
Classe singleton pour interagir avec SQLite.

#### **Tables principales**
- `Routine` : Stocke les informations sur les routines.
- `State` : Définit les états possibles d'une routine.
- `Frequency` : Définit la fréquence d'une routine.

---

## **Exemple d'Utilisation**

### Ajouter une routine
```dart
final routineProvider = Provider.of<RoutineProvider>(context, listen: false);
routineProvider.addRoutine({
  'name': 'Routine Matinale',
  'startDate': DateTime.now().toString(),
  'icon': '☀️',
  'description': 'Routine pour bien commencer la journée',
  'frequencyId': 1,
  'recurrence': 7,
  'days': '1,2,3,4,5',
});
```

### Charger les données
```dart
final routineProvider = Provider.of<RoutineProvider>(context, listen: false);
await routineProvider.loadRoutines();
```

---

