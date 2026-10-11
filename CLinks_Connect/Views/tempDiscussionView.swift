/*import SwiftUI

// MARK: - Discussion View

struct tempdiscussionView: View {
    @State private var discussionsList = dummyDiscussions

    var body: some View {
        List {
            ForEach(discussionsList.indices, id: \.self) { index in
                tempDiscussionCard(discussion: $discussionsList[index])
            }
        }
    }
}

// MARK: - Discussion Card

struct tempDiscussionCard: View {
    @Binding var discussion: discussionModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(discussion.title)
                .font(.headline)

            ForEach(discussion.replies) { reply in
                VStack(alignment: .leading, spacing: 4) {
                    Text(reply.content)

                    Text(reply.timestamp)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Text(discussion.timestamp)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 8)
    }
}
*/
