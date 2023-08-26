//
//  StoryTableViewCell.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-08-11.
//

import SwiftUI

struct StoryTableViewCell: View {
    @State private var presentingTableViewCell: Bool = false
    var allowedToEdit: Bool
    var story: Story
    @State var isExpanded: Bool = false
    var body: some View {
        VStack {
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
                            Image(systemName: "photo.on.rectangle.angled")
                                .frame(width: 80, height: 80)
                                .foregroundColor(.white)
                        }
                    }
                    .frame(width: 80, height: 80)
                    .padding(.top)
                    .padding(.leading)
                    .padding(.bottom)
                    
                }
                VStack(alignment: .leading) {
                    Text(story.title)
                        .foregroundColor(Color.white)
                        .font(.system(size: Constants.REGULAR_FONT_SIZE, weight: .regular))
                        .lineLimit(isExpanded ? 3 : 2)
                    Text("By " + story.author)
                        .foregroundColor(Color.white.opacity(0.5))
                        .font(.system(size: Constants.SUBTEXT_FONT_SIZE, weight: .regular))
                    
                }
                Spacer()
            }
            
            if isExpanded {
                VStack(alignment: .leading) {
                    Text("Summary")
                        .foregroundColor(Color.white)
                        .font(.system(size: Constants.REGULAR_FONT_SIZE, weight: .regular))
                        .padding(.bottom, 5)
                    
                    Text(story.summary)
                        .foregroundColor(.white)
                        .font(.system(size: Constants.SUBTEXT_FONT_SIZE, weight: .regular))
                        .padding(.bottom, 5)
                        
                }
                .padding()
            }
        }
        .background(Color("#292929"))
        .cornerRadius(12.5)
        .frame(width: UIScreen.screenWidth - 40, height: isExpanded ? 300 : 120)
        .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 2)
        .onTapGesture {
            if isExpanded {
                presentingTableViewCell.toggle()
            } else {
                withAnimation {
                    isExpanded = true
                }
            }
        }
        
        .background(
            EmptyView()
                .fullScreenCover(isPresented: $presentingTableViewCell) {
                    NavigationView {
                        StoryDetailView(story: story, allowedToEdit: allowedToEdit)
                            .navigationBarBackButtonHidden(true)
                    }
                    .navigationViewStyle(.stack)
                }
        )
    }
}

struct StoryTableViewCell_Previews: PreviewProvider {
    static var previews: some View {
        StoryTableViewCell(allowedToEdit: false, story: Story(storyId: "StoryID", author: "Sasha", authorUid: "UID", dateCreated: "Aug 11, 2023", title: "A Walk Through The Park", published: true, conversation: [], summary: "Summary", genres: [], numberOfLikes: 5, imageUrl: ""))
    }
}
