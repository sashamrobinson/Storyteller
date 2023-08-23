//
//  StoryTableViewCell.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-08-11.
//

import SwiftUI

struct StoryTableViewCell: View {
    @State private var displayExpandedForm: Bool = false
    @State private var presentingTableViewCell: Bool = false
    @GestureState private var isDragging: Bool = false
    var allowedToEdit: Bool

    var story: Story
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
//                    Text(story.dateCreated)
//                        .foregroundColor(Color.white.opacity(0.5))
//                        .font(.system(size: Constants.SUBTEXT_FONT_SIZE, weight: .regular))
                    Text(story.title)
                        .foregroundColor(Color.white)
                        .font(.system(size: Constants.REGULAR_FONT_SIZE, weight: .regular))
                        .lineLimit(displayExpandedForm ? 3 : 2)
                    Text("By " + story.author)
                        .foregroundColor(Color.white.opacity(0.5))
                        .font(.system(size: Constants.SUBTEXT_FONT_SIZE, weight: .regular))
                    
                }
                Spacer()
            }
            
            if displayExpandedForm {
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
        .frame(width: UIScreen.screenWidth - 40, height: displayExpandedForm ? 300 : 120)
        .onTapGesture {
            withAnimation {
                displayExpandedForm.toggle()
            }
        }
        .gesture(
            DragGesture()
                .updating($isDragging) { value, state, _ in
                    state = true
                }
                .onEnded { value in
                    if value.translation.width < 0 {
                        // Dragged to the right
                        print("test")
                        presentingTableViewCell.toggle()
                        
                    }
                }
        )
        .background(
            NavigationLink("", destination: StoryDetailView(story: story, allowedToEdit: allowedToEdit).navigationBarBackButtonHidden(true), isActive: $presentingTableViewCell)
                .opacity(0)
        )
        .navigationDestination(isPresented: $presentingTableViewCell) {
            StoryDetailView(story: story, allowedToEdit: allowedToEdit).navigationBarBackButtonHidden(true)

        }
    }
}

struct StoryTableViewCell_Previews: PreviewProvider {
    static var previews: some View {
        StoryTableViewCell(allowedToEdit: false, story: Story(storyId: "StoryID", author: "Sasha", authorUid: "UID", dateCreated: "Aug 11, 2023", title: "A Walk Through The Park", published: true, conversation: [], summary: "Summary", genres: [], numberOfLikes: 5, imageUrl: ""))
    }
}
