//
//  profileView.swift
//  CLinks_Connect
//
//  Created by arpit on 09/10/26.
//

import SwiftUI

struct profileView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.08, green: 0.09, blue: 0.15),
                    Color(red: 0.12, green: 0.13, blue: 0.2)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.cyan, .blue]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 100, height: 100)
                        .overlay(
                            Text(dummyProfile.name.prefix(1))
                                .font(.system(size: 42, weight: .bold))
                                .foregroundStyle(.white)
                        )

                    VStack(spacing: 6) {
                        Text(dummyProfile.name)
                            .font(.system(size: 26, weight: .bold))
                            .foregroundStyle(.white)

                        Text(dummyProfile.email)
                            .font(.system(size: 14))
                            .foregroundStyle(.gray)
                    }

                    VStack(spacing: 0) {
                        profileRow(
                            title: "Roll Number",
                            value: dummyProfile.rollNumber,
                            icon: "number"
                        )

                        profileRow(
                            title: "Branch",
                            value: dummyProfile.branch,
                            icon: "graduationcap"
                        )

                        profileRow(
                            title: "Year",
                            value: dummyProfile.year,
                            icon: "calendar"
                        )
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(red: 0.15, green: 0.16, blue: 0.22))
                    )

                    Button {
                        // Logout will be connected later
                    } label: {
                        Text("Log Out")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color.red.opacity(0.1))
                            )
                    }
                }
                .padding(20)
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct profileRow: View {
    let title: String
    let value: String
    let icon: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .foregroundStyle(.cyan)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 12))
                    .foregroundStyle(.gray)

                Text(value)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.white)
            }

            Spacer()
        }
        .padding(16)
    }
}

#Preview{
    profileView()
}
