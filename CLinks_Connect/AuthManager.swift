//
//  AuthManager.swift
//  CLinks_Connect
//
//  Created by arpit on 10/10/26.
//
import Foundation
import Combine
import Supabase

@MainActor
final class AuthManager: ObservableObject {

    static let shared = AuthManager()

    @Published var session: Session?
    @Published var isLoading = true

    private var listenerTask: Task<Void, Never>?

    private init() {
        listenerTask = Task {
            for await (_, session) in
                SupabaseManager.shared.client.auth.authStateChanges {

                self.session = session
                print("Current session exists:", session != nil)
                self.isLoading = false
            }
        }
    }
    
    func signOut() async {
        do {
            try await SupabaseManager.shared.client.auth.signOut()
        } catch {
            print("Sign-out error:", error.localizedDescription)
        }
    }
    
}
