//
//  postCommentsView.swift
//  CLinks_Connect
//
//  Created by arpit on 09/10/26.
//

import SwiftUI

struct postCommentsView: View {
    let post: postModel

    @State private var comments: [commentModel]
    @State private var commentText = ""
    @FocusState private var isCommentFieldFocused: Bool

    init(post: postModel) {
        self.post = post
        _comments = State(initialValue: post.commentsList)
    }

    var body: some View {
        VStack {
            List(comments) { comment in
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(comment.author)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.white)

                        Spacer()

                        Text(comment.timestamp)
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
        .navigationTitle("Comments")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func addComment() {
        guard !commentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }

        let newComment = commentModel(
            id: comments.count + 1,
            author: "Arpit",
            content: commentText,
            timestamp: "Just now"
        )

        comments.append(newComment)
        commentText = ""
        isCommentFieldFocused = false
    }
}


