//
//  CLinks_ConnectApp.swift
//  CLinks_Connect
//
//  Created by arpit on 07/10/26.
//

import SwiftUI
import Supabase

@main
struct CLinks_ConnectApp: App {
    @StateObject private var authManager = AuthManager.shared

    var body: some Scene {
        WindowGroup {
            Group {
                if authManager.isLoading {
                    ProgressView()
                } else if authManager.session == nil {
                    LoginView()
                } else {
                    MainTabView()
                }
            }
            .onOpenURL { url in
                Task {
                    do {
                        try await SupabaseManager.shared.client.auth.session(
                            from: url
                        )
                        print("Magic link verified successfully!")
                    } catch {
                        print("Login error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}
