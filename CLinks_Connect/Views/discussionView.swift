import SwiftUI

struct discussionView: View {
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
                        ForEach(dummyDiscussions) { discussion in
                            NavigationLink {
                                discussionDetailView(discussion: discussion)
                            } label: {
                                discussionCard(
                                    title: discussion.title,
                                    author: discussion.author,
                                    timestamp: discussion.timestamp
                                )
                            }
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
                                    Text("Discussions")
                                        .font(.system(size: 28, weight: .bold))
                                        .foregroundStyle(
                                            LinearGradient(
                                                gradient: Gradient(colors: [.cyan, .blue]),
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )

                                    Text("Questions and conversations from campus")
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundStyle(.gray)
                                }

                                Spacer()

                                Image(systemName: "bubble.left.and.bubble.right.fill")
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

// MARK: - Discussion Card

struct discussionCard: View {
    let title: String
    let author: String
    let timestamp: String

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {

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
                        Text(author.prefix(1))
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.white)
                    )

                VStack(alignment: .leading, spacing: 2) {
                    Text(author)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)

                    Text(timestamp)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(.gray)
                }

            }

            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)
                .lineSpacing(2)
                .multilineTextAlignment(.leading)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(red: 0.15, green: 0.16, blue: 0.22))
                .shadow(
                    color: Color.black.opacity(0.2),
                    radius: 8,
                    x: 0,
                    y: 4
                )
        )
    }
}


// MARK: - Discussion Detail View

struct discussionDetailView: View {
    let discussion: discussionModel
    @State private var replies: [replyModel]
    @State private var replyText = ""
    @FocusState private var isReplyFieldFocused: Bool
    
    init(discussion: discussionModel) {
        self.discussion = discussion
        _replies = State(initialValue: discussion.replies)
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

            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
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
                                        Text(discussion.author.prefix(1))
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundStyle(.white)
                                    )
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(discussion.author)
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundStyle(.white)
                                    
                                    Text(discussion.timestamp)
                                        .font(.system(size: 12))
                                        .foregroundStyle(.gray)
                                }
                            }
                            
                            Text(discussion.title)
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(.white)
                                .lineSpacing(3)
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(red: 0.15, green: 0.16, blue: 0.22))
                        )
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Replies")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundStyle(.white)
                            
                            ForEach(replies) { reply in
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack(spacing: 10) {
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
                                                Text(reply.author.prefix(1))
                                                    .font(.system(size: 14, weight: .semibold))
                                                    .foregroundStyle(.white)
                                            )
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(reply.author)
                                                .font(.system(size: 14, weight: .semibold))
                                                .foregroundStyle(.white)
                                            
                                            Text(reply.timestamp)
                                                .font(.system(size: 12))
                                                .foregroundStyle(.gray)
                                        }
                                        
                                        Spacer()
                                    }
                                    
                                    Text(reply.content)
                                        .font(.system(size: 14))
                                        .foregroundStyle(.white)
                                        .lineSpacing(2)
                                }
                                .padding(14)
                                .background(
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(Color(red: 0.15, green: 0.16, blue: 0.22))
                                )
                            }
                        }
                    }
                    .padding(16)
                }
                HStack(spacing: 10) {
                    TextField("Write a reply...", text: $replyText)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(red: 0.15, green: 0.16, blue: 0.22))
                        )
                        .focused($isReplyFieldFocused)
                        .tint(.cyan)
                        .foregroundStyle(.white)

                    Button {
                        let trimmedText = replyText.trimmingCharacters(in: .whitespacesAndNewlines)

                        if !trimmedText.isEmpty {
                            let newReply = replyModel(
                                id: (replies.map { $0.id }.max() ?? 0) + 1,
                                content: trimmedText,
                                timestamp: "Just now",
                                author: "You"

                            )

                            replies.append(newReply)
                            replyText = ""
                            isReplyFieldFocused = false
                        }
                    } label: {
                        Image(systemName: "paperplane.fill")
                            .foregroundStyle(.cyan)
                            .frame(width: 40, height: 40)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(.ultraThinMaterial)
            }
            
           
            
        }
        .navigationTitle("Discussion")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    discussionView()
}
