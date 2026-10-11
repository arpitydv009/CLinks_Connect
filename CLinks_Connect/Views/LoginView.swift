//
//  LoginView.swift
//  CLinks_Connect
//
//  Created by arpit on 10/10/26.
//

import SwiftUI
import Supabase

struct LoginView: View {
    @State private var email = ""
    @State private var errorMessage = ""
    @State private var isLoading = false
    @State private var emailSent = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.04, green: 0.07, blue: 0.13),
                    Color(red: 0.06, green: 0.12, blue: 0.22),
                    Color(red: 0.03, green: 0.05, blue: 0.10)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text(emailSent ? "Check your email" : "Welcome back")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)

                if emailSent {
                    Text("We've sent you a sign-in link. Open it to continue to NSUT Connect.")
                        .foregroundStyle(.white.opacity(0.75))
                        .multilineTextAlignment(.center)

                    Button("Use another email") {
                        emailSent = false
                        errorMessage = ""
                    }
                    .foregroundStyle(
                        Color(red: 0.35, green: 0.72, blue: 1.0)
                    )
                } else {
                    TextField(
                        "",
                        text: $email,
                        prompt: Text("Enter your NSUT email ID")
                            .foregroundColor(.white.opacity(0.65))
                    )
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .padding()
                    .background(.white.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .foregroundStyle(.white)

                    Button("Verify") {
                        Task{
                            await sendMagicLink()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color(red: 0.20, green: 0.58, blue: 0.95))
                    .disabled(isLoading)

                    if isLoading {
                        ProgressView()
                            .tint(.white)
                    }
                }

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }
            }        }
    }
    
    private func sendMagicLink() async {
        errorMessage = ""

        let trimmedEmail = email.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        /*guard trimmedEmail.lowercased().hasSuffix("@nsut.ac.in") else {
            errorMessage = "Please enter a valid NSUT email address."
            return
        }*/
        
        

        isLoading = true
        defer { isLoading = false }

        do {
            try await SupabaseManager.shared.client.auth.signInWithOTP(
                email: trimmedEmail,
                redirectTo: URL(string: "clinksconnect://login-callback")!
            )

            emailSent = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
}



#Preview {
    LoginView()
        
}
