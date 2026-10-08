//
//  MainTabView.swift
//  CLinks_Connect
//
//  Created by arpit on 07/10/26.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            // Home Tab
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            // Posts Tab
            postView()
                .tabItem {
                    Label("Posts", systemImage: "doc.text.fill")
                }
            
            // Discussion Tab
            discussionView()
                .tabItem {
                    Label("Discussions", systemImage: "message.badge")
                }
            
            // Timetable Tab
            timetableView()
                .tabItem {
                    Label("Timetable", systemImage: "calendar.circle.fill")
                }
            
            // Profile Tab
            profileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle.fill")
                }
        }
        .tint(.cyan)
    }
}

#Preview {
    MainTabView()
}
