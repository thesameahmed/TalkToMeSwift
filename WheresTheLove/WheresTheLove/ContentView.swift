//
//  ContentView.swift
//  WheresTheLove
//
//  Created by Dreams on 3/8/23.
//


import SwiftUI
import AVFoundation
import Speech



struct ContentView: View {
    var body: some View {
        NavigationView {
            DocumentEditorView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



struct DocumentEditorView: View {
    @State private var documentText = ""
    @State private var speechSynthesizer = AVSpeechSynthesizer()
    @State private var selectedVoiceIndex = 0
    
    var body: some View {
        VStack {
            TextEditor(text: $documentText)
                .padding()
            
            HStack {
                Button(action: {
                    pasteText()
                }) {
                    Label("Paste", systemImage: "doc.on.clipboard")
                }
                Spacer()
                Button(action: {
                    speakDocument()
                }) {
                    Label("Speak", systemImage: "speaker.wave.2.fill")
                }
                Picker(selection: $selectedVoiceIndex, label: Text("Voice")) {
                    ForEach(0..<AVSpeechSynthesisVoice.speechVoices().count) { index in
                        Text(AVSpeechSynthesisVoice.speechVoices()[index].name)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            .padding()
            
            Spacer()
            
            Divider()
            
            HStack {
                Button(action: {
                    printDocument()
                }) {
                    Label("Print", systemImage: "printer")
                }
                
                Spacer()
                
                Button(action: {
                    saveDocument()
                }) {
                    Label("Save", systemImage: "square.and.arrow.down")
                }
            }
            .padding()
        }
        .navigationTitle("Document Editor")
    }
    
    func pasteText() {
        if let pastedText = UIPasteboard.general.string {
            documentText += pastedText
        }
    }
    
    func speakDocument() {
        let speechUtterance = AVSpeechUtterance(string: documentText)
        speechUtterance.voice = AVSpeechSynthesisVoice.speechVoices()[selectedVoiceIndex]
        speechSynthesizer.speak(speechUtterance)
    }
    
    func printDocument() {
        let printController = UIPrintInteractionController.shared
        let printInfo = UIPrintInfo(dictionary:nil)
        printInfo.outputType = .general
        printInfo.jobName = "My Document"
        printController.printInfo = printInfo
        printController.printFormatter = UIPrintFormatter()
        printController.printPageRenderer = UIPrintPageRenderer()
        printController.present(animated: true, completionHandler: nil)
    }

    
    func saveDocument() {
        // Implement document saving functionality here
    }
}
