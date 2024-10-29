//
//  PromitionView.swift
//  Chess
//
//  Created by Jared Cassoutt on 10/27/24.
//

import SwiftUI

struct PromotionView: View {
    @ObservedObject var game: ChessGame
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Text("Promote your pawn to:")
                .font(.headline)
                .padding()

            HStack {
                ForEach([PieceType.queen, .rook, .bishop, .knight], id: \.self) { type in
                    Button(action: {
                        game.promotePawn(to: type)
                        if game.isCheckmate || game.isStalemate {
                            // Game over after promotion
                            return
                        }
                        self.game.currentPlayer = self.game.currentPlayer.opponent
                        if self.game.currentPlayer == .black {
                            _ = self.game.opponentMove()
                        }
                        // Dismiss the view after promotion
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image("\(type.rawValue)_\(game.promotionPending?.color.rawValue ?? "white")")
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                }
            }
            .padding()
        }
    }
}
