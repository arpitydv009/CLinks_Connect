//
//  postCommentsView.swift
//  CLinks_Connect
//
//  Created by arpit on 09/10/26.
//

import SwiftUI
import Supabase

struct postCommentsView: View {
    let post: postModel

    @State private var comments: [PostService.CommentRecord] = []
    @State private var profiles: [ProfileRecord] = []
    @State private var commentText = ""
    
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    @FocusState private var isCommentFieldFocused: Bool

    var body: some View {
        VStack {
            List(comments) { comment in
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(
                            profiles.first(where: { $0.id == comment.author_id })?.name
                            ?? "Student"
                        )
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.white)

                        Spacer()
                        
                        Text(formattedTimestamp(comment.created_at))
                            .font(.system(size: 12))
                            .foregroundStyle(.gray)
                    }

                    Text(comment.content)
                        .foregroundStyle(.white)
                }
                .listRowBackground(Color.clear)
            }
            .listStyle(.plain)

            HStack {
                TextField("Add a comment...", text: $commentText)
                    .textFieldStyle(.plain)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.1))
                    )
                    .foregroundStyle(.white)
                    .focused($isCommentFieldFocused)

                Button("Send") {
                    addComment()
                }
                .foregroundStyle(.cyan)
            }
            .padding()
        }
        .task {
            await loadComments()
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.08, green: 0.09, blue: 0.15),
                    Color(red: 0.12, green: 0.13, blue: 0.2)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
        .alert(
            "Comment Error",
            isPresented: Binding(
                get: { errorMessage != nil },
                set: { if !$0 { errorMessage = nil } }
            )
        ) {
            Button("OK", role: .cancel) {
                errorMessage = nil
            }
        } message: {
            Text(errorMessage ?? "An unknown error occurred.")
        }
        .navigationTitle("Comments")
        .navigationBarTitleDisplayMode(.inline)
    }

    
    private func loadComments() async {
        guard let postID = post.databaseID else {
            errorMessage = "Could not identify this post."
            isLoading = false
            return
        }

        do {
            let service = PostService()
            comments = try await service.fetchComments(postID: postID)
            profiles = try await service.fetchProfiles()
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
    
    
    private func addComment() {
        let content = commentText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !content.isEmpty else { return }

        Task {
            do {
                guard let postID = post.databaseID else {
                    errorMessage = "Could not identify this post."
                    return
                }

                guard let authorID = SupabaseManager.shared.client.auth.currentUser?.id else {
                    errorMessage = "You must be logged in to comment."
                    return
                }

                let service = PostService()

                try await service.createComment(
                    postID: postID,
                    authorID: authorID,
                    content: content
                )

                commentText = ""
                isCommentFieldFocused = false

                await loadComments()

            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
    
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


