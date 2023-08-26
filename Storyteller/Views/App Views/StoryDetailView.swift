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

    // Speech
    @ObservedObject var speechUtterance = SpeechUtterance()
    @State var isSpeaking: Bool = false
    
    // Editing
    @State private var isEditing: Bool = false
    @State private var storyTitle = "My Story"
    @State private var storySummary = "Summary"
    @State private var shouldPublish: Bool = false
    @State private var canSubmitUpdatedStory: Bool = false
    @State var allowedToEdit: Bool
    
    // Likes
    @State private var likedStory: Bool = false
    @State private var likedStoryPending: Bool = false
    
    // Images
    @State var shouldShowImagePicker: Bool = false
    @State var imageUrl: String = ""
    @State var image: UIImage?
    
    // Modal pop up
    @State var isShowing: Bool = false
    @State private var showingPublish: Bool = true
    
    // Animations
    @State private var currentHeight: CGFloat = 300
    @State private var isDragging: Bool = false
    let minHeight: CGFloat = 300
    let maxHeight: CGFloat = 300
        
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
                                        withAnimation(.easeInOut) {
                                            isShowing.toggle()
                                        }
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
                                    .cornerRadius(12.5)
                                    
                                } else if imageUrl.count > 1 {
                                    GeometryReader { geometry in
                                        AsyncImage(url: URL(string: imageUrl)) { image in
                                            image.resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: geometry.size.width, height: geometry.size.height)
                                            .clipped()
                                            .cornerRadius(12.5)

                                        }
                                        placeholder: {
                                            Color.clear
                                                .frame(width: 250, height: 250)
                                                .cornerRadius(12.5)

                                        }
                                    }
                                    .frame(width: 250, height: 250)

                                } else {
                                    Color.blue.frame(width: 250, height: 250)
                                        .cornerRadius(12.5)

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
                                isSpeaking.toggle()
                                speechUtterance.toggleSpeaking()
                                if speechUtterance.speaker.isPaused {
                                    speechUtterance.resumeSpeaking()
                                } else if isSpeaking {
                                    speechUtterance.speak(text: storySummary) {
                                        isSpeaking.toggle()
                                        speechUtterance.toggleSpeaking()
                                    }
                                } else {
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
                    .background(Color("#292929"))
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
            
            ZStack(alignment: .bottom) {
                if isShowing {
                    Color.black
                        .opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture {
                            isShowing = false
                        }
                    
                    VStack(alignment: .center) {
                        Capsule()
                            .frame(width: 40, height: 6)
                            .foregroundColor(.white)
                            .background(.white.opacity(0.001))
                            .gesture(dragGesture)
                        
                        if showingPublish {
                            Text("Would you like to publish this story? Anyone will be able to read and listen to it")
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .font(.system(size: Constants.REGULAR_FONT_SIZE, weight: .regular))
                                .padding()
                                .padding()
                                .padding()
                            HStack(spacing: 30) {
                                Button("No") {
                                    shouldPublish = false
                                    withAnimation(.easeInOut(duration: 1)) {
                                        showingPublish = false
                                    }
                                }
                                .padding()
                                .frame(width: UIScreen.screenWidth / 3)
                                .font(.system(size: Constants.REGULAR_FONT_SIZE, weight: .regular))
                                .foregroundColor(.white)
                                .background(Color("#292929"))
                                .cornerRadius(12.5)
                                .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 2)

                                Button("Yes") {
                                    shouldPublish = true
                                    withAnimation(.easeInOut(duration: 1)) {
                                        showingPublish = false
                                    }
                                }
                                .padding()
                                .frame(width: UIScreen.screenWidth / 3)
                                .font(.system(size: Constants.REGULAR_FONT_SIZE, weight: .regular))
                                .foregroundColor(.white)
                                .background(Color("#292929"))
                                .cornerRadius(12.5)
                                .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 2)

                            }
                        } else {
                            Text("Are you finished editing your story? You can always come back later")
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .font(.system(size: Constants.REGULAR_FONT_SIZE, weight: .regular))
                                .padding()
                                .padding()
                                .padding()
                            
                            HStack(spacing: 30) {
                                Button("No") {
                                    storyTitle = story.title
                                    storySummary = story.summary
                                    
                                    withAnimation(.easeInOut) {
                                        isShowing = false
                                    }
                                }
                                .padding()
                                .frame(width: UIScreen.screenWidth / 3)
                                .font(.system(size: Constants.REGULAR_FONT_SIZE, weight: .regular))
                                .foregroundColor(.white)
                                .background(Color("#292929"))
                                .cornerRadius(12.5)
                                .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 2)

                                Button("Yes") {
                                    canSubmitUpdatedStory = true
                                    FirebaseHelper.updateStory(storyId: story.storyId, newTitle: storyTitle, newSummary: storySummary, newImage: image, publishedBool: shouldPublish) { error in
                    
                                        // Handle success animation
                    
                                        // Dismiss view to refresh
                                        dismiss()
                                    }
                                    withAnimation(.easeInOut) {
                                        isShowing = false
                                    }
                                }
                                .padding()
                                .frame(width: UIScreen.screenWidth / 3)
                                .font(.system(size: Constants.REGULAR_FONT_SIZE, weight: .regular))
                                .foregroundColor(.white)
                                .background(Color("#292929"))
                                .cornerRadius(12.5)
                                .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 2)
                            }
                        }
                    }
                    .frame(height: currentHeight)
                    .frame(maxWidth: .infinity)
                    .background(Color("#292929"))
                    .cornerRadius(12.5)
                    .transition(.move(edge: .bottom))
                    .animation(isDragging ? nil : .easeInOut(duration: 0.45))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea()
        }
        .fullScreenCover(isPresented: $shouldShowImagePicker) {
            ImagePicker(image: $image)
        }
//        .alert(isPresented: $showAlert) {
//            Alert(title: Text("Save your changes?"), primaryButton: .default(Text("Yes")) {
//
//                // Update database
//                FirebaseHelper.updateStory(storyId: story.storyId, newTitle: storyTitle, newSummary: storySummary, newImage: image) { error in
//
//                    // Handle success animation
//
//                    // Dismiss view to refresh
//                    dismiss()
//                }
//            }, secondaryButton: .cancel(Text("No")) {
//
//                // Reset text
//                storyTitle = story.title
//                storySummary = story.summary
//
//            })
//        }
    }
    
    @State private var prevDragTranslation = CGSize.zero
    
    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged { val in
                if !isDragging {
                    isDragging = true
                }
                
                let dragAmount = val.translation.height - prevDragTranslation.height
                if currentHeight > maxHeight || currentHeight < minHeight {
                    currentHeight -= dragAmount / 6
                } else {
                    currentHeight -= dragAmount
                }
                
                prevDragTranslation = val.translation
            }
            .onEnded { val in
                prevDragTranslation = .zero
                isDragging = false
                if currentHeight > maxHeight {
                    currentHeight = maxHeight
                } else if currentHeight < minHeight {
                    currentHeight = minHeight
                }
            }
    }
}

struct StoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        StoryDetailView(story: Story(storyId: "StoryID", author: "Sasha", authorUid: "UID", dateCreated: "Aug 11, 2023", title: "A Walk Through The Park", published: true, conversation: [], summary: "In our previous conversation, they recounted an incident during which they were walking to the store and encountered a charming brown cat crossing the street", genres: [.adventure, .funny, .love, .wow], numberOfLikes: 5, imageUrl: ""), allowedToEdit: true)
    }
}
