//
//  profileView.swift
//  LossTracker
//
//  Created by Henry Webb on 10/8/23.
//

import SwiftUI
import PhotosUI
import FirebaseStorage


struct profileView: View {
    @State private var profileImage: UIImage?
    @State private var isImagePickerPresented: Bool = false

    var body: some View {
        NavigationView{
            ZStack {
                Color(red: 8 / 255.0, green: 89 / 255.0, blue: 72 / 255.0)
                    .ignoresSafeArea()
                
                VStack {
                    ZStack {
                        Image("pokerBackground")
                            .resizable()
                            .scaledToFit()
                            .frame(width: screenWidth()/1.5, height: screenWidth()/1.5)
                        
                        Button(action: {
                            isImagePickerPresented.toggle()
                        }) {
                            if let image = profileImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: screenWidth()/2.5, height: screenWidth()/2.5)
                                    .clipShape(Circle())
                            } else {
                                Image("defaultProfile")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: screenWidth()/2.5, height: screenWidth()/2.5)
                                    .clipShape(Circle())
                            }
                        }
                    }
                    
                    Spacer()
                        .frame(height:screenHeight()/10)
                    
                    HStack {
                        Text("First Name")
                        Text("Last Name")
                    }
                    .font(.system(size: screenWidth()/15))
                    .padding()
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .frame(width: screenWidth()/1.4, height: screenHeight()/7)
                        .overlay(
                            VStack {
                                Text("Lifetime Stats")
                                    .font(.system(size: screenWidth()/18))
                                    .bold()
                                
                                HStack {
                                    Text("Total Winnings: $0")
                                        .font(.system(size: screenWidth()/18))

                                }
                                HStack {
                                    Text("Total Games Played: 0")
                                        .font(.system(size: screenWidth()/18))

                                }
                            }
                                .padding()
                                .foregroundColor(.black)
                        )
                        .padding()
                    Spacer()
                        .frame(height:screenHeight()/10)
                    
                    NavigationLink(destination: GameHistoryView()) {
                        Text("View Game History")
                            .navigationBarHidden(true)
                            .bold()
                            .padding(screenWidth()/15)
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(screenWidth()/15)
                            .font(.system(size: screenWidth()/18))

                    }
                    .padding(.top, 20)
                }
                .padding()
                .sheet(isPresented: $isImagePickerPresented, content: {
                    ImagePicker(image: $profileImage)
                })
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var image: UIImage?
    @Environment(\.presentationMode) private var presentationMode
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}


#Preview {
    profileView()
}
