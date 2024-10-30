![image](https://github.com/user-attachments/assets/8104c926-13a5-4423-a577-80f8ac69f25b)
Image generated using DALL-E.

# Journal App

A simple journal app built with Swift, UIKit, and Core Data, utilizing the Model-View-ViewModel (MVVM) architecture pattern. The app allows users to create, read, and manage journal entries.

## Features

- **Add Journal Entries**: Users can create new journal entries with a title and description.
- **List of Entries**: All journal entries are displayed in a table view.
- **Persistent Storage**: Uses Core Data to store journal entries persistently.
- **MVVM Architecture**: Keeps the UI and business logic separate for better maintainability.

## Prerequisites

- Xcode 16 or later
- Swift 5.0 or later

## Installation

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/ice-bit/Journal.git
   cd Journal
   ```

2. **Open the Project**:
   Open the `.xcodeproj` file in Xcode.

3. **Set Up Core Data**:
   Ensure that Core Data is set up correctly in the project. The necessary model files should be included in the project.

4. **Run the App**:
   Select a simulator or a connected device and run the app using the play button in Xcode.

## Usage

1. **Creating a Journal Entry**:
   - Tap the "Add Entry" button in the navigation bar.
   - An alert will appear prompting you to enter a title and description.
   - Fill in the details and tap "Save" to create a new entry.

2. **Viewing Entries**:
   - All journal entries will be listed in the main view.
   - Entries are displayed with their titles, and tapping on them can lead to a detailed view (available real soon).

3. **Deleting Entries** (available real soon):
   - Implement swipe-to-delete functionality to remove entries from the list.

## Architecture

### MVVM Pattern

- **Model**: The data layer, which includes the Core Data entities (`Entry`) and the persistence logic.
- **View**: The UI layer built with UIKit, displaying the journal entries in a table view.
- **ViewModel**: The intermediary that handles data logic. It fetches, adds, and deletes entries from the model and exposes data to the view.

## Code Structure

- `Models/`: Contains Core Data entities and the Core Data stack setup.
- `ViewModels/`: Contains the ViewModel implementations for managing journal entries.
- `Views/`: Contains view controllers, including `JournalViewController` and `AddEntryViewController`(not yet).

## Contribution

Feel free to fork the repository and submit pull requests for any features or improvements!

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
