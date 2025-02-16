//
//  ContentView.swift
//  BipTheGuy
//
//  Created by 刘佳雨 on 2025/2/16.
//

import SwiftUI
import AVFAudio
import PhotosUI

struct ContentView: View {
    @State private var audioPlayer: AVAudioPlayer!
//    @State private var scale = 1.0 // 100% scale, or original size
    @State private var isFullSize = true
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var bipImage = Image("clown")
    
    var body: some View {
        VStack {
            Spacer()
            
            bipImage
                .resizable()
                .scaledToFit()
                .scaleEffect(isFullSize ? 1.0 : 0.9)
                .onTapGesture{
                    playSound(soundName: "punchSound")
                    isFullSize = false // will immediately shrink using .scaleEffect to 90% of size
                    withAnimation (.spring(response: 0.3, dampingFraction: 0.3)) {
                        isFullSize = true // will go from 90% to 100% size but usin gthe .spring animation
                    }
//                    scale = scale + 0.1 // increase scale by 10%
                }
//                .animation(.spring(response: 0.3, dampingFraction: 0.05), value: scale) // dampingFraction越小越bouncy，response越小bounce的越快
            
            Spacer()
            PhotosPicker(selection: $selectedPhoto, matching: .images, preferredItemEncoding: .automatic) {
                Label("Photo Library", systemImage: "photo.fill.on.rectangle.fill")
            }
            .onChange(of: selectedPhoto) {
                Task {
                    guard let selectedImage = try? await selectedPhoto?.loadTransferable(type: Image.self) else {
                        print("😡ERROR: Could not get Image frmo loadTransferable")
                        return
                    }
                    bipImage = selectedImage
                }
            }
        }
        .padding()
    }
    
    func playSound(soundName: String){
        if audioPlayer != nil && audioPlayer.isPlaying{
            audioPlayer.stop()
        }
        guard let soundFile = NSDataAsset(name: soundName) else{
            print("😡 Could not read file named \(soundName)")
            return
        }
        do{
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        } catch{
            print("😡 ERROR: \(error.localizedDescription) creating audioPlayer")
        }
    }
}

#Preview {
    ContentView()
}
