//
//  StoryDetailView.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-08-11.
//

import SwiftUI
import AVFoundation

struct StoryDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var speechUtterance = SpeechUtterance()
    @State var story: Story
    @State var text: String = "In our previous conversation, they recounted an incident during which they were walking to the store and encountered a charming brown cat crossing the street"
    @State var isSpeaking: Bool = false
    @State private var isEditing: Bool = false
    @State private var storyTitle = "My Story"
    @State private var showAlert: Bool = false
    
    var body: some View {
        ZStack {
            Color("#171717").ignoresSafeArea()
            VStack() {
                VStack() {
                    Color.blue.frame(width: 250, height: 250)
                    HStack {
                        VStack(alignment: .leading) {
                            Text(story.dateCreated)
                                .foregroundColor(Color.gray)
                                .font(.system(size: Constants.SUBTEXT_FONT_SIZE, weight: .regular))
                            
                            TextField(storyTitle, text: $storyTitle)
                                .foregroundColor(isEditing ? Color.white.opacity(0.8) : Color.white)
                                .font(.system(size: Constants.REGULAR_FONT_SIZE, weight: .regular))
                                .padding(.bottom, 5)
                                .disabled(!isEditing)

                            Text("By " + story.author)
                                .foregroundColor(Color.gray)
                                .font(.system(size: Constants.REGULAR_FONT_SIZE, weight: .regular))
                            
                            if !story.genres.isEmpty {
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 30), count: 2), alignment: .leading) {
                                    ForEach(story.genres) { genre in
                                        StoryGenreViewCell(genre: genre)

                                    }
                                }
                            }
                        }
                        .padding()
                        Spacer()
                        Button(action: {
                            // TODO: - Refactor code to work with just one variable, issues with @Published wrapper
                            isSpeaking.toggle()
                            speechUtterance.toggleSpeaking()
                            if speechUtterance.speaker.isPaused {
                                speechUtterance.resumeSpeaking()
                            }
                            
                            else if isSpeaking {
                                speechUtterance.speak(text: text) {
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
                                .font(.system(size: 50))
                        }
                        .padding()
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(Color("#171717"))
                        .shadow(color: .black, radius: 5, x: 0, y: 2)

                )
                ScrollView(showsIndicators: false) {
                    VStack {
                        Text(story.summary)
                    }
                    .foregroundColor(isEditing ? Color.white.opacity(0.8) : Color.white)
                }
                .padding()
                .background(.blue)
                .cornerRadius(12.5)
                .padding()
                .ignoresSafeArea()
            }
            .onAppear() {
                storyTitle = story.title
            }
            .padding(.top)
            
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "chevron.down")
                    .foregroundColor(.white)
                    .font(.system(size: 20))
            }
            .frame(width: 30, height: 30)
            .position(x: 0, y: 0)
            .padding()
            .padding()
            
            Button(action: {
                // Enable editing
                isEditing.toggle()
                // TODO: - Save alert
                if !isEditing {
                    showAlert.toggle()
                }
                
            }) {
                Image(systemName: isEditing ? "pencil.slash" : "pencil")
                    .foregroundColor(.white)
                    .font(.system(size: 20))
            }
            .frame(width: 30, height: 30)
            .position(x: UIScreen.screenWidth - 60, y: 0)
            .padding()
            .padding()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Save your changes?"), primaryButton: .default(Text("Yes")) {
                // Update database
            }, secondaryButton: .cancel(Text("No")))
        }
    }
}

struct StoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        StoryDetailView(story: Story(author: "Sasha", authorUid: "UID", dateCreated: "Aug 11, 2023", title: "A Walk Through The Park", published: true, conversation: [], summary: "In our previous conversation, they recounted an incident during which they were walking to the store and encountered a charming brown cat crossing the street", genres: [.adventure, .funny, .love]))
    }
}
