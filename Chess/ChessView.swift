//
//  ChessView.swift
//  Chess
//
//  Created by Jared Cassoutt on 10/27/24.
//

import SwiftUI

struct ChessView: View {
    @StateObject private var game: ChessGame
    @State private var showGameOverAlert = false
    @State private var showPromotionSheet = false
    @State private var showResetButton = false
    @State private var showDifficultySelection = true
    @State private var selectedDifficulty: DifficultyLevel = .easy

    init() {
        _game = StateObject(wrappedValue: ChessGame(difficulty: .easy))
    }

    var gameOverMessage: String {
        if game.isCheckmate {
            if game.currentPlayer == .white {
                return "Checkmate. You lose 😭"
            } else {
                return "Checkmate! You win 🎉"
            }
        } else if game.isStalemate {
            return "Stalemate!"
        } else {
            return ""
        }
    }

    var body: some View {
        GeometryReader { geometry in
            let squareSize = min(geometry.size.width, geometry.size.height) / 8
            let boardSize = squareSize * 8

            VStack {
                Spacer()
                VStack(spacing: 0) {
                    ForEach((0..<8).reversed(), id: \.self) { row in
                        HStack(spacing: 0) {
                            ForEach(0..<8, id: \.self) { column in
                                ZStack {
                                    // Square color
                                    Rectangle()
                                        .fill((row + column) % 2 == 0 ? Color.white : Color.gray)
                                        .frame(width: squareSize, height: squareSize)

                                    // Piece Image
                                    if let piece = game.board[row][column] {
                                        Image("\(piece.type.rawValue)_\(piece.color.rawValue)")
                                            .resizable()
                                            .frame(width: squareSize * 0.8, height: squareSize * 0.8)
                                            .onTapGesture {
                                                if piece.color == game.currentPlayer {
                                                    withAnimation(.easeInOut(duration: 0.3)) {
                                                        game.selectPiece(at: (row, column))
                                                    }
                                                }
                                            }
                                    }

                                    // Highlight possible moves
                                    if game.possibleMoves.contains(where: { $0 == (row, column) }) {
                                        Circle()
                                            .fill(Color.blue.opacity(0.5))
                                            .frame(width: squareSize * 0.6, height: squareSize * 0.6)
                                            .onTapGesture {
                                                if let _ = game.selectedPiece {
                                                    withAnimation(.easeInOut(duration: 0.3)) {
                                                        if !game.movePiece(to: (row, column)) {
                                                            // Checkmate or stalemate
                                                            showGameOverAlert = true
                                                        } else {
                                                            // Check for promotion
                                                            if game.promotionPending != nil {
                                                                showPromotionSheet = true
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                    }
                                }
                            }
                        }
                    }
                }
                .frame(width: boardSize, height: boardSize)
                .border(Color.black, width: 2)
                Spacer()

                // Conditionally display the Reset button
                if showResetButton {
                    Button(action: {
                        showResetButton = false
                        showDifficultySelection = true
                    }) {
                        Text("Reset")
                            .font(.headline)
                            .padding()
                            .frame(width: 200)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onChange(of: game.isCheckmate) { isCheckmate in
            if isCheckmate {
                showGameOverAlert = true
            }
        }
        .onChange(of: game.isStalemate) { isStalemate in
            if isStalemate {
                showGameOverAlert = true
            }
        }
        .alert(isPresented: $showGameOverAlert) {
            Alert(
                title: Text("Game Over"),
                message: Text(gameOverMessage),
                primaryButton: .default(Text("Reset")) {
                    showDifficultySelection = true
                },
                secondaryButton: .cancel {
                    showResetButton = true // Show the Reset button when Cancel is tapped
                }
            )
        }
        .sheet(isPresented: $showPromotionSheet) {
            PromotionView(game: game)
        }
        .sheet(isPresented: $showDifficultySelection, onDismiss: {
            game.resetGame(difficulty: selectedDifficulty)
        }) {
            DifficultySelectionView(selectedDifficulty: $selectedDifficulty)
        }
    }
}
