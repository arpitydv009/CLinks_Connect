import SwiftUI
import Supabase
import PhotosUI

struct createPostView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var content = ""
    @State private var isPublishing = false
    @State private var errorMessage: String?

    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImage: UIImage?

    private let service = PostService()

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [
                        Color(red: 0.08, green: 0.09, blue: 0.15),
                        Color(red: 0.12, green: 0.13, blue: 0.2)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 22) {

                        // Post text
                        VStack(alignment: .leading, spacing: 10) {
                            Text("What's happening on campus?")
                                .font(.headline)
                                .foregroundStyle(.white)

                            TextEditor(text: $content)
                                .scrollContentBackground(.hidden)
                                .padding(8)
                                .frame(height: 130)
                                .background(Color.white.opacity(0.07))
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                                .foregroundStyle(.white)
                        }

                        // Image attachment
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Add to your post")
                                .font(.headline)
                                .foregroundStyle(.white)

                            PhotosPicker(
                                selection: $selectedPhoto,
                                matching: .images
                            ) {
                                Group {
                                    if let selectedImage {
                                        Image(uiImage: selectedImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 220)
                                            .overlay(alignment: .bottomTrailing) {
                                                Image(systemName: "arrow.triangle.2.circlepath")
                                                    .font(.title3.weight(.semibold))
                                                    .foregroundStyle(.white)
                                                    .padding(12)
                                                    .background(.black.opacity(0.65))
                                                    .clipShape(Circle())
                                                    .padding(12)
                                            }
                                    } else {
                                        VStack(spacing: 14) {
                                            Image(
                                                systemName: "photo.on.rectangle.angled"
                                            )
                                            .font(.system(size: 42))
                                            .foregroundStyle(.cyan)

                                            Text("Add Photos")
                                                .font(.system(
                                                    size: 19,
                                                    weight: .semibold
                                                ))
                                                .foregroundStyle(.white)

                                            Text("Share moments from campus")
                                                .font(.system(size: 13))
                                                .foregroundStyle(.gray)
                                        }
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 200)
                                    }
                                }
                                .background(Color.white.opacity(0.05))
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 20)
                                        .strokeBorder(
                                            Color.cyan.opacity(0.35),
                                            style: StrokeStyle(
                                                lineWidth: 1,
                                                dash: [6]
                                            )
                                        )
                                }
                            }
                            .buttonStyle(.plain)

                            if selectedImage != nil {
                                Button(role: .destructive) {
                                    selectedPhoto = nil
                                    selectedImage = nil
                                } label: {
                                    Label("Remove Photo", systemImage: "trash")
                                        .font(.subheadline)
                                }
                            }
                        }

                        // Error message
                        if let errorMessage {
                            Text(errorMessage)
                                .foregroundStyle(.red)
                                .font(.caption)
                        }

                        // Publish
                        Button {
                            Task {
                                await publishPost()
                            }
                        } label: {
                            HStack(spacing: 10) {
                                if isPublishing {
                                    ProgressView()
                                        .tint(.white)

                                    Text("Publishing...")
                                        .fontWeight(.semibold)
                                } else {
                                    Image(systemName: "paperplane.fill")

                                    Text("Publish Post")
                                        .fontWeight(.semibold)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 17)
                            .background(
                                LinearGradient(
                                    colors: [.cyan, .blue],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                        .disabled(
                            content.trimmingCharacters(
                                in: .whitespacesAndNewlines
                            ).isEmpty || isPublishing
                        )
                        .opacity(
                            content.trimmingCharacters(
                                in: .whitespacesAndNewlines
                            ).isEmpty || isPublishing ? 0.6 : 1
                        )
                    }
                    .padding(20)
                }
            }
            .navigationTitle("New Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(.cyan)
                }
            }
            .onChange(of: selectedPhoto) { _, newPhoto in
                Task {
                    guard let newPhoto else {
                        selectedImage = nil
                        return
                    }

                    do {
                        if let data = try await newPhoto.loadTransferable(
                            type: Data.self
                        ), let image = UIImage(data: data) {
                            selectedImage = image
                        }
                    } catch {
                        errorMessage = "Couldn't load the selected photo."
                    }
                }
            }
        }
    }

    private func publishPost() async {
        guard let userID = SupabaseManager.shared.client.auth.currentSession?.user.id else {
            errorMessage = "Please sign in again before posting."
            return
        }

        isPublishing = true
        errorMessage = nil

        do {
            var imageData: Data?

            if let selectedImage {
                guard let data = selectedImage.jpegData(compressionQuality: 0.8) else {
                    errorMessage = "Couldn't process the selected image."
                    isPublishing = false
                    return
                }

                imageData = data
            }

            try await service.createPost(
                content: content.trimmingCharacters(
                    in: .whitespacesAndNewlines
                ),
                authorID: userID,
                imageData: imageData
            )

            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }

        isPublishing = false
    }
}

#Preview {
    createPostView()
}
