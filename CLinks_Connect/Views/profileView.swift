//
//  profileView.swift
//  CLinks_Connect
//
//  Created by arpit on 09/10/26.
//

import SwiftUI
import Supabase

struct profileView: View {
    private var email: String {
        AuthManager.shared.session?.user.email ?? "No email available"
    }

    private var name: String {
        String(email.split(separator: "@").first ?? Substring(email))
    }

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
                    .overlay {
                        Text(String(name.prefix(1)).uppercased())
                            .font(.system(size: 42, weight: .bold))
                            .foregroundStyle(.white)
                    }

                VStack(spacing: 6) {
                    Text(name)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(.white)

                    Text(email)
                        .font(.system(size: 14))
                        .foregroundStyle(.gray)
                        .textSelection(.enabled)
                }

                Button {
                    Task {
                        await AuthManager.shared.signOut()
                    }
                } label: {
                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                        Text("Log Out")
                    }
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
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    profileView()
}
