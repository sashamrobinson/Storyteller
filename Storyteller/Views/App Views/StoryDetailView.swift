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
    
    var body: some View {
        ZStack {
            Color("#171717").ignoresSafeArea()
            VStack() {
                VStack() {
                    Color.blue.frame(width: 250, height: 250)
                    HStack {
                        VStack(alignment: .leading) {
                            Text(story.dateCreated)
                                .foregroundColor(Color.white.opacity(0.5))
                                .font(.system(size: Constants.SUBTEXT_FONT_SIZE, weight: .regular))
                            
                            Text(story.title)
                                .foregroundColor(Color.white)
                                .font(.system(size: Constants.REGULAR_FONT_SIZE, weight: .regular))
                                .padding(.bottom, 5)


                            Text("By " + story.author)
                                .foregroundColor(Color.white.opacity(0.5))
                                .font(.system(size: Constants.REGULAR_FONT_SIZE, weight: .regular))
                        }
                        .padding()
                        Spacer()
                        Button(action: {
                            // TODO: - Refactor code to work with just one variable, issues with @Published wrapper
                            isSpeaking.toggle()
                            speechUtterance.toggleSpeaking()
                            print(speechUtterance.speaker.isPaused)
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
                .background(.clear)
                .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 2)
                
                ScrollView {
                    VStack {
                        Text(text)
                    }
                    .foregroundColor(.white)
                }
                .padding()
                .background(.blue)
                .cornerRadius(12.5)
                .padding()
                .ignoresSafeArea()
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
        }
    }
}

struct StoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        StoryDetailView(story: Story(author: "Sasha", authorUid: "UID", dateCreated: "Aug 11, 2023", title: "A Walk Through The Park", published: true, conversation: []))
    }
}
