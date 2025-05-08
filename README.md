# Image Rating App

A full-stack application for rating images, built with Flutter and Node.js.

## Project Structure

```
.
├── frontend/              # Flutter application
│   ├── lib/              # Flutter source code
│   ├── test/             # Flutter tests
│   └── pubspec.yaml      # Flutter dependencies
│
├── backend/              # Node.js server
│   ├── src/             # Source code
│   ├── test/            # Backend tests
│   └── package.json     # Node.js dependencies
│
└── README.md            # This file
```

## Features

- Display images in a scrollable list
- Rate images using a 5-star rating system
- Real-time rating updates
- Responsive design
- Error handling and loading states
- Comprehensive test coverage

## Prerequisites

- Flutter SDK (latest stable version)
- Node.js (v14 or higher)
- SQLite3

## Getting Started

1. Clone the repository:
```bash
git clone https://github.com/Aroxed/flutter-rating-app
cd image-rating-app
```

2. Set up the frontend:
```bash
cd frontend
flutter pub get
flutter run
```

3. Set up the backend:
```bash
cd backend
npm install
npm start
```

## Development

### Frontend (Flutter)
- Located in `frontend/` directory
- Uses Flutter for cross-platform mobile development
- Implements Material Design
- Includes comprehensive widget tests

### Backend (Node.js)
- Located in `backend/` directory
- RESTful API with Express.js
- SQLite database for data storage
- File upload handling for images

## API Endpoints

- `GET /api/images` - Get all images
- `POST /api/images/:id/rate` - Rate an image
  - Body: `{ "rating": number }`

## Testing

### Frontend Tests
```bash
cd frontend
flutter test
```

