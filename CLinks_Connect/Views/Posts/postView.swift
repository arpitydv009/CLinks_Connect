//
//  postView.swift
//  CLinks_Connect
//
//  Created by arpit on 08/10/26.
//

import SwiftUI
import Supabase

struct postView: View {

    @State private var databasePosts: [postModel] = []
    @State private var isLoadingPosts = true
    @State private var loadingError: String?

    private func loadPosts() async {
        do {
            let service = PostService()
            let records = try await service.fetchPosts()
            let profiles = try await service.fetchProfiles()

            let profileNames = Dictionary(
                uniqueKeysWithValues: profiles.map {
                    ($0.id, $0.name)
                }
            )

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d MMM yyyy, h:mm a"

            databasePosts = records.map { record in
                postModel(
                    id: record.id.hashValue,
                    author: profileNames[record.author_id] ?? "Student",
                    content: record.content,
                    timestamp: ISO8601DateFormatter()
                        .date(from: record.created_at)
                        .map { dateFormatter.string(from: $0) } ?? record.created_at,
                    likes: 0,
                    comments: 0,
                    commentsList: [],
                    imageName: nil,
                    databaseID: record.id,
                    imageURL: record.image_url
                )
            }

            loadingError = nil

        } catch {
            loadingError = error.localizedDescription
            print("Failed to load posts:", error.localizedDescription)
        }

        isLoadingPosts = false
    }

    // MARK: - Next Class Logic

    private func getNextClass() -> timetableEntry? {
        let calendar = Calendar.current
        let now = Date()

        let currentDay = calendar.component(.weekday, from: now)
        let currentHour = calendar.component(.hour, from: now)
        let currentMinute = calendar.component(.minute, from: now)
        let currentTime = currentHour * 60 + currentMinute

        let dayName = getDayName(for: currentDay)

        let todayClasses = dummyTimetable.filter {
            $0.day == dayName
        }

        for classEntry in todayClasses {
            if let classStartTime = parseTime(classEntry.time) {
                if classStartTime > currentTime {
                    return classEntry
                }
            }
        }

        let nextDay = currentDay == 6 ? 2 : currentDay + 1

        if nextDay <= 6 {
            let nextDayName = getDayName(for: nextDay)

            if let nextClass = dummyTimetable.first(where: {
                $0.day == nextDayName
            }) {
                return nextClass
            }
        }

        return nil
    }

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

    // MARK: - Main View

