//
//  TutorialView.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-08-25.
//

import SwiftUI

struct TutorialView: View {
    
    @State private var speakingStatus: SpeakingStatus = .willSpeak
    @State private var tutorialStatus: TutorialStatus = .askingIfUserNeedsInformation
    @State private var showButton: Bool = false
    @State private var showInstructions: Bool = false
    @State private var displayCreateView: Bool = false
    @State private var displayMainView: Bool = false
    let textToUtter: [String] = [Constants.WELCOME_PROMPT, Constants.WELCOME_PROMPT_2, Constants.WELCOME_PROMPT_3]
    @State var counter = 0

    @State private var errorType: ErrorHelper.AppErrorType?

    @ObservedObject var speechUtterance = SpeechUtterance()
    @State var transcript: String = ""
    
    @State private var uid: String?
    @State private var user: User?

    var body: some View {
        ZStack {
            Color("#171717").ignoresSafeArea()
            VStack {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text("Hey Storyteller")
                            .font(.system(size: Constants.REGULAR_FONT_SIZE, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text("to get my attention")
                            .font(.system(size: Constants.SUBTEXT_FONT_SIZE, weight: .light))
                            .foregroundColor(Color(.gray))
                    }
                    .padding(.bottom)
                    .padding(.top)
                    VStack(alignment: .trailing) {
                        Text("Let me tell you a story")
                            .font(.system(size: Constants.REGULAR_FONT_SIZE, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text("to begin your story")
                            .font(.system(size: Constants.SUBTEXT_FONT_SIZE, weight: .light))
                            .foregroundColor(Color(.gray))
                    }
                    .padding(.bottom)
                    VStack(alignment: .leading) {
                        Text("The end")
                            .font(.system(size: Constants.REGULAR_FONT_SIZE, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text("to finish your story")
                            .font(.system(size: Constants.SUBTEXT_FONT_SIZE, weight: .light))
                            .foregroundColor(Color(.gray))
                    }
                    .padding(.bottom)
                }
                .padding(.top, 30)
                .opacity(showInstructions ? 1.0 : 0.0)
                
                Spacer()
                switch speakingStatus {
                case .willSpeak:
                    MoonPresentingAnimation()
                case .currentlySpeaking:
                    BeginMoonGlowingAnimation()
                case .stoppedSpeaking:
                    EndMoonGlowingAnimation()
                }
                Spacer()
                Button("Okay") {
                    withAnimation(.easeInOut) {
                        showButton = false
                        showInstructions = false
                    }
                    
                    if counter == 1 {
                        withAnimation(.easeInOut) {
                            showInstructions = true
                        }
                    }
                    
                    utterText()
                }
                .padding()
                .frame(width: UIScreen.screenWidth / 3)
                .font(.system(size: Constants.REGULAR_FONT_SIZE, weight: .regular))
                .foregroundColor(.white)
                .background(Color("#292929"))
                .cornerRadius(12.5)
                .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 2)
                .opacity(showButton ? 1.0 : 0.0)
                .disabled(showButton ? false : true)
            }
        }
        .onAppear() {
            transcript = ""
            uid = LocalStorageHelper.retrieveUser()
            guard uid != nil else {
                print("User not logged in. Please reauthenticate.")
                return
            }
            FirebaseHelper.fetchUserById(id: uid!) { user in
                guard user != nil else {
                    errorType = .reauth
                    return
                }
                self.user = user!
                
                utterText()
            }
        }
        .fullScreenCover(isPresented: $displayCreateView, onDismiss: {
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                displayMainView = true
            }
        }) {
            CreateView().navigationBarBackButtonHidden(true)
        }
        .fullScreenCover(isPresented: $displayMainView) {
            RootView().navigationBarBackButtonHidden(true)
        }
    }
    
    // Method for progressing tutorial and speaking to user
    func utterText() {
        speakingStatus = .currentlySpeaking
        speechUtterance.toggleSpeaking()
        if counter == 3 {
            displayCreateView = true
            return
        }
        speechUtterance.speak(text: counter == 0 ? "Hi \(user!.firstName), " + textToUtter[counter] : textToUtter[counter]) {
            speakingStatus = .stoppedSpeaking
            self.counter += 1
            showButton = true
        }
    }
}

enum TutorialStatus {
    case askingIfUserNeedsInformation
    case askingIfUserWillTellFirstStory
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView()
    }
}
