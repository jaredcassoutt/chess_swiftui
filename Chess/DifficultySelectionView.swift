//
//  DifficultySelectionView.swift
//  Chess
//
//  Created by Jared Cassoutt on 10/28/24.
//

import SwiftUI

struct DifficultySelectionView: View {
    @Binding var selectedDifficulty: DifficultyLevel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Text("Select your opponent's difficulty")
                .font(.headline)
                .padding()

            HStack(spacing: 20) {
                // Easy
                VStack {
                    Button(action: {
                        selectedDifficulty = .easy
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image("pawn_black")
                            .resizable()
                            .frame(width: 60, height: 60)
                    }
                    Text("Easy")
                        .font(.subheadline)
                }

                // Medium
                VStack {
                    Button(action: {
                        selectedDifficulty = .medium
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image("knight_black")
                            .resizable()
                            .frame(width: 60, height: 60)
                    }
                    Text("Medium")
                        .font(.subheadline)
                }

                // Hard
                VStack {
                    Button(action: {
                        selectedDifficulty = .hard
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image("queen_black")
                            .resizable()
                            .frame(width: 60, height: 60)
                    }
                    Text("Hard")
                        .font(.subheadline)
                }
            }
            .padding()
        }
    }
}

