import Foundation
import Supabase

struct PostRecord: Decodable, Identifiable {
    let id: UUID
    let author_id: UUID
    let content: String
    let created_at: String
    let image_url: String?
}

struct ProfileRecord: Decodable {
    let id: UUID
    let name: String
}

struct PostService {
    let client = SupabaseManager.shared.client
    // MARK: - Fetch Profiles

    func fetchProfiles() async throws -> [ProfileRecord] {
        let profiles: [ProfileRecord] = try await client
            .from("profiles")
            .select()
            .execute()
            .value

        return profiles
    }

    // MARK: -  Posts
    func fetchPosts() async throws -> [PostRecord] {
        let posts: [PostRecord] = try await client
            .from("posts")
            .select()
            .order("created_at", ascending: false)
            .execute()
            .value

        return posts
    }
    
    private struct NewPost: Encodable {
        let author_id: UUID
        let content: String
        let image_url: String?
    }

    func createPost(
        content: String,
        authorID: UUID,
        imageData: Data? = nil
    ) async throws {

        var imageURL: String?

        // Upload the image if one was selected.
        if let imageData {
            let imagePath =
                "\(authorID.uuidString)/\(UUID().uuidString).jpg"

            try await client.storage
                .from("post-images")
                .upload(
                    imagePath,
                    data: imageData,
                    options: FileOptions(
                        contentType: "image/jpeg",
                        upsert: false
                    )
                )

            // Obtain the URL that other devices can access.
            let publicURL = try client.storage
                .from("post-images")
                .getPublicURL(path: imagePath)

            imageURL = publicURL.absoluteString
        }

        // Save the post and its image URL together.
        let newPost = NewPost(
            author_id: authorID,
            content: content,
            image_url: imageURL
        )

        try await client
            .from("posts")
            .insert(newPost)
            .execute()
    }

    
    // MARK: - Likes

    struct LikeRecord: Decodable {
        let post_id: UUID
        let user_id: UUID
    }

    private struct NewLike: Encodable {
        let post_id: UUID
        let user_id: UUID
    }

    func fetchLikes(postID: UUID) async throws -> [LikeRecord] {
        let likes: [LikeRecord] = try await client
            .from("likes")
            .select()
            .eq("post_id", value: postID.uuidString)
            .execute()
            .value

        return likes
    }

    func addLike(postID: UUID, userID: UUID) async throws {
        let like = NewLike(
            post_id: postID,
            user_id: userID
        )

        try await client
            .from("likes")
            .insert(like)
            .execute()
    }

    func removeLike(postID: UUID, userID: UUID) async throws {
        try await client
            .from("likes")
            .delete()
            .eq("post_id", value: postID.uuidString)
            .eq("user_id", value: userID.uuidString)
            .execute()
    }
    
    
    // MARK: - Comments
    
    struct CommentRecord: Decodable, Identifiable{
        let id: UUID
        let post_id: UUID
        let author_id: UUID
        let content: String
        let created_at: String
        let parent_comment_id: UUID?
        
    }
    
    struct NewComment: Encodable {
        let post_id: UUID
        let author_id: UUID
        let content: String
        let parent_comment_id: UUID?
    }
    
    func fetchComments(postID: UUID) async throws -> [CommentRecord] {
        try await client
            .from("comments")
            .select()
            .eq("post_id", value: postID)
            .order("created_at", ascending: true)
            .execute()
            .value
    }
    
    func createComment(
        postID: UUID,
        authorID: UUID,
        content: String,
        parentCommentID: UUID? = nil
    ) async throws {
        let newComment = NewComment(
            post_id: postID,
            author_id: authorID,
            content: content,
            parent_comment_id: parentCommentID
        )

        try await client
            .from("comments")
            .insert(newComment)
            .execute()
    }
}
