//
//  ContentView.swift
//  CLinks_Connect
//
//  Created by arpit on 07/10/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        MainTabView()
    }
}

#Preview {
    ContentView()
}
/*
// MARK: - Home View
struct HomeView: View {
    let days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Dark Gradient Background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.08, green: 0.09, blue: 0.15),
                        Color(red: 0.12, green: 0.13, blue: 0.2)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 24) {
                        // Header Section
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("NSUT Connect")
                                        .font(.system(size: 28, weight: .bold))
                                        .foregroundStyle(
                                            LinearGradient(
                                                gradient: Gradient(colors: [.cyan, .blue]),
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                    Text("Welcome back")
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundStyle(.gray)
                                }
                               
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        
                        // Next Class Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Next Class")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 20)
                            
                            if let nextClass = getNextClass() {
                                NextClassCard(entry: nextClass, timeRemaining: getTimeRemaining(for: nextClass))
                                    .padding(.horizontal, 20)
                            } else {
                                VStack(spacing: 12) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 32, weight: .light))
                                        .foregroundStyle(.gray)
                                    
                                    Text("All classes done for today!")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundStyle(.white)
                                    
                                    Text("Enjoy your free time")
                                        .font(.system(size: 12, weight: .regular))
                                        .foregroundStyle(.gray)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(20)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color(red: 0.15, green: 0.16, blue: 0.22))
                                )
                                .padding(.horizontal, 20)
                            }
                        }
                        
                        // Latest Posts Section
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Latest Updates")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(.white)
                                Spacer()
                                NavigationLink(destination: postView()) {
                                    Text("View All")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundStyle(.cyan)
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            VStack(spacing: 12) {
                                ForEach(dummyPosts.prefix(5), id: \.id) { post in
                                    latestPostCard(post: post)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        Spacer(minLength: 20)
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 80)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    */
    // Helper function to get next class
    private func getNextClass() -> timetableEntry? {
        let calendar = Calendar.current
        let now = Date()
        let currentDay = calendar.component(.weekday, from: now)
        let currentHour = calendar.component(.hour, from: now)
        let currentMinute = calendar.component(.minute, from: now)
        let currentTime = currentHour * 60 + currentMinute
        
        let dayName = getDayName(for: currentDay)
        
        // Get classes for today first
        let todayClasses = dummyTimetable.filter { $0.day == dayName }
        
        for classEntry in todayClasses {
            if let classStartTime = parseTime(classEntry.time) {
                if classStartTime > currentTime {
                    return classEntry
                }
            }
        }
        
        // If no class today, find first class of next available weekday
        let nextDay = currentDay == 6 ? 2 : currentDay + 1
        if nextDay <= 6 {
            let nextDayName = getDayName(for: nextDay)
            if let nextClass = dummyTimetable.first(where: { $0.day == nextDayName }) {
                return nextClass
            }
        }
        
        return nil
    }
    
    // Helper function to get time remaining
    private func getTimeRemaining(for entry: timetableEntry) -> String {
        let calendar = Calendar.current
        let now = Date()
        let currentHour = calendar.component(.hour, from: now)
        let currentMinute = calendar.component(.minute, from: now)
        let currentTime = currentHour * 60 + currentMinute
        
        if let classStartTime = parseTime(entry.time) {
            let remaining = classStartTime - currentTime
            if remaining > 0 {
                return "in \(remaining) mins"
            }
        }
        return ""
    }
    
    // Helper function to parse time from "HH:MM - HH:MM" format
    private func parseTime(_ timeString: String) -> Int? {
        let components = timeString.split(separator: " ")
        if let startTime = components.first {
            let timeParts = startTime.split(separator: ":")
            if timeParts.count == 2,
               let hour = Int(timeParts[0]),
               let minute = Int(timeParts[1]) {
                return hour * 60 + minute
            }
        }
        return nil
    }
    
    // Helper function to get day name from weekday number
    private func getDayName(for weekday: Int) -> String {
        switch weekday {
        case 2: return "Monday"
        case 3: return "Tuesday"
        case 4: return "Wednesday"
        case 5: return "Thursday"
        case 6: return "Friday"
        default: return ""
        }
    }


