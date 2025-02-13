# Memories Recorder

Memories Recorder is a Flutter application that allows users to store their thoughts and memories securely. Users can add diary entries with a title, date, and their thoughts. The app supports user authentication and personalized data storage using **SharedPreferences**.

## Features

- **User Authentication**: Each user has their own stored data.
- **Secure Data Storage**: Entries are saved using SharedPreferences.
- **Diary Entry Management**: Users can add, edit, and save memories.
- **Date Picker**: Allows users to select a date for their entries.
- **Custom Dialogs**: For updating username, email, and password securely.

## Installation

1. **Clone the repository:**
   ```sh
   git clone https://github.com/yourusername/memories-recorder.git
   ```
2. **Navigate to the project directory:**
   ```sh
   cd memories-recorder
   ```
3. **Install dependencies:**
   ```sh
   flutter pub get
   ```
4. **Run the app:**
   ```sh
   flutter run
   ```

## Project Structure
```
memories-recorder/
│-- lib/
│   │-- main.dart  # Entry point of the application
│   │-- home.dart  # Home page of the application
│   │-- add_page.dart  # Page to add new diary entries
│   │-- dialogs.dart  # Custom dialogs for updating details
│   └── utils.dart  # Utility functions and shared preferences handling
│-- assets/
│   └── images/  # Store any required images here
│-- pubspec.yaml  # Project dependencies and configuration
└-- README.md  # Project documentation
```

## Dependencies
This project uses the following Flutter dependencies:
- `flutter`
- `shared_preferences`
- `flutter_material`

Ensure all dependencies are installed by running:
```sh
flutter pub get
```

## Usage
1. **Sign in or Register**
2. **Create a new memory** by entering a title, date, and your thoughts.
3. **Edit user details** like username, email, and password using the custom dialogs.
4. **Save data securely** using SharedPreferences.

## Figma Link
http://figma.com/design/FaR4caBxBGnbnsNu3qobdp/Diary-Android-App-Mobile-UI-Design-(Community)?node-id=3-148&t=1ypQxOg5zCcStaU6-0

## Contributing
If you’d like to contribute, feel free to fork this repo and submit a pull request.

## License
This project is open-source and available under the MIT License.

