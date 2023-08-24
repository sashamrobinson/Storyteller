//
//  StoryDetailView.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-08-11.
//

import SwiftUI
import AVFoundation

struct StoryDetailView: View {
    
    // MARK: Variables
    @State var story: Story
    @State var userId: String? = nil
    
    // Dismiss actions
    @Environment(\.dismiss) var dismiss
    @GestureState private var isDragging: Bool = false


    // Speech
    @ObservedObject var speechUtterance = SpeechUtterance()
    @State var isSpeaking: Bool = false
    
    // Editing
    @State private var isEditing: Bool = false
    @State private var storyTitle = "My Story"
    @State private var storySummary = "Summary"
    @State private var showAlert: Bool = false
    @State var allowedToEdit: Bool
    
    // Likes
    @State private var likedStory: Bool = false
    @State private var likedStoryPending: Bool = false
    
    // Images
    @State var shouldShowImagePicker: Bool = false
    @State var imageUrl: String = ""
    @State var image: UIImage?
        
    var body: some View {
        ZStack {
            Color("#171717").ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack() {
                    VStack() {
                        HStack() {
                            Button(action: {
                                dismiss()
                            }) {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                            }
                            Spacer()
                            if allowedToEdit {
                                Button(action: {
                                    // Enable editing
                                    isEditing.toggle()
                                    if !isEditing {
                                        print(storyTitle)
                                        showAlert.toggle()
                                    }
                                    
                                }) {
                                    Image(systemName: isEditing ? "checkmark" : "pencil")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
                                }
                                .frame(width: 30, height: 30)
                            }
                        }
                        .padding()
                        
                        ZStack(alignment: .topTrailing) {
                            VStack {
                                // TODO: - Add if statement for if story image exists else
                                if let image = self.image {
                                    Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 250, height: 250, alignment: .center)
                                    .clipped()
                                    
                                } else if imageUrl.count > 1 {
                                    GeometryReader { geometry in
                                        AsyncImage(url: URL(string: imageUrl)) { image in
                                            image.resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: geometry.size.width, height: geometry.size.height)
                                            .clipped()

                                        }
                                        placeholder: {
                                            Color.clear.frame(width: 250, height: 250)
                                        }
                                    }
                                    .frame(width: 250, height: 250)

                                } else {
                                    Color.blue.frame(width: 250, height: 250)
                                }
                            }
                            .onTapGesture {
                                shouldShowImagePicker.toggle()
                            }
                            .opacity(isEditing ? 0.8 : 1.0)
                            .disabled(!isEditing)
                            
                            if !allowedToEdit {
                                ZStack {
                                    Circle()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(Color("#171717"))
                                    Image(systemName: likedStory ? "heart.fill" : "heart")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.white)
                                }
                                .onTapGesture {
                                    likedStoryPending = true
                                    withAnimation {
                                        likedStory.toggle()
                                    }
                                    
                                    guard userId != nil else {
                                        print("Cannot add or clear like. UserID is nil")
                                        return
                                    }
                                    FirebaseHelper.addOrClearLike(likedStory: likedStory, userId: userId!, storyId: story.storyId, genres: story.genres) {
                                        likedStoryPending = false
                                    }
                                }
                                .offset(x: 10, y: -10)
                                .disabled(likedStoryPending)
                            }
                        }
                        HStack() {
                            VStack(alignment: .leading, spacing: 0) {
                                Text(story.dateCreated)
                                    .foregroundColor(Color.gray)
                                    .font(.system(size: Constants.SUBTEXT_FONT_SIZE, weight: .regular))
                                    .padding(.leading)

                                
                                TextField(storyTitle, text: $storyTitle)
                                    .foregroundColor(isEditing ? Color.white.opacity(0.8) : Color.white)
                                    .font(.system(size: Constants.REGULAR_FONT_SIZE, weight: .regular))
                                    .padding(.bottom, 5)
                                    .padding(.leading)

                                    .disabled(!isEditing)

                                Text("By " + story.author)
                                    .foregroundColor(Color.gray)
                                    .font(.system(size: Constants.REGULAR_FONT_SIZE, weight: .regular))
                                    .padding(.leading)
                                
                                FlowLayout(story.genres) { genre in
                                    StoryGenreViewCell(genre: genre)
                                }
                                  .padding()
                                  .frame(height: 80)
                            }
                            .padding(.top)
                            Button(action: {
                                // TODO: - Refactor code to work with just one variable, issues with @Published wrapper
                                isSpeaking.toggle()
                                speechUtterance.toggleSpeaking()
                                if speechUtterance.speaker.isPaused {
                                    speechUtterance.resumeSpeaking()
                                }
                                
                                else if isSpeaking {
                                    speechUtterance.speak(text: storyTitle) {
                                        isSpeaking.toggle()
                                        speechUtterance.toggleSpeaking()
                                    }
                                } else {
                                    // Pause
                                    speechUtterance.pause()
                                }
                            }) {
                                Image(systemName: isSpeaking ? "pause.circle.fill" : "play.circle.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 30))
                            }
                            .padding()
                            .padding(.bottom)
                        }
                    }
//                    .gesture(
//                        DragGesture()
//                            .updating($isDragging) { value, state, _ in
//                                state = true
//                            }
//                            .onEnded { value in
//                                if value.translation.height > 0 {
//                                    // Dragged up
//                                    dismiss()
//
//                                }
//                            }
//                    )
                    
                    VStack(alignment: .leading) {
                        Text("Summary")
                            .foregroundColor(Color.white)
                            .font(.system(size: Constants.REGULAR_FONT_SIZE, weight: .regular))
                            .padding(.bottom, 5)
                        
                        TextField(storySummary, text: $storySummary, axis: .vertical)
                            .foregroundColor(isEditing ? Color.white.opacity(0.8) : Color.white)
                            .font(.system(size: Constants.SUBTEXT_FONT_SIZE, weight: .regular))
                            .padding(.bottom, 5)
                            .disabled(!isEditing)
                    }
                    .foregroundColor(isEditing ? Color.white.opacity(0.8) : Color.white)
                    .padding()
                    .background(.blue)
                    .cornerRadius(12.5)
                    .padding()
                    .ignoresSafeArea()
                }
                .onAppear() {
                    storyTitle = story.title
                    storySummary = story.summary
                    imageUrl = story.imageUrl
                    
                    if let id = LocalStorageHelper.retrieveUser() {
                        self.userId = id
                        FirebaseHelper.fetchUserById(id: id) { user in
                            guard user != nil else {
                                print("User is undefined cannot check for likes")
                                return
                            }
                            
                            if user!.likedStories.contains(story.storyId) {
                                self.likedStory = true
                            }
                        }
                    }
                }
                .padding(.top)
            }
            
