# Tugas PBB

| **Name**               | **NRP**    |
| ---------------------- | ---------- |
| Reynaldi Neo Ramadhani | 5025221265 |

A Flutter project for the **Programming for Mobile Devices** course. This application is a **Note-Keeping App** that allows users to manage their personal notes, with functionality to add, edit, delete, and view notes. The app also features priority management, date creation, and a stylish user interface.

## Link Short Demo

https://drive.google.com/file/d/1hPYKRVR4sTRozyn9NKk0ETBPY-3exhsN/view?usp=sharing

## Technologies Used

-   **Flutter**: Framework for building cross-platform apps.
-   **Dart**: Programming language used for Flutter development.
-   **SQLite**: Local database for storing notes.

## Features

### 1. **Add Note**

Users can add new notes to the app by providing the following information:

-   **Title**: The main title of the note (e.g., "Meeting Notes").
-   **Description**: The content or details of the note.
-   **Priority**: Each note can be assigned one of two priority levels: **High** or **Low**.
-   **Date**: The date when the note was created, which is automatically set upon saving.

**How to Add a Note:**

-   Tap on the **Save** button after filling out the Title, Description, and Priority.
-   A new note will be added and saved in the local database with a creation date.

### 2. **Edit Note**

Users can edit existing notes by updating their Title, Description, and Priority. The app allows the modification of any attribute of the note, and the changes are reflected in the database after saving.

**How to Edit a Note:**

-   Select a note from the list.
-   Update the Title, Description, or Priority as needed.
-   Tap **Save** to save the changes.

### 3. **Delete Note**

Users can delete notes they no longer need. When a note is deleted, it is removed from the list and the database.

**How to Delete a Note:**

-   Select a note from the list.
-   Tap on the **Delete** button to permanently remove the note from the app.
-   A confirmation dialog appears to confirm the deletion.

### 4. **View Notes**

Users can view all notes in a list. The notes are displayed in a scrollable list where each note shows its title, description, and priority. Notes are listed in **priority order**, with high-priority notes displayed at the top.

**How to View Notes:**

-   Upon launching the app, users can see the list of saved notes.
-   Notes are displayed with a **priority indicator** and basic details.
-   The app supports **scrolling** to navigate through many notes.

### 5. **Priority Levels**

Each note can be assigned a priority level:

-   **High**: Denoted by a **Red** color or priority indicator.
-   **Low**: Denoted by a **Yellow** color or priority indicator.

Notes are color-coded and sorted based on their priority. **High** priority notes are shown first in the list, followed by **Low** priority notes. Users can select the priority for each note when creating or editing the note.

### 6. **Dialog with Status Updates**

When a note is saved or deleted, the app shows a **status dialog** informing the user about the success or failure of the operation.

**Dialog Features:**

-   The dialog title is customizable to indicate success or failure (e.g., "Note Saved Successfully").
-   The dialog has a **stylish OK button** to close the alert.

### 7. **Data Persistence**

All notes are stored in the local SQLite database using **DatabaseHelper**. The app allows for **insertion**, **deletion**, **editing**, and **reading** of notes.

**Note Storage and Operations:**

-   **Save**: Notes are saved with their Title, Description, Priority, and Date in the database.
-   **Delete**: Notes can be deleted from the database via the **Delete** button.
-   **Edit**: Updated notes are saved back into the database with their new details.
-   **Read**: Notes can be retrieved from the database to be displayed in the app.
