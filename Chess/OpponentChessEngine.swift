//
//  OpponentChessEngine.swift
//  Chess
//
//  Created by Jared Cassoutt on 10/27/24.
//

import Foundation

enum DifficultyLevel {
    case easy
    case medium
    case hard
}

class OpponentChessEngine {
    unowned var game: ChessGame
    var difficulty: DifficultyLevel

    init(game: ChessGame, difficulty: DifficultyLevel) {
        self.game = game
        self.difficulty = difficulty
    }

    func makeMove() -> Bool {
        switch difficulty {
        case .easy:
            return makeRandomMove()
        case .medium:
            return makeMediumMove()
        case .hard:
            return makeHardMove()
        }
    }

    // MARK: - Easy Level: Random Move

    func makeRandomMove() -> Bool {
        let opponentPieces = game.board.flatMap { $0 }.compactMap { $0 }.filter { $0.color == game.currentPlayer }

        // Clear En passant target
        game.enPassantTarget = nil

        for piece in opponentPieces.shuffled() {
            let moves = game.calculateLegalMoves(for: piece)
            if let move = moves.randomElement() {
                game.saveCurrentBoardState()
                game.performMove(piece: piece, to: move)
                return true
            }
        }

        // No valid moves found
        print("Opponent has no valid moves")
        game.currentPlayer = game.currentPlayer.opponent
        game.updateGameState()
        return false
    }

    // MARK: - Medium Level: Capture High-Value Pieces

    func makeMediumMove() -> Bool {
        let opponentPieces = game.board.flatMap { $0 }.compactMap { $0 }.filter { $0.color == game.currentPlayer }
        var possibleMoves: [(piece: ChessPiece, destination: (Int, Int), score: Int)] = []

        // Clear En passant target
        game.enPassantTarget = nil

        for piece in opponentPieces {
            let moves = game.calculateLegalMoves(for: piece)
            for move in moves {
                // Check for captured piece
                let capturedPiece = game.board[move.0][move.1]
                let score = capturedPiece != nil ? game.pieceValue(capturedPiece!.type) : 0
                possibleMoves.append((piece, move, score))
            }
        }

        if possibleMoves.isEmpty {
            // No valid moves found
            print("Opponent has no valid moves")
            game.currentPlayer = game.currentPlayer.opponent
            game.updateGameState()
            return false
        }

        // Prefer capturing moves
        let captureMoves = possibleMoves.filter { $0.score > 0 }
        let selectedMove: (piece: ChessPiece, destination: (Int, Int), score: Int)
        if !captureMoves.isEmpty {
            selectedMove = captureMoves.randomElement()!
        } else {
            selectedMove = possibleMoves.randomElement()!
        }

        game.saveCurrentBoardState()
        game.performMove(piece: selectedMove.piece, to: selectedMove.destination)
        return true
    }

    // MARK: - Hard Level: Minimax Algorithm
    func makeHardMove() -> Bool {
        let depth = 2 // Adjust for performance vs. strength
        guard let bestMove = minimaxRoot(depth: depth, isMaximizingPlayer: true) else {
            // No valid moves found
            print("Opponent has no valid moves")
            game.currentPlayer = game.currentPlayer.opponent
            game.updateGameState()
            return false
        }

        // Execute the best move
        game.saveCurrentBoardState()
        game.performMove(piece: bestMove.piece, to: bestMove.destination)
        return true
    }

    func minimaxRoot(depth: Int, isMaximizingPlayer: Bool) -> (piece: ChessPiece, destination: (Int, Int))? {
        var bestScore = Int.min
        var bestMoves: [(piece: ChessPiece, destination: (Int, Int))] = []

        let opponentPieces = game.board.flatMap { $0 }.compactMap { $0 }.filter { $0.color == game.currentPlayer }

        for piece in opponentPieces {
            let moves = game.calculateLegalMoves(for: piece)
            for move in moves {
                // Save the current state
                let originalPiece = game.board[move.0][move.1]
                let originalPosition = piece.position

                // Make the move
                game.board[piece.position.0][piece.position.1] = nil
                game.board[move.0][move.1] = ChessPiece(
                    type: piece.type,
                    color: piece.color,
                    position: move,
                    hasMoved: true
                )

                let score = minimax(depth: depth - 1, isMaximizingPlayer: false)

                // Undo the move
                game.board[piece.position.0][piece.position.1] = ChessPiece(
                    type: piece.type,
                    color: piece.color,
                    position: originalPosition,
                    hasMoved: piece.hasMoved
                )
                game.board[move.0][move.1] = originalPiece

                if score > bestScore {
                    bestScore = score
                    bestMoves = [(piece, move)]
                } else if score == bestScore {
                    bestMoves.append((piece, move))
                }
            }
        }

        if bestMoves.isEmpty {
            return nil
        } else {
            // Introduce a bit of randomness among the best moves
            let selectedMove = bestMoves.randomElement()!
            return selectedMove
        }
    }

    func minimax(depth: Int, isMaximizingPlayer: Bool) -> Int {
        if depth == 0 {
            return evaluateBoard()
        }

        let currentColor = isMaximizingPlayer ? game.currentPlayer : game.currentPlayer.opponent
        let pieces = game.board.flatMap { $0 }.compactMap { $0 }.filter { $0.color == currentColor }

        if isMaximizingPlayer {
            var bestScore = Int.min
            for piece in pieces {
                let moves = game.calculateLegalMoves(for: piece)
                for move in moves {
                    // Save the current state
                    let originalPiece = game.board[move.0][move.1]
                    let originalPosition = piece.position

                    // Make the move
                    game.board[piece.position.0][piece.position.1] = nil
                    game.board[move.0][move.1] = ChessPiece(
                        type: piece.type,
                        color: piece.color,
                        position: move,
                        hasMoved: true
                    )

                    let score = minimax(depth: depth - 1, isMaximizingPlayer: false)

                    // Undo the move
                    game.board[piece.position.0][piece.position.1] = ChessPiece(
                        type: piece.type,
                        color: piece.color,
                        position: originalPosition,
                        hasMoved: piece.hasMoved
                    )
                    game.board[move.0][move.1] = originalPiece

                    bestScore = max(bestScore, score)
                }
            }
            return bestScore
        } else {
            var bestScore = Int.max
            for piece in pieces {
                let moves = game.calculateLegalMoves(for: piece)
                for move in moves {
                    // Save the current state
                    let originalPiece = game.board[move.0][move.1]
                    let originalPosition = piece.position

                    // Make the move
                    game.board[piece.position.0][piece.position.1] = nil
                    game.board[move.0][move.1] = ChessPiece(
                        type: piece.type,
                        color: piece.color,
                        position: move,
                        hasMoved: true
                    )

                    let score = minimax(depth: depth - 1, isMaximizingPlayer: true)

                    // Undo the move
                    game.board[piece.position.0][piece.position.1] = ChessPiece(
                        type: piece.type,
                        color: piece.color,
                        position: originalPosition,
                        hasMoved: piece.hasMoved
                    )
                    game.board[move.0][move.1] = originalPiece

                    bestScore = min(bestScore, score)
                }
            }
            return bestScore
        }
    }

    func evaluateBoard() -> Int {
        var totalScore = 0
        for row in game.board {
            for piece in row.compactMap({ $0 }) {
                let value = game.pieceValue(piece.type)
                totalScore += piece.color == game.currentPlayer ? value : -value
            }
        }
        // Introduce a small random factor (up to +/- 5%)
        let randomFactor = Int(Double(totalScore) * Double.random(in: -0.05...0.05))
        return totalScore + randomFactor
    }
}