// MARK: - Latest Post Card
struct latestPostCard: View {
    let post: postModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Author Header
            HStack(spacing: 12) {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [.cyan, .blue]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 32, height: 32)
                    .overlay(
                        Text(post.author.prefix(1))
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.white)
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(post.author)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.white)
                    Text(post.timestamp)
                        .font(.system(size: 11, weight: .regular))
                        .foregroundStyle(.gray)
                }
                
                Spacer()
            }
            
            // Post Content
            Text(post.content)
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(.white)
                .lineLimit(2)
            
            // Engagement
            HStack(spacing: 12) {
                HStack(spacing: 4) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(.red)
                    Text("\(post.likes)")
                        .font(.system(size: 11, weight: .regular))
                        .foregroundStyle(.gray)
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "bubble.right.fill")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(.cyan)
                    Text("\(post.comments)")
                        .font(.system(size: 11, weight: .regular))
                        .foregroundStyle(.gray)
                }
                
                Spacer()
            }
            .padding(.top, 4)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(red: 0.15, green: 0.16, blue: 0.22))
                .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 2)
        )
    }
}

// MARK: - Next Class Card
struct NextClassCard: View {
    let entry: timetableEntry
    let timeRemaining: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "book.circle.fill")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [.cyan, .blue]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(entry.subject)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                    
                    HStack(spacing: 12) {
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                                .font(.system(size: 12, weight: .regular))
                            Text(entry.time)
                                .font(.system(size: 12, weight: .regular))
                        }
                        
                        HStack(spacing: 4) {
                            Image(systemName: "location")
                                .font(.system(size: 12, weight: .regular))
                            Text(entry.room)
                                .font(.system(size: 12, weight: .regular))
                        }
                    }
                    .foregroundStyle(.gray)
                    
                    if !timeRemaining.isEmpty {
                        Text(timeRemaining)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(.cyan)
                            .padding(.top, 4)
                    }
                }
                
                Spacer()
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.15, green: 0.25, blue: 0.35),
                            Color(red: 0.12, green: 0.18, blue: 0.28)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: Color.cyan.opacity(0.15), radius: 12, x: 0, y: 4)
        )
    }
}

// MARK: - Section Card
struct SectionCard: View {
    let icon: String
    let title: String
    let description: String
    let backgroundColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 48, height: 48)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                backgroundColor,
                                backgroundColor.opacity(0.7)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(14)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                    Text(description)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(.gray)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.gray)
                    .padding(.trailing, 4)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(red: 0.15, green: 0.16, blue: 0.22))
                .shadow(color: Color.black.opacity(0.3), radius: 12, x: 0, y: 4)
        )
    }
}

// MARK: - Quick Access Card
struct QuickAccessCard: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(.white)
                .frame(height: 40)
            
            Text(title)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.white)
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    color.opacity(0.2),
                    color.opacity(0.1)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .border(color.opacity(0.3), width: 1)
        .cornerRadius(16)
    }
}

// MARK: - Modern Section Card
struct ModernSectionCard: View {
    let icon: String
    let title: String
    let description: String
    let backgroundColor: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            backgroundColor,
                            backgroundColor.opacity(0.6)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
                Text(description)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.cyan)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(red: 0.15, green: 0.16, blue: 0.22))
                .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
        )
    }
}

// MARK: - Placeholder View
struct PlaceholderView: View {
    let title: String
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Dark background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.08, green: 0.09, blue: 0.15),
                        Color(red: 0.12, green: 0.13, blue: 0.2)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 12) {
                    Spacer()
                    
                    Image(systemName: "square.dashed")
                        .font(.system(size: 48, weight: .light))
                        .foregroundStyle(.gray)
                    
                    Text(title)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.white)
                    
                    Text("Coming soon")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(.gray)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

