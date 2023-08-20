//
//  StoryTableViewCell.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-08-11.
//

import SwiftUI

struct StoryTableViewCell: View {
    var story: Story
    var body: some View {
        HStack {
            VStack {
                GeometryReader { geometry in
                    AsyncImage(url: URL(string: story.imageUrl)) { image in
                        image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()

                    }
                    placeholder: {
                        Color.clear.frame(width: 80, height: 80)
                    }
                }
                .frame(width: 80, height: 80)
            }

            VStack(alignment: .leading) {
                Text(story.dateCreated)
                    .foregroundColor(Color.white.opacity(0.5))
                    .font(.system(size: Constants.SUBTEXT_FONT_SIZE, weight: .regular))
                Text(story.title)
                    .foregroundColor(Color.white)
                    .font(.system(size: Constants.REGULAR_FONT_SIZE, weight: .regular))
            }
            Spacer()
        }
        .background(Color.clear)
        .padding(.bottom, 15)
    }
}

struct StoryTableViewCell_Previews: PreviewProvider {
    static var previews: some View {
        StoryTableViewCell(story: Story(storyId: "StoryID", author: "Sasha", authorUid: "UID", dateCreated: "Aug 11, 2023", title: "A Walk Through The Park", published: true, conversation: [], summary: "Summary", genres: [], numberOfLikes: 5, imageUrl: ""))
    }
}