//            Button(action: {
//                dismiss()
//            }) {
//                Image(systemName: "chevron.left")
//                    .foregroundColor(.white)
//                    .font(.system(size: 20))
//            }
//            .frame(width: 30, height: 30)
//            .position(x: 0, y: 0)
//            .padding()
//            .padding()
            
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Save your changes?"), primaryButton: .default(Text("Yes")) {
                
                // Update database
                FirebaseHelper.updateStory(storyId: story.storyId, newTitle: storyTitle, newSummary: storySummary, newImage: image) { error in
                    
                    // Handle success animation
                    
                    // Dismiss view to refresh
                    dismiss()
                }
            }, secondaryButton: .cancel(Text("No")) {
                
                // Reset text
                storyTitle = story.title
                storySummary = story.summary
                
            })
        }
        .fullScreenCover(isPresented: $shouldShowImagePicker) {
            ImagePicker(image: $image)
        }
    }
}

struct StoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        StoryDetailView(story: Story(storyId: "StoryID", author: "Sasha", authorUid: "UID", dateCreated: "Aug 11, 2023", title: "A Walk Through The Park", published: true, conversation: [], summary: "In our previous conversation, they recounted an incident during which they were walking to the store and encountered a charming brown cat crossing the street", genres: [.adventure, .funny, .love, .wow], numberOfLikes: 5, imageUrl: ""), allowedToEdit: true)
    }
}