    var body: some View {
        NavigationStack {
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

                    
                List {
                    Section {
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
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        
                        
                        }
                    
                        
                    // MARK: Next Class Section

                    Section {
                        if let nextClass = getNextClass() {
                            NextClassCard(
                                entry: nextClass,
                                timeRemaining: getTimeRemaining(for: nextClass)
                            )
                            .padding(.vertical, 8)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)

                        } else {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("All classes done for today!")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(.white)

                                Text("Enjoy your free time")
                                    .font(.system(size: 12))
                                    .foregroundStyle(.gray)
                            }
                            .padding(.vertical, 12)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                        }

                    } header: {
                        Text("Next Class")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                            .textCase(nil)
                    }

                    // MARK: Campus Feed

                    Section {
                        if isLoadingPosts {
                            HStack {
                                Spacer()
                                ProgressView()
                                    .tint(.cyan)
                                Spacer()
                            }
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)

                        } else if let loadingError {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Couldn't load posts")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(.white)

                                Text(loadingError)
                                    .font(.caption)
                                    .foregroundStyle(.gray)

                                Button("Try Again") {
                                    isLoadingPosts = true
                                    Task {
                                        await loadPosts()
                                    }
                                }
                                .foregroundStyle(.cyan)
                            }
                            .padding(.vertical, 8)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)

                        } else if databasePosts.isEmpty {
                            Text("No posts yet. Be the first to share something!")
                                .font(.system(size: 14))
                                .foregroundStyle(.gray)
                                .padding(.vertical, 16)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)

                        } else {
                            ForEach(databasePosts) { post in
                                PostCard(post: post)
                                    .listRowInsets(
                                        EdgeInsets(
                                            top: 8,
                                            leading: 16,
                                            bottom: 8,
                                            trailing: 16
                                        )
                                    )
                                    .listRowBackground(Color.clear)
                                    .listRowSeparator(.hidden)
                            }
                        }

                    } header: {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Posts")
                                        .font(.system(size: 28, weight: .bold))
                                        .foregroundStyle(
                                            LinearGradient(
                                                gradient: Gradient(colors: [
                                                    .cyan,
                                                    .blue
                                                ]),
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )

                                    Text("Your campus, all in one place")
                                        .font(.system(size: 14))
                                        .foregroundStyle(.gray)
                                }

                                Spacer()

                                NavigationLink {
                                    createPostView()
                                } label: {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 26))
                                        .foregroundStyle(.cyan)
                                }
                            }
                            .padding(.top, 8)
                            .padding(.bottom, 12)

                            Divider()
                                .background(Color.white.opacity(0.1))
                        }
                        .padding(.horizontal, 20)
                        .textCase(nil)
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background {
                    LinearGradient(
                        colors: [
                            Color(red: 0.05, green: 0.08, blue: 0.18),
                            Color(red: 0.02, green: 0.12, blue: 0.25),
                            Color(red: 0.0, green: 0.2, blue: 0.3)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .task{
                await loadPosts()
            }
        }
    }


// MARK: - Post Card

    struct PostCard: View {
        @State private var isLiked: Bool
        @State private var currentLikes: Int
        @State private var isUpdatingLike = false
        
        let post: postModel
        
        private let postService = PostService()
        
        init(post: postModel) {
            self.post = post
            _isLiked = State(initialValue: false)
            _currentLikes = State(initialValue: post.likes)
        }
        
        private func toggleLike() async {
            guard
                let postID = post.databaseID,
                let userID = SupabaseManager.shared.client.auth.currentSession?.user.id
            else {
                return
            }
            
            guard !isUpdatingLike else { return }
            isUpdatingLike = true
            
            do {
                if isLiked {
                    try await postService.removeLike(
                        postID: postID,
                        userID: userID
                    )
                    
                    isLiked = false
                    currentLikes = max(0, currentLikes - 1)
                    
                } else {
                    try await postService.addLike(
                        postID: postID,
                        userID: userID
                    )
                    
                    isLiked = true
                    currentLikes += 1
                }
                
            } catch {
                print("Like update failed:", error.localizedDescription)
            }
            
            isUpdatingLike = false
        }
        
        private func loadLikeStatus() async {
            guard
                let postID = post.databaseID,
                let userID = SupabaseManager.shared.client.auth.currentSession?.user.id
            else {
                return
            }
            
            do {
                let likes = try await postService.fetchLikes(postID: postID)
                
                currentLikes = likes.count
                isLiked = likes.contains { $0.user_id == userID }
                
            } catch {
                print("Failed to load likes:", error.localizedDescription)
            }
        }
        
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
                        .frame(width: 40, height: 40)
                        .overlay(
                            Text(post.author.prefix(1))
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(.white)
                        )
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(post.author)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.white)
                        
                        Text(formattedTimestamp(post.timestamp))
                            .font(.system(size: 12))
                            .foregroundStyle(.gray)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "ellipsis")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.gray)
                }
                
                // Post Content
                
                Text(post.content)
                    .font(.system(size: 14))
                    .foregroundStyle(.white)
                    .lineSpacing(2)
                                
                // Post Image

                if let imageURL = post.imageURL,
                   let url = URL(string: imageURL) {

                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .tint(.cyan)
                                .frame(maxWidth: .infinity)
                                .frame(height: 200)

                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                                .clipShape(RoundedRectangle(cornerRadius: 12))

                        case .failure:
                            Image(systemName: "photo")
                                .font(.largeTitle)
                                .foregroundStyle(.gray)
                                .frame(maxWidth: .infinity)
                                .frame(height: 120)

                        @unknown default:
                            EmptyView()
                        }
                    }
                }
                
                // Engagement Counts
                
                HStack(spacing: 16) {
                    HStack(spacing: 4) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(.red)
                        
                        Text("\(currentLikes)")
                            .font(.system(size: 12))
                            .foregroundStyle(.gray)
                            .contentTransition(.numericText())
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "bubble.right.fill")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(.cyan)
                        
                        Text("\(post.comments)")
                            .font(.system(size: 12))
                            .foregroundStyle(.gray)
                    }
                    
                    Spacer()
                }
                .padding(.top, 4)
                
                Divider()
                    .background(Color.white.opacity(0.1))
                
                // Action Buttons
                
                HStack(spacing: 12) {
                    Button {
                        Task {
                            await toggleLike()
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Image(
                                systemName: isLiked ? "heart.fill" : "heart"
                            )
                            .font(.system(size: 14, weight: .semibold))
                            
                            Text("Like")
                                .font(.system(size: 12, weight: .semibold))
                        }
                        .foregroundStyle(isLiked ? .red : .gray)
                        .scaleEffect(isLiked ? 1.03 : 1.0)
                        .animation(
                            .spring(response: 0.28, dampingFraction: 0.65),
                            value: isLiked
                        )
                    }
                    .buttonStyle(.borderless)
                    .disabled(isUpdatingLike)
                    
                    NavigationLink(
                        destination: postCommentsView(post: post)
                    ) {
                        HStack(spacing: 6) {
                            Image(systemName: "bubble.right")
                                .font(.system(size: 12, weight: .semibold))
                            
                            Text("Comment")
                                .font(.system(size: 10, weight: .semibold))
                        }
                        .padding(.horizontal, 10)
                        .foregroundStyle(.gray)
                    }
                    .buttonStyle(.borderless)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        Color(
                            red: 0.15,
                            green: 0.16,
                            blue: 0.22
                        )
                    )
                    .shadow(
                        color: Color.black.opacity(0.2),
                        radius: 8,
                        x: 0,
                        y: 4
                    )
            )
            .task {
                await loadLikeStatus()
            }
        }
        
        
        //MARK: - Formats Time
        private func formattedTimestamp(_ timestamp: String) -> String {
            let formatter = ISO8601DateFormatter()

            formatter.formatOptions = [
                .withInternetDateTime,
                .withFractionalSeconds
            ]

            let date = formatter.date(from: timestamp)
                ?? ISO8601DateFormatter().date(from: timestamp)

            guard let date else {
                return timestamp
            }

            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "d MMM yyyy, h:mm a"

            return displayFormatter.string(from: date)
        }
    }
}

#Preview {
    postView()
}
