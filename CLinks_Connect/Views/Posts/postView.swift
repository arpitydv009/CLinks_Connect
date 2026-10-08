//
//  postView.swift
//  CLinks_Connect
//
//  Created by arpit on 08/10/26.
//

import SwiftUI

struct postView: View {
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

                List {
                    Section {
                        ForEach(dummyPosts, id: \.id) { post in
                            PostCard(
                                post: post
                            )
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
                    } header: {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Posts")
                                        .font(.system(size: 28, weight: .bold))
                                        .foregroundStyle(
                                            LinearGradient(
                                                gradient: Gradient(colors: [.cyan, .blue]),
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )

                                    Text("Posts from campus")
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundStyle(.gray)
                                }

                                Spacer()

                                Image(systemName: "slider.horizontal.3")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundStyle(.cyan)
                                    .frame(width: 44, height: 44)
                                    .background(
                                        Circle()
                                            .fill(Color.cyan.opacity(0.1))
                                    )
                            }
                            .padding(.top, 8)
                            .padding(.bottom, 12)

                            Divider()
                                .background(Color.white.opacity(0.1))
                        }
                        .padding(.horizontal, 20)
                        .textCase(nil)
                        .listRowBackground(Color.clear)
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Post Card

struct PostCard: View {
    @State private var isLiked: Bool
    @State private var currentLikes: Int

    let post: postModel

    init(post: postModel) {
        self.post = post
        _isLiked = State(initialValue: false)
        _currentLikes = State(initialValue: post.likes)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            // Author Header
            HStack(spacing: 12) {

                // Avatar Circle
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

                    Text(post.timestamp)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(.gray)
                }

                Spacer()

                Image(systemName: "ellipsis")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.gray)
            }

            // Post Content
            Text(post.content)
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(.white)
                .lineSpacing(2)

            // Post Image (if exists)
            if let imageName = post.imageName {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .cornerRadius(12)
                    .clipped()
            }

            // Engagement Stats
            HStack(spacing: 16) {
                HStack(spacing: 4) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.red)

                    Text("\(currentLikes)")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(.gray)
                        .contentTransition(.numericText())
                }

                HStack(spacing: 4) {
                    Image(systemName: "bubble.right.fill")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.cyan)

                    Text("\(post.comments)")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(.gray)
                }

                Spacer()
            }
            .padding(.top, 4)

            Divider()
                .background(Color.white.opacity(0.1))

            // Action Buttons
            HStack(spacing: 12) {

                // Like Button
                Button(action: {
                    withAnimation(
                        .spring(
                            response: 0.28,
                            dampingFraction: 0.65
                        )
                    ) {
                        isLiked.toggle()
                        currentLikes += isLiked ? 1 : -1
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(
                            systemName: isLiked
                                ? "heart.fill"
                                : "heart"
                        )
                        .font(.system(size: 14, weight: .semibold))

                        Text("Like")
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .foregroundStyle(isLiked ? .red : .gray)
                    .scaleEffect(isLiked ? 1.03 : 1.0)
                    .animation(
                        .spring(
                            response: 0.28,
                            dampingFraction: 0.65
                        ),
                        value: isLiked
                    )
                }
                .buttonStyle(.borderless)

                // Comment Button
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
    }
}

#Preview {
    postView()
}
