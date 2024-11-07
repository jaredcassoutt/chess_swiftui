# SwiftUI Chess Game
A full-featured chess game built with SwiftUI, where you can play against AI opponents with varying difficulty levels. Designed to be easy to play, fun, and a bit of a brain teaser, this app includes all the classic rules of chess—check, checkmate, castling, en passant, and pawn promotion.

## Preview
<p align="center">
  <img src="https://github.com/user-attachments/assets/18802f38-4a5f-4f4a-b1e7-d613843655be" alt="Preview" width="300">
</p>

## Features
- **Three AI Difficulty Levels:** Choose from Easy, Medium, and Hard to match your skill level.
- **Dynamic Board and Smooth Animations:** Responsive chessboard layout with SwiftUI animations.
- **Classic Chess Mechanics:** Includes check, checkmate, stalemate detection, castling, en passant, and pawn promotion.
- **User-Friendly Alerts:** Game-over alerts for checkmate, stalemate, and options to reset the game or change difficulty.

## Getting Started
1. Clone the Repository:
   ```bash
    git clone https://github.com/jaredcassoutt/chess_swiftui.git

2. Open the Project in Xcode:
    - Open Chess.xcodeproj in Xcode.
    - Make sure you’re running Xcode 12 or later.
3. Run the App:
    - Build and run on the simulator or an actual device.
    - Select a difficulty and start playing!

## How It Works
The project contains three main components:
- **ChessView.swift:** The UI layout for the board, including piece placement and interactive moves.
- **ChessGame.swift:** The game engine that handles the rules, piece movement logic, and game states.
- **OpponentChessEngine.swift:** The AI engine, using minimax for advanced moves in Hard mode and capturing strategies in Medium mode.

## Future Enhancements
- **Online Multiplayer:** For real-time games with friends.
- **Advanced AI:** A deeper minimax algorithm for a stronger Hard mode.
- **Sound Effects and Animations:** Adding flair to captures and game-end scenarios.

## Contributing
Feel free to fork the project, submit issues, or suggest improvements. I’d love to hear your feedback or collaborate on new features.

## License
This project is open-source under the MIT License.

Thanks for checking out my SwiftUI chess game! Dive into the code, play a few rounds, and let me know if you spot any sneaky moves I might have missed.
